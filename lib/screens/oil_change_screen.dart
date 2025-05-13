import 'package:flutter/material.dart';
import 'maintenance_guide_screen.dart';

class OilChangeScreen extends StatelessWidget {
  const OilChangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaintenanceGuideScreen(
      title: 'Ganti Oli',
      subtitle:
          'Panduan lengkap penggantian oli mesin untuk performa optimal dan umur mesin yang panjang',
      icon: Icons.oil_barrel,
      color: Colors.orange,
      sections: [
        GuideSection(
          title: 'Memilih Jenis Oli Yang Tepat',
          content:
              'Memilih oli yang tepat sangat penting untuk kesehatan mesin. Oli harus sesuai dengan spesifikasi yang direkomendasikan oleh pabrikan mobil.',
          image: 'assets/images/oil_types.jpg',
          steps: [
            'Periksa buku manual kendaraan untuk spesifikasi oli yang direkomendasikan',
            'Perhatikan grade viskositas (mis. 5W-30, 10W-40) sesuai iklim',
            'Pilih oli yang memenuhi standar API atau ACEA yang direkomendasikan',
            'Pertimbangkan jenis oli: mineral, semi-sintetis, atau full sintetis'
          ],
        ),
        GuideSection(
          title: 'Persiapan Ganti Oli',
          content:
              'Persiapan yang baik akan membuat proses penggantian oli lebih mudah dan bersih. Pastikan semua alat dan bahan tersedia sebelum memulai.',
          image: 'assets/images/oil_change_prep.jpg',
          steps: [
            'Siapkan oli baru, filter oli baru, dan wadah untuk oli bekas',
            'Pastikan mesin dalam keadaan hangat (tidak panas) untuk memudahkan keluarnya oli',
            'Parkirkan mobil di permukaan datar dan pasang rem tangan',
            'Buka kap mesin dan temukan lokasi drain plug dan filter oli'
          ],
        ),
        GuideSection(
          title: 'Proses Penggantian Oli',
          content:
              'Proses penggantian oli yang benar akan memastikan mesin tetap dalam kondisi prima dan memperpanjang umur komponen mesin.',
          image: 'assets/images/oil_change.jpg',
          steps: [
            'Letakkan wadah di bawah drain plug dan buka plug untuk mengeluarkan oli lama',
            'Ganti filter oli dengan yang baru (oleskan sedikit oli pada ring karet)',
            'Pasang kembali drain plug dan filter oli dengan torsi yang tepat',
            'Isi mesin dengan oli baru sesuai kapasitas yang direkomendasikan'
          ],
        ),
        GuideSection(
          title: 'Pemeriksaan Level Oli',
          content:
              'Memeriksa level oli secara rutin adalah langkah penting untuk memastikan mesin tetap terlindungi dengan baik.',
          image: 'assets/images/oil_dipstick.jpg',
          steps: [
            'Pastikan mobil di atas permukaan datar saat memeriksa level oli',
            'Keluarkan dipstick, bersihkan, masukkan kembali, lalu keluarkan untuk membaca level',
            'Level oli harus berada di antara tanda MIN dan MAX pada dipstick',
            'Periksa juga warna oli - harus berwarna coklat keemasan, tidak hitam atau keruh'
          ],
        ),
      ],
      tips: [
        'Catat tanggal dan kilometer saat mengganti oli untuk memantau interval',
        'Gunakan kunci filter oli khusus untuk memudahkan melepas filter lama',
        'Simpan sedikit oli cadangan di mobil untuk keadaan darurat',
        'Periksa level oli setiap minggu atau sebelum perjalanan jauh'
      ],
      warnings: [
        'Jangan mengganti oli saat mesin masih panas - risiko luka bakar',
        'Buang oli bekas sesuai regulasi (di tempat daur ulang) - jangan buang sembarangan',
        'Jangan memaksakan filter oli atau drain plug terlalu kencang - bisa merusak ulir',
        'Jangan mencampur jenis oli yang berbeda (mineral dengan sintetis)'
      ],
      videoUrl: 'https://example.com/oil_change_video',
    );
  }
}
