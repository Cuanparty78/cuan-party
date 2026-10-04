const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue, Timestamp } = require("firebase-admin/firestore");

initializeApp();
setGlobalOptions({ region: "asia-southeast2", maxInstances: 10 });

const db = getFirestore();

const VIP_PRICES = [
  0,
  7000000,
  14000000,
  24000000,
  34000000,
  51000000,
  85000000,
  135000000,
  200000000,
  330000000,
  500000000,
];

const VIP_CHECKINS = [
  0,
  200000,
  400000,
  700000,
  1000000,
  1500000,
  2500000,
  4000000,
  6000000,
  10000000,
  15000000,
];

// Authoritative server-side gift prices.
// The Flutter client may display a price, but the backend never trusts it.
const GIFT_CATALOG = Object.freeze({
  royal_crown: { name: "Royal Crown", price: 200000 },
  golden_wings: { name: "Golden Wings", price: 20000 },
  love_crown: { name: "Love Crown", price: 20000 },
  fantasy: { name: "Fantasy", price: 20000 },
  royal_car: { name: "Royal Car", price: 20000 },
  queen_crown: { name: "Queen Crown", price: 20000 },
  golden_wings_alt: { name: "Golden Wings", price: 20000 },
});

function requireAuth(request) {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Login diperlukan.");
  }
  return request.auth.uid;
}

function asInt(value, name, min, max) {
  if (!Number.isInteger(value) || value < min || value > max) {
    throw new HttpsError("invalid-argument", `${name} tidak valid.`);
  }
  return value;
}

function validateTransactionId(value) {
  if (
    typeof value !== "string" ||
    value.length < 8 ||
    value.length > 128 ||
    value.includes("/")
  ) {
    throw new HttpsError("invalid-argument", "transactionId tidak valid.");
  }
  return value;
}

function refsFor(uid) {
  const userRef = db.collection("users").doc(uid);
  const economyRef = userRef.collection("private").doc("economy");
  return { userRef, economyRef };
}

function economyFrom(rootData, economyData) {
  const root = rootData || {};
  const econ = economyData || {};

  return {
    coin: Number.isFinite(econ.coin)
      ? Math.trunc(econ.coin)
      : Math.trunc(root.coin || 0),
    diamond: Number.isFinite(econ.diamond)
      ? Math.trunc(econ.diamond)
      : Math.trunc(root.diamond || 0),
    vipLevel: Number.isFinite(econ.vipLevel)
      ? Math.trunc(econ.vipLevel)
      : Math.trunc(root.vip || 0),
    vipExpiresAt: econ.vipExpiresAt || null,
    svipLevel: Number.isFinite(econ.svipLevel)
      ? Math.trunc(econ.svipLevel)
      : Math.trunc(root.svip || 0),
    svipPoints: Number.isFinite(econ.svipPoints)
      ? Math.trunc(econ.svipPoints)
      : Math.trunc(root.svipPoints || 0),
    lastVipCheckinKey:
      typeof econ.lastVipCheckinKey === "string"
        ? econ.lastVipCheckinKey
        : "",
    svipPeriodEndsAt: econ.svipPeriodEndsAt || null,
    targetPoints: Number.isFinite(econ.targetPoints)
      ? Math.trunc(econ.targetPoints)
      : null,
  };
}

function giftByName(name) {
  if (typeof name !== "string") return null;
  const normalized = name.trim().toLowerCase();

  for (const [id, gift] of Object.entries(GIFT_CATALOG)) {
    if (gift.name.toLowerCase() === normalized) {
      return { id, ...gift };
    }
  }

  return null;
}

exports.getSvipStatus = onCall(async (request) => {
  const uid = requireAuth(request);
  const { userRef, economyRef } = refsFor(uid);

  const [rootSnap, econSnap] = await Promise.all([
    userRef.get(),
    economyRef.get(),
  ]);

  const econ = economyFrom(rootSnap.data(), econSnap.data());

  const level = Math.max(0, Math.min(10, econ.svipLevel));
  const points = Math.max(0, econ.svipPoints);
  const target =
    econ.targetPoints !== null
      ? Math.max(0, econ.targetPoints)
      : level <= 1
        ? 100000000
        : 0;

  let daysRemaining = 60;

  if (
    econ.svipPeriodEndsAt &&
    typeof econ.svipPeriodEndsAt.toMillis === "function"
  ) {
    daysRemaining = Math.max(
      0,
      Math.ceil(
        (econ.svipPeriodEndsAt.toMillis() - Date.now()) / 86400000,
      ),
    );
  }

  return { level, points, target, daysRemaining };
});

exports.purchaseVip = onCall(async (request) => {
  const uid = requireAuth(request);
  const vipLevel = asInt(request.data?.vipLevel, "vipLevel", 1, 10);
  const transactionId = validateTransactionId(request.data?.transactionId);
  const price = VIP_PRICES[vipLevel];

  const { userRef, economyRef } = refsFor(uid);
  const transactionRef = db
    .collection("economyTransactions")
    .doc(transactionId);

  const expiresAt = Timestamp.fromMillis(
    Date.now() + 30 * 86400000,
  );

  return db.runTransaction(async (tx) => {
    const [idempotencySnap, rootSnap, econSnap] = await Promise.all([
      tx.get(transactionRef),
      tx.get(userRef),
      tx.get(economyRef),
    ]);

    if (idempotencySnap.exists) {
      const saved = idempotencySnap.data() || {};

      if (saved.uid !== uid || saved.type !== "purchaseVip") {
        throw new HttpsError(
          "already-exists",
          "transactionId sudah digunakan.",
        );
      }

      return saved.result || {};
    }

    const econ = economyFrom(rootSnap.data(), econSnap.data());

    if (econ.coin < price) {
      throw new HttpsError(
        "failed-precondition",
        "Coin tidak cukup.",
      );
    }

    const newCoin = econ.coin - price;
    const result = {
      coin: newCoin,
      vipLevel,
      vipExpiresAtMs: expiresAt.toMillis(),
    };

    tx.set(
      economyRef,
      {
        coin: newCoin,
        diamond: econ.diamond,
        vipLevel,
        vipExpiresAt: expiresAt,
        svipLevel: econ.svipLevel,
        svipPoints: econ.svipPoints,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.set(
      userRef,
      {
        coin: newCoin,
        vip: vipLevel,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.set(transactionRef, {
      uid,
      type: "purchaseVip",
      amount: price,
      vipLevel,
      createdAt: FieldValue.serverTimestamp(),
      result,
    });

    return result;
  });
});

exports.claimVipCheckin = onCall(async (request) => {
  const uid = requireAuth(request);
  const dateKey = request.data?.dateKey;
  const transactionId = validateTransactionId(request.data?.transactionId);

  if (
    typeof dateKey !== "string" ||
    !/^\d{4}-\d{2}-\d{2}$/.test(dateKey)
  ) {
    throw new HttpsError(
      "invalid-argument",
      "dateKey tidak valid.",
    );
  }

  const { userRef, economyRef } = refsFor(uid);
  const transactionRef = db
    .collection("economyTransactions")
    .doc(transactionId);

  return db.runTransaction(async (tx) => {
    const [idempotencySnap, rootSnap, econSnap] = await Promise.all([
      tx.get(transactionRef),
      tx.get(userRef),
      tx.get(economyRef),
    ]);

    if (idempotencySnap.exists) {
      const saved = idempotencySnap.data() || {};

      if (saved.uid !== uid || saved.type !== "vipCheckin") {
        throw new HttpsError(
          "already-exists",
          "transactionId sudah digunakan.",
        );
      }

      return saved.result || {};
    }

    const econ = economyFrom(rootSnap.data(), econSnap.data());

    if (econ.vipLevel < 1 || econ.vipLevel > 10) {
      throw new HttpsError(
        "failed-precondition",
        "VIP tidak aktif.",
      );
    }

    if (
      !econ.vipExpiresAt ||
      typeof econ.vipExpiresAt.toMillis !== "function" ||
      econ.vipExpiresAt.toMillis() <= Date.now()
    ) {
      throw new HttpsError(
        "failed-precondition",
        "Masa VIP sudah habis.",
      );
    }

    if (econ.lastVipCheckinKey === dateKey) {
      throw new HttpsError(
        "already-exists",
        "Check-in hari ini sudah diambil.",
      );
    }

    const reward = VIP_CHECKINS[econ.vipLevel];
    const newCoin = econ.coin + reward;
    const result = {
      coin: newCoin,
      reward,
      vipLevel: econ.vipLevel,
      dateKey,
    };

    tx.set(
      economyRef,
      {
        coin: newCoin,
        lastVipCheckinKey: dateKey,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.set(
      userRef,
      {
        coin: newCoin,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.set(transactionRef, {
      uid,
      type: "vipCheckin",
      reward,
      dateKey,
      createdAt: FieldValue.serverTimestamp(),
      result,
    });

    return result;
  });
});

exports.exchangeDiamondToCoin = onCall(async (request) => {
  const uid = requireAuth(request);
  const diamond = asInt(
    request.data?.diamond,
    "diamond",
    100,
    1000000000000,
  );
  const transactionId = validateTransactionId(request.data?.transactionId);

  if (diamond % 100 !== 0) {
    throw new HttpsError(
      "invalid-argument",
      "Diamond harus kelipatan 100.",
    );
  }

  const { userRef, economyRef } = refsFor(uid);
  const transactionRef = db
    .collection("economyTransactions")
    .doc(transactionId);

  return db.runTransaction(async (tx) => {
    const [idempotencySnap, rootSnap, econSnap] = await Promise.all([
      tx.get(transactionRef),
      tx.get(userRef),
      tx.get(economyRef),
    ]);

    if (idempotencySnap.exists) {
      const saved = idempotencySnap.data() || {};

      if (saved.uid !== uid || saved.type !== "diamondExchange") {
        throw new HttpsError(
          "already-exists",
          "transactionId sudah digunakan.",
        );
      }

      return saved.result || {};
    }

    const econ = economyFrom(rootSnap.data(), econSnap.data());

    if (econ.diamond < diamond) {
      throw new HttpsError(
        "failed-precondition",
        "Diamond tidak cukup.",
      );
    }

    const coinAdded = Math.floor((diamond * 70) / 100);
    const newDiamond = econ.diamond - diamond;
    const newCoin = econ.coin + coinAdded;

    const result = {
      coin: newCoin,
      diamond: newDiamond,
      coinAdded,
    };

    tx.set(
      economyRef,
      {
        coin: newCoin,
        diamond: newDiamond,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.set(
      userRef,
      {
        coin: newCoin,
        diamond: newDiamond,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.set(transactionRef, {
      uid,
      type: "diamondExchange",
      diamondSpent: diamond,
      coinAdded,
      createdAt: FieldValue.serverTimestamp(),
      result,
    });

    return result;
  });
});

exports.sendGift = onCall(async (request) => {
  const senderUid = requireAuth(request);
  const receiverUid = request.data?.receiverUid;
  const giftId = request.data?.giftId;
  const quantity = asInt(
    request.data?.quantity,
    "quantity",
    1,
    7777,
  );
  const transactionId = validateTransactionId(request.data?.transactionId);

  if (
    typeof receiverUid !== "string" ||
    receiverUid.length < 1 ||
    receiverUid.length > 128
  ) {
    throw new HttpsError(
      "invalid-argument",
      "receiverUid tidak valid.",
    );
  }

  const gift = GIFT_CATALOG[giftId];

  if (!gift) {
    throw new HttpsError(
      "not-found",
      "Gift tidak ditemukan.",
    );
  }

  const total = gift.price * quantity;
  const senderRefs = refsFor(senderUid);
  const receiverRefs = refsFor(receiverUid);
  const transactionRef = db
    .collection("economyTransactions")
    .doc(transactionId);
  const giftRef = db
    .collection("giftTransactions")
    .doc(transactionId);

  return db.runTransaction(async (tx) => {
    const [
      idempotencySnap,
      senderRoot,
      senderEcon,
      receiverRoot,
    ] = await Promise.all([
      tx.get(transactionRef),
      tx.get(senderRefs.userRef),
      tx.get(senderRefs.economyRef),
      tx.get(receiverRefs.userRef),
    ]);

    if (idempotencySnap.exists) {
      const saved = idempotencySnap.data() || {};

      if (saved.uid !== senderUid || saved.type !== "gift") {
        throw new HttpsError(
          "already-exists",
          "transactionId sudah digunakan.",
        );
      }

      return saved.result || {};
    }

    if (!receiverRoot.exists) {
      throw new HttpsError(
        "not-found",
        "Penerima tidak ditemukan.",
      );
    }

    const econ = economyFrom(
      senderRoot.data(),
      senderEcon.data(),
    );

    if (econ.coin < total) {
      throw new HttpsError(
        "failed-precondition",
        "Coin tidak cukup.",
      );
    }

    const newCoin = econ.coin - total;

    // Intentionally 0 until CUAN PARTY's final receiver conversion
    // policy is configured server-side.
    const diamondReward = 0;

    const result = {
      coin: newCoin,
      giftId,
      giftName: gift.name,
      quantity,
      total,
      receiverUid,
      diamondReward,
    };

    tx.set(
      senderRefs.economyRef,
      {
        coin: newCoin,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.set(
      senderRefs.userRef,
      {
        coin: newCoin,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.set(giftRef, {
      senderUid,
      receiverUid,
      giftId,
      giftName: gift.name,
      quantity,
      unitPrice: gift.price,
      total,
      diamondReward,
      createdAt: FieldValue.serverTimestamp(),
    });

    tx.set(transactionRef, {
      uid: senderUid,
      type: "gift",
      createdAt: FieldValue.serverTimestamp(),
      result,
    });

    return result;
  });
});

exports.sendRoomGift = onCall(async (request) => {
  const senderUid = requireAuth(request);
  const roomId = request.data?.roomId;
  const targetName = request.data?.targetName;
  const giftName = request.data?.giftName;
  const quantity = asInt(
    request.data?.quantity,
    "quantity",
    1,
    7777,
  );
  const transactionId = validateTransactionId(request.data?.transactionId);

  if (
    typeof roomId !== "string" ||
    roomId.length < 1 ||
    roomId.length > 160 ||
    roomId.includes("/")
  ) {
    throw new HttpsError(
      "invalid-argument",
      "roomId tidak valid.",
    );
  }

  if (
    typeof targetName !== "string" ||
    targetName.trim().length < 1 ||
    targetName.length > 100
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Target gift tidak valid.",
    );
  }

  const gift = giftByName(giftName);

  if (!gift) {
    throw new HttpsError(
      "not-found",
      "Gift tidak ditemukan.",
    );
  }

  const roomRef = db.collection("rooms").doc(roomId);
  const senderMemberRef = roomRef
    .collection("members")
    .doc(senderUid);
  const senderRootRef = db
    .collection("users")
    .doc(senderUid);
  const senderEconomyRef = senderRootRef
    .collection("private")
    .doc("economy");

  let receiverUid = senderUid;
  let receiverName = targetName.trim();

  const senderRootOutside = await senderRootRef.get();
  const senderName =
    (senderRootOutside.data()?.displayName || "").trim();

  if (
    !(
      receiverName === "Saya" ||
      (senderName && receiverName === senderName)
    )
  ) {
    const targetQuery = await roomRef
      .collection("members")
      .where("name", "==", receiverName)
      .limit(2)
      .get();

    if (targetQuery.empty) {
      throw new HttpsError(
        "not-found",
        "Penerima tidak ada di room.",
      );
    }

    if (targetQuery.size > 1) {
      throw new HttpsError(
        "failed-precondition",
        "Nama penerima tidak unik. Pilih user berdasarkan ID.",
      );
    }

    receiverUid = targetQuery.docs[0].id;
  }

  const receiverMemberRef = roomRef
    .collection("members")
    .doc(receiverUid);
  const transactionRef = db
    .collection("economyTransactions")
    .doc(transactionId);
  const giftRef = db
    .collection("giftTransactions")
    .doc(transactionId);
  const messageRef = roomRef
    .collection("messages")
    .doc();

  return db.runTransaction(async (tx) => {
    const [
      idempotencySnap,
      roomSnap,
      senderMemberSnap,
      receiverMemberSnap,
      senderRootSnap,
      senderEconSnap,
    ] = await Promise.all([
      tx.get(transactionRef),
      tx.get(roomRef),
      tx.get(senderMemberRef),
      tx.get(receiverMemberRef),
      tx.get(senderRootRef),
      tx.get(senderEconomyRef),
    ]);

    if (idempotencySnap.exists) {
      const saved = idempotencySnap.data() || {};

      if (
        saved.uid !== senderUid ||
        saved.type !== "roomGift"
      ) {
        throw new HttpsError(
          "already-exists",
          "transactionId sudah digunakan.",
        );
      }

      return saved.result || {};
    }

    if (
      !roomSnap.exists ||
      roomSnap.data()?.isActive === false
    ) {
      throw new HttpsError(
        "not-found",
        "Room tidak aktif.",
      );
    }

    if (!senderMemberSnap.exists) {
      throw new HttpsError(
        "failed-precondition",
        "Masuk room terlebih dahulu.",
      );
    }

    if (!receiverMemberSnap.exists) {
      throw new HttpsError(
        "not-found",
        "Penerima sudah keluar dari room.",
      );
    }

    const econ = economyFrom(
      senderRootSnap.data(),
      senderEconSnap.data(),
    );

    const total = gift.price * quantity;

    if (econ.coin < total) {
      throw new HttpsError(
        "failed-precondition",
        "Coin tidak cukup.",
      );
    }

    const senderNameResolved =
      senderMemberSnap.data()?.name ||
      senderRootSnap.data()?.displayName ||
      "User";

    const receiverNameResolved =
      receiverMemberSnap.data()?.name ||
      receiverName;

    const newCoin = econ.coin - total;

    // Set from server-side gift policy later.
    const diamondReward = 0;

    const result = {
      coin: newCoin,
      roomId,
      receiverUid,
      giftId: gift.id,
      giftName: gift.name,
      quantity,
      total,
      diamondReward,
      messageId: messageRef.id,
    };

    tx.set(
      senderEconomyRef,
      {
        coin: newCoin,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.set(
      senderRootRef,
      {
        coin: newCoin,
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    tx.update(roomRef, {
      giftTotal: FieldValue.increment(total),
      lastActivityAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });

    tx.set(messageRef, {
      type: "gift",
      fromId: senderUid,
      fromName: senderNameResolved,
      toId: receiverUid,
      toName: receiverNameResolved,
      giftId: gift.id,
      giftName: gift.name,
      quantity,
      coinCost: total,
      createdAt: FieldValue.serverTimestamp(),
    });

    tx.set(giftRef, {
      senderUid,
      receiverUid,
      roomId,
      giftId: gift.id,
      giftName: gift.name,
      quantity,
      unitPrice: gift.price,
      total,
      diamondReward,
      createdAt: FieldValue.serverTimestamp(),
    });

    tx.set(transactionRef, {
      uid: senderUid,
      type: "roomGift",
      createdAt: FieldValue.serverTimestamp(),
      result,
    });

    return result;
  });
});
