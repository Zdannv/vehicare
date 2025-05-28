import 'package:flutter/material.dart';
import 'maintenance_guide_screen.dart';

// Brake System Maintenance Guide
class BrakeMaintenanceScreen extends StatelessWidget {
  const BrakeMaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaintenanceGuideScreen(
      title: 'Perawatan Rem',
      subtitle:
          'Panduan lengkap cara merawat sistem rem mobil agar selalu dalam kondisi prima dan aman digunakan',
      icon: Icons.report_problem,
      color: Colors.red,
      sections: [
        GuideSection(
          title: 'Cara Memeriksa Pad Rem',
          content:
              'Pad rem adalah komponen penting yang bertugas menghentikan laju roda. Ketebalan pad rem harus diperiksa secara berkala untuk memastikan fungsi pengereman optimal.',
          image: 'assets/images/brake_pad.jpg',
          steps: [
            'Pastikan mobil dalam keadaan berhenti dan roda terkunci',
            'Gunakan senter untuk melihat pad rem melalui celah velg',
            'Periksa ketebalan pad rem, jika kurang dari 3mm segera ganti',
            'Periksa semua roda untuk memastikan keausan yang merata'
          ],
        ),
        GuideSection(
          title: 'Pemeriksaan Minyak Rem',
          content:
              'Minyak rem berperan penting dalam sistem pengereman hidrolik. Level minyak rem yang tepat memastikan tekanan yang konsisten saat pedal rem ditekan.',
          image: 'assets/images/brake_fluid.jpg',
          steps: [
            'Buka kap mesin dan temukan reservoir minyak rem',
            'Periksa level minyak rem - harus berada di antara tanda MIN dan MAX',
            'Perhatikan warna minyak rem - harus bening kekuningan, tidak keruh atau gelap',
            'Tambahkan minyak rem jika diperlukan dengan tipe yang sesuai (DOT 3, DOT 4, dll)'
          ],
        ),
        GuideSection(
          title: 'Pemeriksaan Selang dan Kebocoran',
          content:
              'Kebocoran dalam sistem rem dapat berbahaya dan menurunkan efisiensi pengereman. Selang dan komponen sistem rem perlu diperiksa secara rutin.',
          image: 'assets/images/brake_hose.jpg',
          steps: [
            'Periksa selang rem dari keretakan atau kebocoran',
            'Perhatikan area sekitar kaliper rem untuk tanda minyak rem',
            'Periksa bagian bawah master silinder rem untuk kebocoran',
            'Jika ditemukan kebocoran, segera perbaiki di bengkel terpercaya'
          ],
        ),
        GuideSection(
          title: 'Penggantian Minyak Rem',
          content:
              'Minyak rem menyerap kelembaban dari udara seiring waktu. Penggantian berkala diperlukan untuk menjaga performa sistem rem tetap optimal.',
          image: 'assets/images/brake_bleed.jpg',
          steps: [
            'Ganti minyak rem setiap 2 tahun atau 40.000 km',
            'Lakukan bleeding sistem rem untuk mengeluarkan udara',
            'Gunakan alat khusus atau minta bantuan orang lain saat bleeding',
            'Pastikan menggunakan minyak rem dengan spesifikasi yang sesuai'
          ],
        ),
      ],
      tips: [
        'Hindari menekan pedal rem terlalu keras saat mobil tidak bergerak untuk jangka waktu lama',
        'Dengarkan suara decit atau gesekan saat pengereman sebagai indikasi awal masalah',
        'Selalu periksa sistem rem sebelum perjalanan jauh',
        'Jangan menunda penggantian komponen rem yang sudah aus'
      ],
      warnings: [
        'Jangan mengemudi dengan sistem rem bermasalah, hal ini sangat berbahaya',
        'Hindari terkena minyak rem pada cat mobil karena dapat merusak lapisan cat',
        'Jangan mencampur jenis minyak rem yang berbeda',
        'Selalu kuras udara dari sistem rem setelah perbaikan'
      ],
      videoUrl: 'https://youtu.be/cKpmBvfVYZg?si=f6MO_SHWy4N26CPn',
      thumbnailUrl: 'https://img.youtube.com/vi/cKpmBvfVYZg/0.jpg',
    );
  }
}
