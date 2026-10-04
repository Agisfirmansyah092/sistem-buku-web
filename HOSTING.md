# Hosting Sistem Buku: GitHub Pages + Supabase

Backend aktif sekarang Supabase. Instruksi PHP/MySQL terdahulu sudah tidak
berlaku untuk aplikasi Flutter ini. Lihat `supabase/README.md` untuk SQL,
konfirmasi email, izin akses, dan pengujian.

## Jalankan lokal

```powershell
Set-Location 'C:\xampp\htdocs\sistem_buku_api\sistem_buku'
flutter pub get
flutter run -d chrome --web-port=5000
```

Apache dan MySQL tidak diperlukan untuk versi Supabase. Internet diperlukan.
Setelah menambahkan dependensi, hentikan proses Flutter lama dan jalankan ulang;
hot reload saja tidak cukup untuk inisialisasi/plugin baru.

## Build untuk GitHub Pages

Repository tujuan: `https://github.com/Agisfirmansyah092/sistem-buku-web`.
Jalankan dari folder proyek:

```powershell
flutter build web --release --base-href=/sistem-buku-web/
New-Item -ItemType File -Force build/web/.nojekyll
```

Untuk repository khusus `USERNAME.github.io`, gunakan `--base-href=/`.
Upload **isi** `build/web` ke repository publik khusus hasil website, lalu pilih
branch/folder tersebut di Settings → Pages. Jangan mengunggah hanya folder `lib`
atau file PHP: Pages memerlukan hasil build HTML/JavaScript/assets.

Alamat yang diharapkan: `https://agisfirmansyah092.github.io/sistem-buku-web/`.
Masukkan alamat itu ke Supabase Authentication → URL Configuration → Site URL.
Publishable key memang publik; izin data ditentukan oleh RLS di Supabase.

Alternatif build sekaligus ZIP:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/build-pages.ps1
```

Jika unggah melalui browser GitHub, ekstrak ZIP di `release` dan unggah seluruh
isinya ke root repository (termasuk folder assets, canvaskit, dan icons).
Jangan mengunggah ZIP sebagai satu file. Setelah commit:
Settings → Pages → Source: Deploy from a branch → Branch: main → /(root) → Save.
Tunggu workflow Pages selesai sebelum membuka alamat website.

## APK Android untuk demo

```powershell
flutter build apk --release
```

Hasil: `build/app/outputs/flutter-apk/app-release.apk`.
APK memakai proyek Supabase yang sama seperti website dan tidak memerlukan
server XAMPP. APK saat ini menggunakan debug signing bawaan untuk demo internal;
siapkan signing key produksi jika akan mendistribusikan lewat Play Store.
APK tidak dapat dipasang pada iPhone; iPhone dapat membuka versi website.

## Status

Build rilis website berhasil dibuat untuk `/sistem-buku-web/`. Seluruh 13 tes
lulus dan analisis Dart bersih. Paket unggahan ada di `release/sistem-buku-web.zip`;
checkout hasil build ada di `release/pages-repository` (commit lokal sudah siap).
Publikasi menunggu autentikasi GitHub dan pengaktifan Pages. APK belum dibangun.
