CREATE DATABASE IF NOT EXISTS `koperasi` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE koperasi;

CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  phone VARCHAR(30),
  role ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER',
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS categories (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE,
  description TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  category_id INT UNSIGNED NOT NULL,
  name VARCHAR(180) NOT NULL,
  description TEXT NOT NULL,
  image TEXT NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  unit VARCHAR(50) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_products_category (category_id), INDEX idx_products_name (name)
) ENGINE=InnoDB;

-- Data contoh kopsis. Tidak menghapus atau mengubah produk milik pengelola.
INSERT IGNORE INTO categories (name,description) VALUES
('Alat Tulis','Pulpen, pensil, dan perlengkapan untuk mencatat serta mengerjakan tugas'),
('Buku & Kertas','Buku catatan dan kertas untuk kebutuhan belajar'),
('Perlengkapan Sekolah','Perlengkapan pendukung kegiatan siswa di sekolah'),
('Makanan Ringan','Camilan kemasan untuk menemani waktu istirahat'),
('Minuman','Minuman kemasan untuk kebutuhan di sekolah');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Pulpen Gel Hitam','Pulpen tinta hitam untuk mencatat materi dan mengerjakan tugas. Periksa kenyamanan ujung pena sebelum membeli.','/products/pen.svg',3500,'pcs',60,1 FROM categories c WHERE c.name='Alat Tulis' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Pulpen Gel Hitam');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Pensil 2B','Pensil 2B untuk menulis dan menggambar. Cocok untuk melengkapi tempat pensil siswa.','/products/pencil.svg',2500,'pcs',45,1 FROM categories c WHERE c.name='Alat Tulis' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Pensil 2B');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Penghapus Putih','Penghapus pensil untuk merapikan catatan dan sketsa di kertas.','/products/eraser.svg',2000,'pcs',8,1 FROM categories c WHERE c.name='Alat Tulis' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Penghapus Putih');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Buku Tulis 38 Lembar','Buku bergaris isi 38 lembar untuk catatan pelajaran. Pilihan sampul mengikuti ketersediaan di koperasi.','/products/notebook.svg',5000,'buku',80,1 FROM categories c WHERE c.name='Buku & Kertas' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Buku Tulis 38 Lembar');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Kertas Folio Bergaris','Kertas folio bergaris untuk tugas tertulis. Harga contoh dihitung per lembar.','/products/paper.svg',500,'lembar',100,1 FROM categories c WHERE c.name='Buku & Kertas' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Kertas Folio Bergaris');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Map Kancing A4','Map ukuran A4 untuk menyimpan lembar tugas dan dokumen sekolah agar lebih rapi.','/products/folder.svg',6000,'pcs',20,1 FROM categories c WHERE c.name='Perlengkapan Sekolah' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Map Kancing A4');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Tali ID Card Merah','Tali kartu identitas warna merah untuk kegiatan sekolah. Jenis kait diperiksa langsung di koperasi.','/products/lanyard.svg',10000,'pcs',0,1 FROM categories c WHERE c.name='Perlengkapan Sekolah' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Tali ID Card Merah');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Biskuit Cokelat','Biskuit kemasan untuk camilan saat istirahat. Periksa komposisi, informasi alergen, dan tanggal kedaluwarsa pada kemasan.','/products/snack.svg',3000,'bungkus',35,1 FROM categories c WHERE c.name='Makanan Ringan' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Biskuit Cokelat');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Air Mineral 600 ml','Air mineral dalam botol 600 ml. Pastikan segel kemasan utuh sebelum dikonsumsi.','/products/water.svg',3500,'botol',48,1 FROM categories c WHERE c.name='Minuman' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Air Mineral 600 ml');
INSERT INTO products (category_id,name,description,image,price,unit,stock,active)
SELECT c.id,'Susu UHT Cokelat 200 ml','Susu UHT rasa cokelat kemasan 200 ml. Mengandung susu; baca informasi komposisi dan kedaluwarsa pada kemasan.','/products/milk.svg',5500,'kotak',24,1 FROM categories c WHERE c.name='Minuman' AND NOT EXISTS (SELECT 1 FROM products WHERE name='Susu UHT Cokelat 200 ml');
