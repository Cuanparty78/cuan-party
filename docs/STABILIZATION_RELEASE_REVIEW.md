# CUAN PARTY • Review Stabilitas Sebelum Rilis (21 Oktober 2026)

Status: **HANYA KODE DI BRANCH REVIEW — BELUM DIPAKAI SERVER ATAU APK PRODUKSI**.
Jangan merge/trigger build/deploy sampai Owner menyetujui satu rilis gabungan.

## Akar masalah yang sudah dipastikan
- API produksi Railway masih menjalankan image function-bun lama; log GET `/api/seller/me` dan `/api/wallet/history` menghasilkan **405** padahal endpoint tersedia di kode baru.
- Log `/gift/send` menghasilkan **503**, sesuai pengaman `GIFT_WRITES_ENABLED=false`. BUKAN bukti gift sudah aman untuk diaktifkan.
- Error Safari `missing initial state` berasal dari alur penyimpanan state autentikasi Google/Firebase. Menampilkan pesan/petunjuk membantu, tetapi **belum merupakan solusi permanen** untuk autentikasi Safari.
- Fitur seller versi lama ditampilkan ke semua akun; perbaikan menu di `CoinSellerAccess` meminta role server (owner / seller), fail closed.

## Perbaikan yang dikumpulkan di branch ini (tanpa deploy)
- Manajemen seller di panel: sukses/gagal tampil dekat tombol, cegah submit duplikat, role owner tetap wajib.
- Riwayat dompet: catatan dari server dipisahkan antara **Coin** dan **Diamond**, termasuk hadiah yang diterima.
- Gift: satu transaksi atomik mendebit **Coin pengirim**, mengkredit **Diamond penerima**, serta mencatat transaksi + pesan room. Ketika gift dikirim ke diri sendiri kedua saldo ditulis dengan aman. Transaksi idempotent.
- Persentase Diamond **belum diputuskan**. Backend menolak transaksi gift jika `GIFT_RECEIVER_DIAMOND_PERCENT` belum diset angka 1–100, meskipun sakelar gift ON.
- Tidak mengaktifkan `GIFT_WRITES_ENABLED` dan tidak menyentuh data saldo produksi.

## Yang harus dikonfirmasi Owner
1. Dari gift senilai **1.000.000 Coin**, penerima mendapat **berapa Diamond**? Contoh 600.000 (60%), atau nilai lain.
2. Pastikan Firestore Rules produksi mengizinkan read hanya saldo pengguna sendiri dan **menolak semua penulisan client ke coin, diamond, ekonomiTransactions, coinSellers, giftTransactions**, serta **melarang pesan tipe gift dari client** dan edit `giftTotal`.
3. Tentukan solusi login Safari yang aman dan uji manual dari iPhone serta Android sebelum pembukaan panel luas.

## Tes penerimaan minimal sebelum rilis ke pengguna
| Uji | Harus terjadi |
| --- | --- |
| Akun biasa membuka Profil | Tidak ada menu Coin Seller; API seller send/fund gagal 403 |
| Owner JEP | Tetap OWNER, sekaligus dapat diaktifkan sebagai seller |
| Owner aktifkan ID seller | Satu ID spesifik berubah jadi aktif (bukan semua user) |
| Owner isi stok seller 1 Coin | Stok seller +1; wallet pribadi TIDAK bertambah |
| Seller kirim 1 Coin ke diri sendiri | Stok -1; dompet +1; riwayat masing-masing ada |
| Seller kirim 1 Coin ke pengguna lain | Stok -1; dompet penerima +1 |
| Seller bukan owner mencoba mengisi stok | Gagal 403 |
| Permintaan sama memakai transactionId sama | Tidak menggandakan koin; hasil replay aman |
| Gift gagal (saldo tidak cukup / room kosong) | Tidak ada saldo berubah; tidak ada pesan gift |
| Gift sukses dengan tarif yang diset Owner | Coin pengirim -harga; Diamond penerima +sesuai tarif; room message dan audit dibuat tepat sekali |
| Riwayat Wallet | Coin dan Diamond tampil terpisah; nilai dari server |
| Panel login iPhone | Tidak ada halaman error sessionStorage; akun owner masuk benar |
| Gift dari Android + iPhone | Animasi dan pesan real-time; tidak dobel |

## Satu paket rilis — ketika Railway mengizinkan dan Owner setuju
1. Reviu Firestore Rules **sebelum** membuka gift; uji keamanan server.
2. Gunakan backend dari branch review, sesuaikan konfigurasi Railway repo/branch/startCommand agar tidak menjalankan image/function lama. Pastikan deploy benar-benar aktif dan `GET /api/seller/me` serta `GET /api/wallet/history` tidak lagi 405.
3. Isi `GIFT_RECEIVER_DIAMOND_PERCENT` setelah keputusan Owner. **Biarkan `GIFT_WRITES_ENABLED=false`** sampai tes settlement aman.
4. Satukan perubahan Flutter ke branch APK dan build sekali. Uji pada dua akun / dua ponsel.
5. Setelah lolos semua tes + rules aman, aktifkan gift secara eksplisit dan uji nominal kecil sebelum tersedia untuk semua user.

> Hasil static review tidak sama dengan sukses tes integrasi / produksi. Dilarang menyatakan 'sudah berfungsi' sebelum bukti dari API live, Firestore dan APK.
