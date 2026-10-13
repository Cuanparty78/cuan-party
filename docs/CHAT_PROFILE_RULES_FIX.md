# Chat, profil, dan scroll rules

## Perubahan
- WebView menerima gesture sebelum modal sheet; drag sheet dimatikan supaya scroll tabel hadiah tidak tertangkap panel Flutter. Dialog memiliki tinggi eksplisit, area isi flex-scroll dan tombol kembali tetap di bawah.
- Pengumuman kini rata kiri dalam kotak lebar penuh, menggantikan permintaan rata kanan sebelumnya setelah feedback user.
- Owner/admin bisa membuka/menutup chat. Semua member boleh mengirim ketika terbuka; hanya owner/admin ketika ditutup. UI dan transaksi membaca policy yang sama. Pesan tidak dibuang dari composer jika pengiriman gagal.
- Tekan lama komentar, konfirmasi Hapus. Owner/admin dapat menghapus komentar room; member dapat menghapus komentarnya sendiri. Dokumen chat dihapus untuk seluruh viewer, tidak bisa dipulihkan oleh aplikasi. Gift dan receipt finansial tidak ikut dihapus.
- Edit Profil menampilkan foto aktual, tombol galeri, link HTTPS, foto Google dan preview. Foto galeri diresize 512px, maksimal 2 MB, format JPEG/PNG/WEBP, disimpan ke profiles/{uid}/avatar_<timestamp>.<type> setelah Simpan. Tidak ada pengunggahan otomatis saat memilih foto.
- Profil tetap tersimpan jika mirror nama/foto Firebase Auth gagal sesudah Firestore sukses; gender kosong/legacy tidak lagi membuat dropdown crash. Tombol Simpan dan input dinonaktifkan selama proses simpan.
- Snapshot profil memperbarui nama/foto di state; heartbeat member mempublikasikan foto/nama terbaru dan tidak menghidupkan kembali member yang sudah di-kick. Foto kursi mengikuti data member.

## Prasyarat yang belum aktif
Upload galeri Firebase Storage memerlukan bucket aktif dan rules yang benar, serta Blaze sesuai kebijakan Firebase. Tidak dilakukan upgrade billing, deployment Functions, atau overwrite rules produksi dalam revisi ini. Link foto HTTPS/foto Google hanya membutuhkan penyimpanan URL pada profil. Pembayaran/game/gift masih mengikuti status backend sebelumnya.

Rules produksi tidak tersedia dalam repository. Sebelum penggunaan umum, tegakkan:
- profile write: akun sendiri, hanya field profil yang diizinkan; jangan mengizinkan perubahan coin/diamond/role melalui update profil.
- Storage: hanya auth.uid yang sama dengan path profiles/{uid}; ukuran maksimal 2 MB, contentType image/jpeg|png|webp. Sesuaikan read policy avatar dengan visibility profil aplikasi.
- room message create: member room aktif, fromId == auth.uid, type chat, text nonempty <=1000; room.chatEnabled true atau auth UID owner / member role admin. Tipe gift hanya server.
- room chatEnabled update: owner/admin, tidak boleh mengubah field owner/saldo melalui request ini.
- chat delete: member author sendiri atau owner/admin; type chat saja. Jangan mengizinkan delete gift, economyTransactions, atau receipt Lucky Bag.
- heartbeat member/seat: update identitas milik auth.uid saja; seat.uid tidak boleh direbut lewat heartbeat.

Periksa scroll di Android fisik, galeri, foto setelah relogin, dua akun untuk chat terbuka/tertutup, admin tetap bisa bicara saat ditutup, dan deletion hilang pada kedua perangkat. CI memverifikasi build, policy matrix dan preview foto; bukan bukti rules live sudah diaudit.

Voice iPhone: https://cuan-party-voice-test.exactlamp4.chatgpt.site di Safari, Room ID 1001001, App ID 46360202, temporary token untuk jep_iphone. Ini tester suara, bukan aplikasi iOS penuh.
