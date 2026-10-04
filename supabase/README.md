# Supabase untuk Sistem Buku

Aplikasi sekarang menggunakan Supabase Auth, Postgres (`books`), dan Storage
(`book-covers`). API PHP dan MySQL lokal tidak dipanggil lagi.

## Konfigurasi proyek

URL dan publishable key tersedia di `lib/services/supabase_config.dart`.
Keduanya boleh berada di aplikasi klien. Jangan menggantinya dengan secret key
atau service_role. Jika ingin mengganti proyek saat build, gunakan
`--dart-define=SUPABASE_URL=...` dan `--dart-define=SUPABASE_PUBLISHABLE_KEY=...`.

`setup.sql` membuat tabel, bucket, serta kebijakan akses. Pengguna telah
mengonfirmasi SQL berhasil dijalankan pada proyek ini.

- Pengguna tanpa login tidak dapat membaca/mengubah tabel buku.
- Pengguna yang login dapat membaca katalog bersama.
- Hanya pembuat buku yang dapat memperbarui/menghapus buku tersebut.
- Cover disimpan di folder UUID pengguna. Unggahan/penghapusan dibatasi ke
  folder sendiri. URL cover bersifat publik agar bisa ditampilkan sebagai gambar.
- Bucket menerima JPEG, PNG, WebP, maksimal 5 MB per file.
- Nama dan username disimpan sebagai metadata akun. Username adalah nama profil,
  bukan ID login unik; login memakai email dan password.

## Konfirmasi email

Saat pemeriksaan, Email provider aktif dan Confirm email aktif.
Gunakan alamat email yang dapat diakses ketika mendaftar.
Setelah mendaftar, klik tautan konfirmasi dari email (cek folder spam), lalu login.
Supabase dapat menyamarkan hasil pendaftaran email yang sudah ada; pesan aplikasi
tidak menyatakan email baru pasti telah dibuat ketika belum ada sesi.

Di Authentication → URL Configuration, isi Site URL dengan URL website yang
benar. Saat pengembangan, gunakan misalnya `http://localhost:5000/`, lalu jalankan:

```powershell
flutter run -d chrome --web-port=5000
```

Saat website GitHub Pages tersedia, ganti Site URL dengan URL Pages lengkap,
termasuk subfolder repository dan garis miring terakhir. Tambahkan URL lokal
ke Redirect URLs hanya bila diperlukan untuk pengembangan.
APK menggunakan email/password, sehingga konfirmasi dapat diselesaikan di
browser dan kemudian pengguna kembali ke APK untuk login.

## Pengujian manual

1. Daftar akun baru, konfirmasi email, lalu login menggunakan email/password.
2. Coba password salah: dashboard tidak boleh terbuka.
3. Tambah buku dengan cover JPG/PNG/WebP. Pastikan muncul di dashboard dan daftar.
4. Edit dan hapus buku sendiri. Coba stok negatif/nonangka: harus ditolak.
5. Reload browser: sesi tetap tersimpan. Logout: kembali ke login.
6. Login sebagai akun kedua: katalog terbaca, edit/hapus buku akun pertama
   dinonaktifkan. Aturan yang sama juga diterapkan server lewat RLS.

Data buku, cover, dan akun XAMPP tidak dimigrasikan otomatis. Akun Supabase
perlu didaftarkan ulang. Untuk demo, tambahkan buku melalui aplikasi; migrasi
data lama memerlukan pemetaan pemilik buku dan unggahan cover ke Storage.

Jika jaringan putus tepat setelah penyimpanan, cek daftar sebelum mengulangi
penyimpanan agar tidak membuat duplikat. Cover yang gagal dibersihkan dapat
ditinjau di dashboard Storage; tidak ada penghapusan otomatis yang berisiko
menghapus file dari transaksi dengan hasil belum pasti.

## Hasil pemeriksaan

- URL/key dan pengaturan Auth berhasil diperiksa lewat request read-only.
- Akses tabel books tanpa login ditolak dengan permission denied (HTTP 401).
  Ini hasil yang diharapkan; jangan mengikuti hint untuk memberi SELECT ke anon.
- Analisis Dart dijalankan pada lib dan test.
- Seluruh 13 tes autentikasi, validasi buku, dan form lulus setelah Git portable
  tersedia. Analisis Dart juga bersih. Login/CRUD dengan akun nyata belum diuji
  dari lingkungan agen; pengguna melaporkan login berhasil.

Referensi: https://supabase.com/docs/guides/getting-started/quickstarts/flutter
dan https://supabase.com/docs/guides/storage/security/access-control
