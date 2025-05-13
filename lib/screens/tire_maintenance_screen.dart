import 'package:flutter/material.dart';
import 'maintenance_guide_screen.dart';

class TireMaintenanceScreen extends StatelessWidget {
  const TireMaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaintenanceGuideScreen(
      title: 'Perawatan Ban',
      subtitle:
          'Panduan lengkap merawat ban mobil agar awet, aman, dan hemat bahan bakar',
      icon: Icons.tire_repair,
      color: Colors.blue,
      sections: [
        GuideSection(
          title: 'Memeriksa Tekanan Ban',
          content:
              'Tekanan ban yang tepat sangat penting untuk keamanan, handling, dan efisiensi bahan bakar. Ban dengan tekanan yang terlalu rendah atau terlalu tinggi dapat menyebabkan keausan yang tidak merata.',
          image: 'assets/images/tire_pressure.jpg',
          steps: [
            'Periksa tekanan ban saat kondisi dingin (minimal 3 jam setelah berkendara)',
            'Gunakan alat pengukur tekanan ban yang akurat',
            'Sesuaikan dengan tekanan yang direkomendasikan (tertera pada stiker di pintu mobil)',
            'Periksa juga ban cadangan secara berkala'
          ],
        ),
        GuideSection(
          title: 'Rotasi Ban',
          content:
              'Rotasi ban adalah proses menukar posisi ban untuk memastikan keausan yang merata. Ini akan memperpanjang umur ban dan menjaga performa kendaraan.',
          image: 'assets/images/tire_rotation.jpg',
          steps: [
            'Lakukan rotasi ban setiap 10.000 km',
            'Ikuti pola rotasi yang sesuai dengan jenis penggerak mobil (FWD, RWD, AWD)',
            'Pastikan torsi baut roda sesuai spesifikasi',
            'Periksa keseimbangan ban setelah rotasi jika diperlukan'
          ],
        ),
        GuideSection(
          title: 'Memeriksa Kedalaman Alur Ban',
          content:
              'Alur ban dirancang untuk membuang air saat berkendara di jalan basah. Kedalaman alur yang cukup sangat penting untuk mencegah hydroplaning dan menjaga traksi.',
          image: 'assets/images/tire_tread.jpg',
          steps: [
            'Gunakan pengukur kedalaman alur atau koin untuk memeriksa',
            'Kedalaman alur minimal adalah 1.6mm (batas legal)',
            'Periksa pada beberapa titik di seluruh permukaan ban',
            'Ganti ban jika kedalaman alur sudah mencapai batas atau di bawahnya'
          ],
        ),
        GuideSection(
          title: 'Alignment dan Balancing',
          content:
              'Wheel alignment dan balancing yang tepat memastikan handling yang baik, keausan ban yang merata, dan kenyamanan berkendara.',
          image: 'assets/images/wheel_alignment.jpg',
          steps: [
            'Lakukan balancing roda setiap 20.000 km atau jika ada getaran',
            'Lakukan alignment setelah menabrak lubang besar atau trotoar',
            'Perhatikan tanda-tanda alignment yang tidak tepat seperti setir yang tidak center',
            'Kunjungi bengkel profesional untuk layanan alignment dan balancing'
          ],
        ),
      ],
      tips: [
        'Bawa ban ke tekanan yang lebih rendah (sesuai rekomendasi) saat berkendara di jalan off-road',
        'Simpan ban yang tidak digunakan di tempat sejuk dan kering, jauh dari sinar matahari langsung',
        'Bersihkan ban secara berkala untuk mencegah kerusakan dari zat kimia jalanan',
        'Ganti keempat ban sekaligus untuk performa terbaik'
      ],
      warnings: [
        'Jangan mengemudi dengan ban yang aus atau rusak',
        'Hindari benturan keras dengan lubang atau trotoar',
        'Jangan mencampur tipe ban yang berbeda pada satu mobil',
        'Perhatikan umur ban - bahkan ban dengan alur yang masih baik harus diganti setelah 5-6 tahun'
      ],
      videoUrl: 'https://example.com/tire_maintenance_video',
    );
  }
}
