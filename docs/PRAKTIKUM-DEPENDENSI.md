# Praktikum npm audit dan Snyk

Dokumen pengajar di repository, tidak disajikan sebagai halaman website. Gunakan salinan lokal/LAN untuk latihan dan data fiktif.

## Target pembelajaran

Membandingkan temuan Software Composition Analysis (SCA), membaca advisory, membedakan keparahan dengan keterjangkauan kode, lalu memeriksa perbaikan di salinan atau branch latihan.

Dua dependensi langsung dikunci tanpa `^` atau `~`:

| Paket | Versi latihan | Contoh materi |
| --- | --- | --- |
| lodash | 4.17.20 | Command Injection pada template dan ReDoS |
| axios | 0.21.1 | ReDoS dan advisory terkait HTTP client |

Keduanya sengaja masuk `dependencies` agar pemindaian produksi juga melihatnya. Katalog tidak mengimpor atau menjalankan keduanya; temuan SCA menunjukkan keberadaan versi rentan, bukan bukti eksploitasi jalur website. Lockfile disertakan untuk menjaga versi instalasi.

Referensi advisory:

- https://github.com/advisories/GHSA-35jh-r3h4-6jhm
- https://github.com/advisories/GHSA-29mw-wpgm-hmr9
- https://github.com/advisories/GHSA-cph5-m8f7-6c5x

## npm audit

Jalankan di root repository yang berisi lockfile ini:

```bash
npm ci --ignore-scripts
npm run audit:lab
npm run audit:lab:json > audit-result.json
npm audit --omit=dev
```

Exit code bukan nol ketika ditemukan kerentanan merupakan hasil yang diharapkan. Jangan menjalankan `npm audit fix` pada baseline sebelum mencatat hasil: perintah itu dapat mengubah versi target pembelajaran.

Pada pemeriksaan saat implementasi, npm audit melaporkan 4 paket rentan (3 high, 1 moderate), termasuk `axios` dan `lodash`. Lihat [snapshot ringkas](audit-baseline.json). Jumlah dan advisory dapat berubah mengikuti basis data scanner; snapshot bukan batas jumlah temuan.

## Snyk

Sediakan Snyk CLI di komputer praktikum, lalu autentikasi akun pengajar/siswa melalui alur resmi Snyk. Token tidak disimpan dalam repository.

```bash
snyk auth
npm run snyk:lab
snyk test --file=package.json --package-manager=npm --json > snyk-result.json
```

Skrip `snyk:lab` mengharuskan CLI sudah terpasang di PATH. Jangan menambahkan `.snyk` ignore untuk menyembunyikan temuan latihan. Snyk belum dijalankan saat implementasi karena CLI dan autentikasi akun tidak tersedia.

## Latihan perbaikan

1. Catat nama paket, dependency path, advisory, severity, versi terpengaruh, dan rekomendasi scanner.
2. Tentukan apakah fungsi terpengaruh digunakan aplikasi atau hanya tercatat sebagai dependensi.
3. Buat branch latihan, lalu hapus dependensi yang tidak digunakan atau perbarui berdasarkan advisory terkini.
4. Perbarui lockfile, jalankan build dan scanner lagi, lalu bandingkan hasil.

## Praktikum kode aplikasi yang diwarisi

Jalur SQL Injection pencarian lama tetap tersedia jika `LAB_MODE=true` disetel di `.env` lokal. Mode ini terpisah dari SCA: npm audit dan `snyk test` tidak membuktikan ada/tidaknya SQL Injection. Pengaturan contoh tetap `LAB_MODE=false`. Tidak ada banner, tautan praktikum, atau daftar kerentanan dalam halaman website; endpoint `/api/lab/info` mengembalikan 404.
