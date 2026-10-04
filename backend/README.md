# Login dan registrasi

> Arsip backend PHP lama. Flutter sekarang menggunakan Supabase dan tidak
> memanggil endpoint di folder ini. Panduan aktif ada di `../supabase/README.md`.

ID login adalah username yang dipilih saat mendaftar, bukan ID angka database.
Password minimal 8 karakter dan maksimal 72 byte.

File `auth_common.php`, `login.php`, dan `register.php` sudah disalin ke
`C:/xampp/htdocs/sistem_buku_api/`, di samping `db.php`.
Salinan API sebelumnya tersimpan sebagai `login.previous.php` dan
`register.previous.php` di folder ini.

1. Aktifkan Apache dan MySQL di XAMPP.
2. Pastikan database `db_sistem_buku` memiliki tabel `users` dengan kolom
   `id`, `nama`, `username`, `email`, dan `password`. Kolom password perlu
   menampung hash (VARCHAR(255)); username dan email sebaiknya memiliki indeks UNIQUE.
   Jika tabel belum ada, pilih database tersebut di phpMyAdmin dan impor `users.sql`.
   SQL ini tidak memperbarui struktur tabel yang sudah ada.
3. Buka aplikasi, pilih Daftar, isi semua data, lalu login menggunakan
   username dan password yang baru didaftarkan.
4. Coba password salah, akun tidak terdaftar, form kosong, dan pendaftaran
   dengan username/email yang sudah digunakan: semuanya harus ditolak.

Alamat autentikasi default adalah `http://localhost/sistem_buku_api`.
Untuk perangkat lain, alamat dapat diatur dengan
`--dart-define=API_BASE_URL=http://ALAMAT_SERVER/sistem_buku_api`.
Pengaturan ini digunakan bersama oleh autentikasi, dashboard, API buku, dan cover.
Lihat `../HOSTING.md` untuk persiapan website dan APK dengan server HTTPS.

Perubahan ini memvalidasi kredensial sebelum membuka dashboard. Belum ada
token/sesi persisten atau pemeriksaan otorisasi pada endpoint CRUD buku.

Validasi pengembangan: analisis Dart dan lint PHP lolos. Tes Flutter disediakan,
tetapi belum dapat dijalankan karena Git tidak ditemukan di PATH. Pengujian
database belum dilakukan karena MySQL menolak koneksi saat pemeriksaan.
