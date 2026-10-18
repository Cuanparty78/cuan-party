# CUAN PARTY: voice, gift, saldo, Lucky Bag

## Perubahan aplikasi
- Voice tetap menggunakan ZEGO StandardChatroom, menerima stream setiap pembicara secara terpisah. Urutan join Firebase diperbaiki sebelum login voice; status koneksi dan sambungkan ulang ditampilkan. Mic dimatikan jika akun tidak lagi memiliki seat aktif.
- Saldo mengikuti snapshot akun dan economy server, termasuk saat room/halaman dompet terbuka. Pergantian akun membuang langganan akun lama. Economy private menjadi sumber utama, root akun menjadi fallback jika dokumen economy belum ada.
- Gift room diproses oleh sendRoomGift; aplikasi tidak lagi memotong koin atau memberikan diamond lokal. Kebijakan diamond backend yang ada tetap 0. Katalog ditambah dengan Royal Rose 100, Royal Coffee 500, Royal Cake 1k, Royal Heart 5k, Diamond Ring 10k, Golden Dragon 50k, Royal Yacht 100k, Golden Palace 500k, Kingdom Throne 1M. Royal Castle 20k diselaraskan dengan server.
- Lucky Bag menggunakan desain emas/cream/cokelat. Nominal 100k/500k/1M/5M adalah total satu tas, dibagi acak ke 10/20/40/60 akun; countdown 0/1/3/5 menit. Setiap akun hanya dapat klaim sekali. Koin yang belum diklaim tetap di tas sampai kuota habis; tidak ada penghapusan atau refund otomatis pada versi ini.

## Backend dan keamanan sebelum live
User menunda billing Blaze; tidak dilakukan deployment backend atau aktivasi SLOT KINGDOM dalam revisi ini. Gift dan Lucky Bag tidak bisa melakukan transaksi live sebelum Functions tersedia. Jangan mengganti transaksi server dengan penulisan saldo dari aplikasi.

Setelah billing siap, deploy hanya functions:sendRoomGift,functions:createLuckyBag,functions:claimLuckyBag. Periksa rules live terlebih dahulu, karena rules di Firebase production tidak ada di repository. Terapkan pembatasan pada rules utama, bukan hanya menambahkan deny yang bisa dikalahkan allow luas:
- users/{uid}/private/economy: pemilik boleh membaca; perubahan saldo hanya server.
- rooms/{roomId}/luckyBags/{bagId}: member room boleh membaca; hanya server menulis.
- subkoleksi private: tidak boleh dibaca/ditulis klien; berisi urutan hadiah tersembunyi.
- subkoleksi claims: pemilik klaim boleh membaca; hanya server menulis.
- users/{uid}/luckyBagOperations, economyTransactions, giftTransactions: hanya server menulis. Jangan izinkan klien membuat receipt palsu.
- room messages tipe gift dan total gift hanya server yang boleh menulis. Chat biasa tetap mengikuti rules membership yang ada.

## Validasi perangkat
Tes minimal dua Android dengan akun berbeda: satu room yang sama, bergantian duduk/nyalakan mic, kedua arah saling mendengar, beberapa pembicara, speaker mute, turun seat, keluar room, lalu jaringan putus/pulih. Pengujian fisik belum dilakukan oleh workflow build.

ZEGO menyebut runtime default 12 play streams. Untuk room 15/20/30 seat yang semuanya berbicara, minta peningkatan konfigurasi play stream pada ZEGOCLOUD sebelum mengklaim semua seat didukung. https://www.zegocloud.com/docs/faq/max-concurrent-streams
