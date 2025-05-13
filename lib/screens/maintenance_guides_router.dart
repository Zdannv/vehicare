import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vehicare/screens/battery_maintenance_screen.dart';
import 'package:vehicare/screens/oil_change_screen.dart';
import 'package:vehicare/screens/tire_maintenance_screen.dart';
import 'brake_maintenance_screen.dart';
// import 'tire_maintenance_screen.dart';
// import 'oil_change_screen.dart';
// import 'battery_maintenance_screen.dart';

// Fungsi navigasi sederhana
void navigateToGuide(BuildContext context, String guide) {
  Widget targetScreen;
  switch (guide) {
    case 'tire':
      targetScreen = const TireMaintenanceScreen();
      break;
    case 'oil':
      targetScreen = const OilChangeScreen();
      break;
    case 'battery':
      targetScreen = const BatteryMaintenanceScreen();
      break;
    case 'brake':
      targetScreen = const BrakeMaintenanceScreen();
      break;
    default:
      return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => targetScreen),
  );
}

Widget buildMaintenanceGuides(BuildContext context) {
  final guides = [
    {
      'title': 'Perawatan Ban',
      'subtitle': 'Panduan lengkap merawat ban',
      'icon': Icons.tire_repair,
      'color': Colors.blue,
      'route': 'tire',
    },
    {
      'title': 'Ganti Oli',
      'subtitle': 'Kapan harus ganti oli',
      'icon': Icons.oil_barrel,
      'color': Colors.orange,
      'route': 'oil',
    },
    {
      'title': 'Aki Mobil',
      'subtitle': 'Cara merawat aki',
      'icon': Icons.battery_charging_full,
      'color': Colors.green,
      'route': 'battery',
    },
    {
      'title': 'Rem',
      'subtitle': 'Perawatan sistem rem',
      'icon': Icons.report_problem,
      'color': Colors.red,
      'route': 'brake',
    },
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: guides.length,
    itemBuilder: (context, index) {
      final guide = guides[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (guide['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              guide['icon'] as IconData,
              color: guide['color'] as Color,
            ),
          ),
          title: Text(guide['title'] as String),
          subtitle: Text(guide['subtitle'] as String),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Menggunakan navigator biasa
            navigateToGuide(context, guide['route'] as String);
          },
        ),
      ).animate(delay: (100 * index).ms).fadeIn().slideX();
    },
  );
}
