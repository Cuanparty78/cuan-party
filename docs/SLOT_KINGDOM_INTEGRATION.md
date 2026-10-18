# SLOT KINGDOM — account integration

This branch bundles the current standalone game into the Flutter app and moves spin settlement, account numbering, bonus state and Gold Bank into authenticated Firebase callables. It does not publish the APK or activate charging automatically.

## Behaviour

- Game hub opens the full game; room menu opens a 72% height sheet so the room remains visible.
- The coin `+` opens the existing WalletPage. It does not grant coins or implement a payment processor.
- Identity is taken exclusively from Firebase Auth, never the WebView payload.
- `users/{uid}/private/slotKingdom` retains the account's counter and free game state. Numbering begins at 1 and includes both paid and free spins; failures and Gold Bank claims do not count.
- History is stored under that document's `spins` collection; the latest 200 are displayed. Records persist across logout, reopening and devices.
- A server transaction atomically updates the wallet, counter, bonus, history and operation receipt. Persisted transaction IDs recover a lost response without charging/counting twice. Two devices submitting the same expected sequence cannot both settle it.
- Gold Bank accumulates 1% of paid bets; 23:00 Asia/Jakarta rollover and 24-hour expiry use server time. Claim credit and receipt are atomic.
- The same engine uses a shared 5,000x paid spin + bonus session ceiling and combo up to 1,024x. Account balance, losses and prior wins do not change probabilities. This integration does not establish or guarantee operator profitability or certified RTP.
- CUAN PARTY wallets use integer coins. Fractional winnings and Gold Bank claims are retained in `coinRemainder` and carried forward, rather than discarded or changed into free coins.
- Browser standalone balances/history are not imported into authenticated accounts.

## Activation checklist

1. Merge this branch, run the integration checks and build an APK with the repository's existing workflow. Test on an Android device, including music/voice, room sheet sizing, recharge navigation, backgrounding, account switching and disconnect recovery.
2. Deploy Firebase Functions using the existing workflow. This adds `slotKingdomGetState`, `slotKingdomSpin` and `slotKingdomClaimGoldBank` in `asia-southeast2`.
3. Audit the **existing deployed Firestore security rules**, which are not tracked in this repository. Clients must not write `coin`/economy, slot state/history/operation receipts, or `gameConfig`. A narrow deny does not override a broad wildcard allow. Do not activate this game while such an allow exists. The Admin SDK callables bypass client rules. Example constraints for the existing rules to incorporate (not a complete ruleset):

   - Owner profile creation may initialize `coin` and `diamond` to zero only.
   - Owner profile updates must exclude financial fields using `diff(resource.data).affectedKeys()`.
   - All client writes to `users/{uid}/private/economy` and `users/{uid}/private/slotKingdom/{document=**}` must be denied.
   - All client writes to `gameConfig/{document=**}` must be denied.
   - Private document reads must require `request.auth.uid == uid`.

4. Only after those checks, create `gameConfig/slotKingdom` via Firebase console/Admin SDK with `enabled: true`. Missing/false config rejects paid spins and claims before any charge or sequence increment. Set it false to stop new transactions. Retrying an already settled operation still returns its saved receipt.
5. Validate payment/webhook reconciliation, liabilities and actual game maths before a production coin economy or commercial rental. Payment integration, tenant isolation/licensing, production telemetry and certification are outside this branch.

## Validation

`node --test functions/test/*.test.js` runs deterministic engine/account tests with an optimistic transaction double, covering retry collisions, device collisions, UID isolation, reopens, insufficient funds, free spins, cap, fractional credits, rollover/expiry and duplicate claims. It is not a Firestore emulator or live deployment test.

The PR workflow additionally installs Flutter dependencies and analyzes the new host widget. No Flutter runtime or Android device is available in the editing environment; device QA remains required before activation.

Do not delete operation receipts without a designed idempotency retention policy. Do not reset an existing account counter when releasing a new APK.
