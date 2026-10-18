# CUAN PARTY — 18 Oct 2026: Coin and Gifts

## Updated packages (IDR)
| Price | Coin |
|---|---:|
| Rp 5.000 | 250.000 |
| Rp 10.000 | 500.000 |
| Rp 20.000 | 1.025.000 |
| Rp 50.000 | 2.625.000 |
| Rp 100.000 | 5.375.000 |
| Rp 250.000 | 13.750.000 |
| Rp 500.000 | 28.125.000 |
| Rp 1.000.000 | 57.500.000 |

Source of truth for prices displayed: `lib/coin_packages.dart`.

## Payment status
- No payment gateway is configured.
- The old client-side "topup success" simulation was removed because it incorrectly minted coins without payment.
- Production recharge requires verified payment callback, protected backend balance adjustments, and transaction history.

## Gift status
- Client gift UI and `sendRoomGift` backend call already exist.
- Previous GitHub Actions deployment (13 Oct 2026) was blocked because Firebase project `cuan-party` required Blaze billing plan for `artifactregistry.googleapis.com`.
- To activate real gift sending, enable Firebase Blaze with budget alerts, then successfully deploy `sendGift` and `sendRoomGift` callables via `.github/workflows/deploy-gifts.yml` and test a real room transaction.
- Do not simulate deduction or credit balances on the client.

## Validation
- `flutter analyze lib/luxury_app.dart lib/coin_packages.dart` passed in the Apply CUAN PARTY coin pricing workflow.
- `flutter test test/coin_packages_test.dart` passed.
- Voice-room quality and full end-to-end gift transactions are not proven by these checks.
