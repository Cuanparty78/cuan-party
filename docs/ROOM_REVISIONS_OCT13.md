# Revisi room CUAN PARTY

- Jalur Customer Service membuka dokumen rooms/1001001, room owner yang ditunjukkan user. Room lokal palsu tanpa ID tidak dibuat lagi melalui menu CS. Bila room belum dibuka, tampilkan pesan, bukan room dummy.
- Kursi kosong menampilkan Seat; owner/admin juga melihat Invite user dan Lock seat atau Open seat. Lock disimpan di lockedSeats pada room. Mengambil kursi membaca lock dalam transaksi yang sama dengan penempatan seat.
- Undangan dikirim berdasarkan UID member, berakhir setelah 60 detik, dan perlu persetujuan penerima. Tidak menyalakan mic otomatis. Setelah undangan diterima, transaksi masih memeriksa kursi kosong/tidak terkunci.
- Pengumuman menggunakan lebar penuh dan rata kanan, termasuk teks pendek seperti WELCOME.
- Emoji seat bergerak melalui animasi Flutter dan disiarkan sebagai emoji/emojiUntil pada dokumen seat. Hanya penghuni kursi mengirim emoji dari aplikasi. Reaction hilang setelah 5 detik; preferensi reduced motion dihormati.
- Lima tema: Purple Night, Royal Gold, Ocean Blue, Emerald Palace, Rose Kingdom. Owner menyimpan pilihan themeId pada room; memilih tema menghapus cover foto agar tema terlihat. Semua member menerima perubahan lewat snapshot room.

## Batas yang belum berubah
Kirim gift dan Lucky Bag tetap memakai Functions; belum live karena user menunda Blaze/deploy. Jangan memotong atau menambah saldo lokal untuk menyembunyikan kegagalan server. ZEGO voice tidak bergantung pada deployment gift. Voice live berarti login ZEGO berhasil, bukan bukti audio dua arah sudah diuji.

Untuk uji iPhone gunakan https://cuan-party-voice-test.exactlamp4.chatgpt.site di Safari. Room ID 1001001, App ID 46360202, temporary token untuk user jep_iphone. Tester web hanya bertukar audio dengan APK, tidak menempatkan akun iPhone di seat Firestore. IPA/TestFlight penuh belum disediakan.

## Rules Firebase sebelum pemakaian ramai
Kode UI memeriksa owner/admin, tetapi rules produksi juga harus menegakkannya. Rules produksi tidak tersedia di repository dan tidak diubah pada revisi ini:
- room themeId/lockedSeats: hanya owner/admin yang sesuai kebijakan room; theme whitelist dan index seat valid.
- member seatInvite: hanya owner/admin untuk member room aktif; target hanya boleh menghapus undangannya sendiri. Role tidak boleh diubah oleh user biasa.
- seats: self claim/release hanya untuk uid auth, kapasitas valid, kursi tidak terkunci dan tidak merebut penghuni lain; gunakan getAfter untuk konsistensi membership-seat. Emoji harus milik penghuni seat.
- transaksi coin/receipt gift/Lucky Bag tetap server-only.

Uji dua akun: owner mengunci kursi, user lain tidak bisa duduk; owner membuka kursi; undangan tidak memindahkan user sebelum Terima; dua user memperebutkan kursi hanya satu berhasil; emoji/tema/pengumuman tampil sama di kedua perangkat; setelah turun kursi mic berhenti.
