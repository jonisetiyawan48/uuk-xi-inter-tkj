# Kopsis Moklet Malang — Koperasi Siswa

Situs katalog kebutuhan sekolah dengan Next.js App Router dan MariaDB. Halaman meliputi beranda, katalog dengan pencarian/filter/sortir, detail produk, tentang kopsis, layanan, panduan keanggotaan, informasi/FAQ, serta pengelolaan produk dan kategori.

## Data dan batas fitur

- Seed menyediakan 10 contoh produk sekolah dengan ilustrasi SVG lokal. Harga dan stok adalah contoh, bukan informasi resmi sekolah.
- Seed tidak menghapus data lama. Instalasi yang sudah berisi produk koperasi desa dapat menonaktifkan produk lama dan menghapus kategori kosong melalui panel pengelola setelah pemeriksaan data.
- Jam layanan, alamat ruang, kontak, pengurus, dan aturan keanggotaan menunggu konfirmasi sekolah. Situs tidak mengklaimnya sebagai informasi resmi.
- Pembelian dilakukan langsung. Belum ada checkout, pembayaran, pencatatan penjualan, atau simpanan anggota.
- Panel pengelola yang diwarisi proyek belum memiliki autentikasi. Batasi akses ke lingkungan lokal/LAN sebelum menambahkan autentikasi untuk penggunaan publik.
- Mode normal menggunakan pencarian berparameter dan menampilkan deskripsi sebagai teks. Mode praktikum backend hanya aktif jika `LAB_MODE=true` secara eksplisit.

## Identitas visual

Warna merah `#c81e25`, latar putih/abu netral, dan Plus Jakarta Sans mengikuti referensi [situs SMK Telkom Malang](https://smktelkom-mlg.sch.id/). Logo berasal dari aset sekolah di `/images/logo/logo_hitam.png`. Font disajikan lokal dengan lisensi SIL OFL di `public/fonts/OFL.txt`.

## Praktikum pemindaian dependensi

Dependensi latihan dikunci pada `lodash@4.17.20` dan `axios@0.21.1`. Panduan npm audit, Snyk, snapshot temuan, batas keterjangkauan kode, dan latihan perbaikan ada di [docs/PRAKTIKUM-DEPENDENSI.md](docs/PRAKTIKUM-DEPENDENSI.md). Informasi ini hanya ada pada repository, tidak pada halaman situs.

Jalankan dari root proyek:

```bash
npm ci --ignore-scripts
npm run audit:lab
npm run audit:lab:json > audit-result.json
npm audit --omit=dev
```

Untuk Snyk, sediakan CLI di PATH dan autentikasi terlebih dahulu:

```bash
snyk auth
npm run snyk:lab
snyk test --file=package.json --package-manager=npm --json > snyk-result.json
```

Temuan membuat scanner mengembalikan exit code bukan nol; ini hasil yang diharapkan dalam praktikum. Jangan jalankan `npm audit fix` sebelum merekam baseline. Kedua paket latihan tidak dipanggil oleh kode katalog; keberadaan versi rentan dalam dependency tree berbeda dengan bukti jalur eksploitasi aplikasi.

Snapshot npm audit saat implementasi: **4 paket rentan (3 high, 1 moderate)**. Jumlah bisa berubah mengikuti advisory scanner. Snyk belum dijalankan karena CLI dan autentikasi tidak tersedia. Simpan token hanya di lingkungan lokal, bukan di Git.


## Persyaratan

- CentOS/RHEL-compatible Linux.
- Node.js LTS, disarankan Node.js 20 atau 22.
- npm.
- MariaDB Server.
- PM2.

## 1. Instalasi Node.js

Gunakan Node.js LTS yang sesuai dengan kebijakan server. Pastikan:

```bash
# 1. Download & jalankan setup script NodeSource untuk Node 22
curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -

# 2. Install Node.js
sudo dnf install -y nodejs

# 3. Verifikasi versi
node -v
npm -v

```

Jika server belum memiliki Node.js, instal Node.js LTS terlebih dahulu.

## 2. Instalasi dan menjalankan MariaDB

Pastikan MariaDB aktif:

```bash
sudo dnf install mariadb-server mariadb-client
sudo systemctl enable --now mariadb
sudo systemctl status mariadb
```

## 3. Menyiapkan source aplikasi

Contoh lokasi aplikasi:

```bash
sudo mkdir -p /var/www
cd /var/www
```

Clone repository proyek ke folder `uuk-xi-inter-tkj`:

```bash
git clone https://github.com/jonisetiyawan48/uuk-xi-inter-tkj.git
```

Kemudian:

```bash
cd /var/www/uuk-xi-inter-tkj
npm ci
```

## 4. Konfigurasi database

Salin konfigurasi:

```bash
cp env.example .env
nano .env
```

Contoh:

```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=koperasi
DB_PASSWORD=password_database
DB_NAME=koperasi

LAB_MODE=false
```

### Membuat user MariaDB

Masuk ke MariaDB sebagai root:

```bash
sudo mariadb
```

Kemudian:

```sql

CREATE DATABASE IF NOT EXISTS koperasi;
CREATE USER IF NOT EXISTS 'koperasi'@'localhost' IDENTIFIED BY 'password_database';
GRANT ALL PRIVILEGES ON koperasi.* TO 'koperasi'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

> Buat database dan user terlebih dahulu dengan SQL di atas. Script seed memilih database melalui `DB_NAME` di `.env`; tidak membuat database sendiri. Jika menggunakan nama lain, sesuaikan SQL pembuatan database, hak akses user, dan `DB_NAME`. Tidak perlu mengubah file seed.

## 5. Seed database otomatis saat build

`npm run build` otomatis menjalankan script `prebuild`, yaitu `npm run db:seed`, sebelum kompilasi Next.js. Script `scripts/seed.mjs` membaca `.env` lalu mengeksekusi `db/seed.sql` melalui mysql2. Tidak perlu menjalankan import SQL manual.

`db/seed.sql` dibuat idempotent untuk struktur dan data contoh sehingga dapat dijalankan kembali tanpa sengaja membuat data contoh berulang.

Isi seed kopsis pada database baru:

| Kategori | Produk contoh |
| --- | --- |
| Alat Tulis | Pulpen Gel Hitam, Pensil 2B, Penghapus Putih |
| Buku & Kertas | Buku Tulis 38 Lembar, Kertas Folio Bergaris |
| Perlengkapan Sekolah | Map Kancing A4, Tali ID Card Merah |
| Makanan Ringan | Biskuit Cokelat |
| Minuman | Air Mineral 600 ml, Susu UHT Cokelat 200 ml |

Total **5 kategori dan 10 produk** dengan gambar dari `public/products/`. Harga dan stok merupakan contoh. Penghapus disiapkan dengan stok terbatas dan tali ID card dengan stok habis untuk melihat variasi tampilan persediaan.

Seed membuat tabel `users`, `categories`, dan `products`. Tabel `users` disediakan untuk kompatibilitas proyek, tanpa membuat akun login atau data pribadi siswa. Panel pengelola saat ini belum menggunakan autentikasi.

Jalankan seed secara manual:

```bash
npm run db:seed
```

Seed melewati kategori dengan nama yang sudah ada dan produk dengan nama yang sama. Menjalankannya berulang secara berurutan tidak menggandakan data contoh atau menimpa perubahan harga, stok, deskripsi, maupun status aktif milik pengelola. Produk contoh yang dihapus atau diganti namanya dapat dibuat lagi saat seed berikutnya. Hindari menjalankan dua proses seed bersamaan.

Data contoh dimasukkan dalam transaksi; jika insert gagal, perubahan data pada transaksi dibatalkan. Pembuatan struktur tabel tidak ikut dibatalkan karena perilaku DDL MariaDB. Seed tidak menghapus produk atau kategori lama dan bukan pengganti migrasi struktur database.

Untuk import SQL langsung, pilih database secara eksplisit (perintah ini tidak membaca `.env`):

```bash
mariadb -h 127.0.0.1 -P 3306 -u koperasi -p koperasi < db/seed.sql
```

Ganti nama database terakhir, host, port, dan user sesuai konfigurasi. Tidak ada payload eksploitasi yang dimasukkan ke produk; dependensi rentan praktikum berasal dari `package.json`/lockfile, terpisah dari seed.


### Catatan penting tentang seed saat build

Karena seed dijalankan pada `prebuild`, **MariaDB harus sudah aktif dan `.env` harus benar sebelum `npm run build`**.

Ini sengaja dipilih untuk server lab supaya instalasi lebih sederhana: setelah konfigurasi `.env`, administrator cukup menjalankan build dan database contoh langsung disiapkan.

Jika suatu saat tidak ingin seed otomatis saat build, hapus script `prebuild` dari `package.json` dan gunakan `npm run db:seed` secara manual.

## 6. Build aplikasi

Setelah MariaDB dan `.env` siap:

```bash
cd /var/www/uuk-xi-inter-tkj
npm run build
```

Jika berhasil, aplikasi siap dijalankan dalam mode production.

### Menjalankan pada komputer pengembangan

Setelah `.env` dan MariaDB siap:

```bash
npm run db:seed
npm run dev
```

Buka `http://localhost:3000`. Untuk menjalankan hasil build tanpa PM2, gunakan `npm start`.

### Pemeriksaan kode tanpa mengubah database

```bash
npm run typecheck
npx next build
```

`npx next build` melewati hook `prebuild` npm, sehingga tidak menjalankan seed. Build ini memeriksa kompilasi aplikasi; tidak membuktikan koneksi database atau keberhasilan CRUD. Untuk instalasi lengkap, tetap gunakan `npm run build` setelah MariaDB siap.

## 7. Instal PM2

Install PM2 secara global:

```bash
sudo npm install -g pm2
```

Cek:

```bash
pm2 -v
```

## 8. Menjalankan Next.js menggunakan PM2

Nama proses PM2 adalah `kopsis-moklet-malang`, sedangkan nama folder proyek adalah `uuk-xi-inter-tkj`. Konfigurasi menggunakan `cwd: __dirname`, sehingga mengikuti lokasi folder `ecosystem.config.cjs`.

Project sudah menyediakan:

```text
ecosystem.config.cjs
```

Jalankan:

```bash
cd /var/www/uuk-xi-inter-tkj
pm2 start ecosystem.config.cjs
```

Cek proses:

```bash
pm2 status
```

Lihat log:

```bash
pm2 logs kopsis-moklet-malang
```

Restart:

```bash
pm2 restart kopsis-moklet-malang
```

Stop:

```bash
pm2 stop kopsis-moklet-malang
```

## 9. Agar PM2 otomatis hidup setelah server reboot

Jalankan sebagai user yang digunakan untuk menjalankan aplikasi:

```bash
pm2 startup
```

Ikuti command `sudo ...` yang diberikan PM2, lalu simpan process list:

```bash
pm2 save
```

Setelah reboot, cek:

```bash
pm2 status
```

## 10. Akses dari komputer siswa

PM2 menjalankan Next.js pada:

```text
0.0.0.0:3000
```

Cari IP server CentOS:

```bash
ip a
```

Misalnya IP server:

```text
192.168.1.10
```

Maka komputer siswa mengakses:

```text
http://192.168.1.10:3000
```

Tidak diperlukan Nginx, domain, HTTPS, maupun Certbot.

## 11. Firewall CentOS

Jika `firewalld` aktif, buka port 3000:

```bash
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --reload
```

Cek:

```bash
sudo firewall-cmd --list-ports
```

## 12. Mode praktikum keamanan

Gunakan `LAB_MODE=false` untuk katalog kopsis. Deskripsi produk dan kata kunci pencarian ditampilkan sebagai teks biasa. Backend tetap menyimpan mode latihan SQL Injection lama, yang hanya aktif saat `LAB_MODE=true`; gunakan hanya pada lingkungan praktikum terisolasi. Demonstrasi XSS pada halaman publik lama telah diganti dengan tampilan informasi kopsis.

## 13. Update source code aplikasi

Setelah source diperbarui:

```bash
cd /var/www/uuk-xi-inter-tkj
npm ci
npm run build
pm2 restart kopsis-moklet-malang
```

Perhatikan bahwa `npm run build` akan menjalankan seed terlebih dahulu.

## 14. Backup database

Backup:

```bash
mysqldump -u koperasi -p koperasi > backup-koperasi.sql
```

Restore:

```bash
mysql -u koperasi -p koperasi < backup-koperasi.sql
```

## 15. Troubleshooting

### Next.js tidak dapat terhubung ke MariaDB

Periksa:

```bash
sudo systemctl status mariadb
```

Kemudian periksa `.env`:

```text
DB_HOST
DB_PORT
DB_USER
DB_PASSWORD
DB_NAME
```

Tes login:

```bash
mariadb -u koperasi -p -h 127.0.0.1
```

### Build gagal pada tahap db:seed

Jalankan manual:

```bash
npm run db:seed
```

Lihat pesan error MariaDB. Biasanya penyebabnya adalah user database tidak memiliki privilege yang diperlukan atau konfigurasi `.env` salah.

### Dari PC siswa tidak bisa membuka website

Di server:

```bash
pm2 status
sudo ss -lntp | grep 3000
sudo firewall-cmd --list-ports
```

Pastikan Next.js listen pada `0.0.0.0:3000`, bukan hanya `127.0.0.1:3000`.

### Melihat log aplikasi

```bash
pm2 logs kopsis-moklet-malang
```

## 16. Urutan instalasi singkat

Jika server sudah memiliki Node.js, npm, MariaDB, dan PM2, urutan paling singkat:

```bash
cd /var/www/uuk-xi-inter-tkj
npm ci
cp env.example .env
nano .env
npm run build
pm2 start ecosystem.config.cjs
pm2 save
```

Kemudian buka dari komputer siswa:

```text
http://IP_SERVER:3000
```

## Status verifikasi dan struktur proyek

- TypeScript dan kompilasi produksi berhasil saat implementasi.
- Halaman informasi dan aset logo/font telah diperiksa melalui HTTP; endpoint `/api/lab/info` mengembalikan 404.
- Koneksi MariaDB, seed, serta CRUD belum diuji di lingkungan implementasi karena `.env` database belum tersedia.
- `app/`: halaman dan API; `components/`: komponen tampilan/form; `lib/`: akses data; `db/seed.sql`: struktur dan data contoh; `public/`: logo, font, ilustrasi; `docs/`: panduan praktikum dan snapshot audit.
- Jalankan semua perintah dari root repository `uuk-xi-inter-tkj`. Pada contoh server, lokasinya adalah `/var/www/uuk-xi-inter-tkj`.
- `.env`, `node_modules/`, dan `.next/` tidak diunggah ke Git. Sertakan `package-lock.json` agar versi latihan tetap konsisten.
