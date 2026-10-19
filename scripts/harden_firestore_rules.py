"""Patch live Firestore rules conservatively, preserving unrelated access."""
from pathlib import Path

s = Path("firestore-live-before.rules").read_text(encoding="utf-8")
a = "    match /users/{userId} {\n"
b = """    match /users/{userId} {
      match /private/{docId} {
        allow read: if isOwner(userId);
        allow write: if false;
      }
"""
assert s.count(a) == 1
s = s.replace(a,b,1)
a = """      allow update: if signedIn()
        && (
          resource.data.ownerId == request.auth.uid"""
b = """      allow update: if signedIn()
        && !request.resource.data.diff(resource.data).affectedKeys().hasAny(['giftTotal'])
        && (
          resource.data.ownerId == request.auth.uid"""
assert s.count(a) == 1
s = s.replace(a,b,1)
a = """              'updatedAt',
              'giftTotal'
"""
b = """              'updatedAt'
"""
assert s.count(a) == 1
s = s.replace(a,b,1)
a = """        allow create: if signedIn()
          && request.resource.data.fromId == request.auth.uid;"""
b = """        allow create: if signedIn()
          && request.resource.data.type == 'chat'
          && request.resource.data.fromId == request.auth.uid;"""
assert s.count(a) == 1
s = s.replace(a,b,1)
needle = """    // ==========================================================
    // CUAN ID COUNTER"""
assert s.count(needle) == 1
s=s.replace(needle,"""    // Coin seller roles and economy audit records are server-only.
    match /coinSellers/{sellerId} {
      allow read, write: if false;
    }
    match /economyTransactions/{txId} {
      allow read, write: if false;
    }
    match /giftTransactions/{txId} {
      allow read, write: if false;
    }

"""+needle,1)
Path("firestore-launch.rules").write_text(s,encoding="utf-8")
Path("firebase.safety.json").write_text('{"firestore":{"rules":"firestore-launch.rules"}}')
print("Private economy protected; fake gift messages and gift total updates blocked.")
