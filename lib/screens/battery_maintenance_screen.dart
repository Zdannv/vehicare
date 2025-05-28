import 'package:flutter/material.dart';
import 'maintenance_guide_screen.dart';

class BatteryMaintenanceScreen extends StatelessWidget {
  const BatteryMaintenanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaintenanceGuideScreen(
      title: 'Perawatan Aki',
      subtitle:
          'Panduan lengkap merawat aki mobil agar awet dan selalu siap pakai kapanpun dibutuhkan',
      icon: Icons.battery_charging_full,
      color: Colors.green,
      sections: [
        GuideSection(
          title: 'Pemeriksaan Kondisi Terminal',
          content:
              'Terminal aki yang bersih dan kencang memastikan aliran listrik yang baik. Korosi pada terminal dapat menyebabkan masalah starting dan pengisian.',
          image: 'assets/images/battery_terminal.jpg',
          steps: [
            'Periksa terminal aki dari korosi (serbuk putih atau kehijauan)',
            'Lepaskan kabel aki (negatif/hitam dahulu, positif/merah kemudian)',
            'Bersihkan terminal dengan sikat kawat dan larutan baking soda',
            'Pasang kembali kabel dengan kencang dan oleskan petroleum jelly'
          ],
        ),
        GuideSection(
          title: 'Memeriksa Level Elektrolit',
          content:
              'Untuk aki basah (flooded battery), level elektrolit yang tepat sangat penting untuk performa dan umur aki.',
          image: 'assets/images/battery_electrolyte.jpg',
          steps: [
            'Buka tutup sel aki (hanya untuk aki basah yang bisa dibuka)',
            'Periksa level cairan - harus menutupi plat dan berada di antara tanda MIN dan MAX',
            'Jika kurang, tambahkan air suling (bukan air biasa) hingga level yang tepat',
            'Tutup kembali sel aki dengan rapat'
          ],
        ),
        GuideSection(
          title: 'Pengukuran Tegangan Aki',
          content:
              'Tegangan aki yang tepat mengindikasikan kondisi kesehatan aki. Pengukuran berkala membantu mendeteksi masalah sebelum aki benar-benar rusak.',
          image: 'assets/images/battery_voltage.jpg',
          steps: [
            'Gunakan multimeter digital untuk mengukur tegangan',
            'Aki dalam kondisi baik menunjukkan 12.4-12.7 volt saat mesin mati',
            'Saat mesin hidup, tegangan harus sekitar 13.7-14.7 volt (menunjukkan sistem charging berfungsi)',
            'Jika tegangan di bawah 12.4V, aki perlu diisi ulang atau diperiksa lebih lanjut'
          ],
        ),
        GuideSection(
          title: 'Penggantian Aki',
          content:
              'Aki mobil memiliki umur terbatas dan perlu diganti secara berkala, biasanya setiap 2-5 tahun tergantung kualitas dan kondisi penggunaan.',
          image: 'assets/images/battery_replacement.jpg',
          steps: [
            'Identifikasi ukuran dan spesifikasi aki yang tepat untuk kendaraan Anda',
            'Lepaskan kabel aki (negatif/hitam dahulu, kemudian positif/merah)',
            'Lepaskan pengikat aki dan angkat aki lama dengan hati-hati',
            'Pasang aki baru, kencangkan pengikat, lalu sambungkan kabel (positif dahulu, kemudian negatif)'
          ],
        ),
      ],
      tips: [
        'Hindari menyalakan fitur elektrik saat mesin mati terlalu lama',
        'Lakukan perjalanan panjang sesekali untuk mengisi aki sepenuhnya',
        'Gunakan charger aki untuk kendaraan yang jarang dipakai',
        'Bersihkan permukaan aki secara berkala untuk mencegah arus bocor'
      ],
      warnings: [
        'Jangan merokok atau membuat percikan api di dekat aki - gas hidrogen bisa meledak',
        'Jangan menyentuh terminal positif dan negatif bersamaan - risiko kejutan listrik',
        'Pakai sarung tangan dan kacamata saat menangani aki - elektrolit bersifat korosif',
        'Jangan mencoba membuka aki tertutup (maintenance-free) - berbahaya dan merusak aki'
      ],
      videoUrl: 'https://www.youtube.com/embed/V7EFAvFPOhw?si=XaaTmehAK6vmjXR1',
      thumbnailUrl: 'https://img.youtube.com/vi/V7EFAvFPOhw/0.jpg',
    );
  }
}
