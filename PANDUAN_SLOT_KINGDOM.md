# Paket integrasi SLOT KINGDOM

Paket ini berisi source CUAN PARTY dari commit d84d468aa29182b7ca254cd8355f2a26336668ac ditambah integrasi SLOT KINGDOM. Ini source untuk dibangun; belum APK yang sudah dirilis atau backend yang sudah dideploy.

Yang ditambahkan:
- Menu SLOT KINGDOM di pusat Game dan menu room, dengan game dalam panel room.
- Nomor spin dan riwayat tersimpan per akun di Firebase, berlanjut setelah tutup/login kembali.
- Hasil spin, saldo, free spin dan Gold Bank diproses server; retry tidak memotong saldo dua kali.
- Tombol + koin membuka halaman Dompet yang sudah ada, tanpa memberi koin gratis.

Cara memasang:
1. Buat branch baru dari commit dasar tersebut. Kalau main sudah berubah, gabungkan perubahan dengan review, jangan menimpa seluruh repo.
2. Salin file yang tercantum di docs/SLOT_KINGDOM_CHANGED_FILES.txt. Jalankan `node --test functions/test/*.test.js`.
3. Jalankan `flutter pub get`, lalu build APK memakai workflow Build APK yang sudah ada. Uji di Android; build Flutter belum dijalankan di lingkungan penyuntingan ini.
4. Deploy Functions melalui workflow Deploy Firebase Functions.
5. Periksa rules Firebase terlebih dahulu: data saldo/game/config hanya boleh diubah server. Panduan lengkap ada di docs/SLOT_KINGDOM_INTEGRATION.md.
6. Setelah lulus pemeriksaan, admin dapat mengaktifkan dokumen `gameConfig/slotKingdom` dengan `enabled: true`. Sebelum itu, server menolak spin tanpa memotong koin.

Jangan menghapus data slotKingdom saat update APK. Nomor spin tidak perlu direset.

Belum termasuk: payment gateway/recharge yang sudah diverifikasi, sistem sewa per tenant, audit matematika/RTP, deployment live, dan pengujian perangkat Android. Tidak ada jaminan operator selalu untung.

Akses GitHub telah diperbaiki. Integrasi disiapkan pada branch Slot-kingdom untuk review dan build; main tidak diubah otomatis. Jangan aktifkan penggunaan koin sebelum pemeriksaan keamanan Firebase dan pengujian Android selesai.

Validasi lokal: 11 tes Node untuk backend dan sambungan UI lolos. Sintaks seluruh JavaScript lolos. Build Flutter, Firebase live, dan perangkat Android belum diuji.
