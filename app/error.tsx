'use client';
import Link from 'next/link';
export default function ErrorPage({reset}:{reset:()=>void}){return <main className="container section"><div className="eyebrow">Kopsis Moklet</div><h1 className="page-title">Data belum bisa ditampilkan.</h1><p className="lead">Layanan sedang tidak dapat memuat data. Coba kembali beberapa saat lagi atau tanyakan ketersediaan produk langsung kepada petugas koperasi.</p><div className="actions"><button className="btn btn-primary" onClick={reset}>Coba lagi</button><Link className="btn btn-ghost" href="/layanan">Informasi layanan</Link></div></main>}
