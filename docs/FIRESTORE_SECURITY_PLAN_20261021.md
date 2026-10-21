# CUAN PARTY — Firestore Rules Review (21 Oktober 2026)

**Status: DRAFT REVIEW. NOT PUBLISHED TO FIREBASE. NOT SAFE TO PASTE AS A COMPLETE RULESET.**

Source: user-provided Firestore production rules in chat; code checked at `lib/user_service.dart` on `cuan-party-stabilization-review`. Railway gift writes remain disabled, must NOT flip them just because a rules review was done.

## What the current rules do correctly
- `users/{uid}/private/{doc}` client writes are denied.
- A completed user can only update allowlisted profile fields; Coin, Diamond, VIP and SVIP cannot be directly changed by the client.
- `coinSellers`, `economyTransactions`, `giftTransactions` client access is denied.
- Client room updates cannot directly modify `giftTotal`.
- Client room messages with `type='gift'` cannot be created using the current `messages` rules.
- Server Admin SDK can make atomic writes irrespective of Firestore Rules; **backend logic must validate every transaction**.

## Finding A — shared CUAN ID counter (CRITICAL)
`/meta/cuan_id_counter` may be incremented by ANY authenticated account. A user could repeatedly increment it to exhaust/disrupt IDs.

**Important: DO NOT just replace its update/create rules with `false` yet.** Current `lib/user_service.dart` calls client-side transactions in `UserService.completeRegistration()` and `UserService._allocateCuanId()`; doing so would break signup/repair. Further, `_hasTripleRepeatedDigits` may skip >1 increment while rules currently require exactly +1.

Safe migration:
1. Implement authenticated, idempotent **backend** registration/ID allocator: store ID reservation at `users/{uid}` or stable reservation keyed by UID, use server-side transaction over counter and user doc, enforce six-to-thirteen digits, and use transaction retries.
2. Change Flutter registration + profile-repair code to call backend. Ensure existing registered UID preserves old ID and wallet; never overwrite nonzero balances.
3. Test two registrations concurrently and repeated same UID.
4. Only then publish:
```
match /meta/{documentId} {
  allow read: if signedIn() && documentId == 'cuan_id_counter';
  allow create, update, delete: if false;
}
```

## Finding B — room counters (HIGH)
Current `rooms/{roomId}` update allows ANY signed-in account to modify `memberCount` and `memberIds` — no proof that change corresponds to their own membership. These fields may drive seat/room presence and must not be trusted for security.

Safe migration:
1. Identify actual join/leave writes in Flutter.
2. Derive presence on trusted backend or use a validated transaction binding `request.auth.uid` to a single membership change; cap sizes and preserve other members.
3. Ensure room membership rules are scoped to the member's own UID.
4. After app migration, restrict `memberCount` and `memberIds` to server only. **Do not publish this restrictive change before join/leave tests.**

## Finding C — room members / possible privilege escalation (HIGH)
`rooms/{roomId}/members/{uid}` allows member `uid` to update ALL fields. If roles like `admin`/`role`/`isAdmin` live there, users can elevate themselves. They can also create their membership document with a privileged role if not validated. Owner must remain empowered to moderate members.

Draft pattern (must customize to real member field schema):
```
function isValidNewMember(uid) {
  return request.auth.uid == uid
    && !request.resource.data.keys().hasAny([
       'isAdmin','admin','isOwner','isModerator'
    ])
    && (!request.resource.data.keys().hasAny(['role'])
        || request.resource.data.role == 'member');
}
function isSafeMemberUpdate(uid) {
  return request.auth.uid == uid
    && request.resource.data.diff(resource.data).affectedKeys()
      .hasOnly(['name','photoUrl','avatarUrl','lastSeenAt','lastActivityAt','updatedAt']);
}
```
Use these in `rooms/{roomId}/members/{uid}` create/update, with a separate explicit owner path for assigning/revoking admin. Confirm exact names and heartbeat fields before publishing.

## Additional review points before Gift live
- `rooms/{roomId}/messages` allows any signed-in user to send chat without testing membership, content bounds or closed-chat policy. UI owner/admin-only chat cannot be a security boundary. 
- `rooms/{roomId}/seats` allows a signed-in user to write a seat when the payload's `uid` equals their UID, even if the seat is occupied by another UID. Restrict seat updates to vacant seats or the existing holder; owner/admin handling separate.
- `rooms/{roomId}` create must not accept privileged owner-maintenance fields in arbitrary payload beyond the required starting values.
- Validate `walletHistory`, `stockHistory` subcollections: no explicit Rules match → client access denied, but server admin reads/writes expected.
- Ensure Room ID form matches the server gift regular expression `^[\\w-]{4,160}$`, or legitimate gifts could return HTTP 400.
- On gift server: test recipient resolution by unique ID rather than display name; reject spoofed/duplicate name.

## Launch sequence — safety and nonbreaking requirements
1. Keep live `GIFT_WRITES_ENABLED=false`.
2. Implement and test account ID allocation migration and room membership/counter changes in a controlled staging environment; no blanket rules overwrite.
3. Execute Firestore Emulator rule tests for account, seller, gift and room privilege abuse (including rules path coverage), plus Android/iPhone join/leave and registration smoke tests.
4. Publish verified rules once authorized by Owner.
5. Test sending minimal Gift from A to B: A Coin charged, B Diamond credited 100%, exactly one message + ledger entry; duplicate request idempotent; test self-gift.
6. Only after verifiable security and transactional checks, turn `GIFT_WRITES_ENABLED=true` for limited testing with Owner approval and rate 100% Gift / 70% Exchange.
