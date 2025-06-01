import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'maintenance_guides_router.dart';

class TipsAndGuidesScreen extends StatelessWidget {
  const TipsAndGuidesScreen({super.key});

  // Daftar tips mingguan yang akan berputar setiap 7 hari
  static const List<Map<String, dynamic>> _weeklyTips = [
    {
      'title': 'Cara Menghemat Bahan Bakar',
      'description':
          'Pelajari cara menghemat bahan bakar dengan tips dan trik yang efektif',
      'icon': Icons.local_gas_station,
      'tips': [
        'Gunakan kecepatan konstan 60-80 km/jam',
        'Hindari akselerasi dan pengereman mendadak',
        'Matikan AC saat parkir',
        'Periksa tekanan ban secara rutin'
      ]
    },
    {
      'title': 'Perawatan Filter Udara',
      'description':
          'Tips menjaga filter udara agar performa mesin tetap optimal',
      'icon': Icons.air,
      'tips': [
        'Periksa filter udara setiap 10.000 km',
        'Bersihkan dengan kompresor angin',
        'Ganti filter jika sudah kotor atau rusak',
        'Hindari berkendara di jalan berdebu'
      ]
    },
    {
      'title': 'Perawatan Sistem Pendingin',
      'description':
          'Menjaga suhu mesin tetap stabil dengan perawatan radiator',
      'icon': Icons.ac_unit,
      'tips': [
        'Periksa level air radiator setiap pagi',
        'Gunakan coolant berkualitas baik',
        'Bersihkan kisi-kisi radiator dari kotoran',
        'Ganti air radiator setiap 40.000 km'
      ]
    },
    {
      'title': 'Perawatan Sistem Kelistrikan',
      'description': 'Tips menjaga sistem kelistrikan kendaraan tetap prima',
      'icon': Icons.electrical_services,
      'tips': [
        'Periksa tegangan aki secara berkala',
        'Bersihkan terminal aki dari korosi',
        'Periksa kondisi kabel-kabel kelistrikan',
        'Ganti sekring yang putus dengan amperage sama'
      ]
    }
  ];

  // Function untuk mendapatkan tips berdasarkan minggu
  Map<String, dynamic> _getCurrentWeeklyTip() {
    final now = DateTime.now();
    // Hitung minggu ke berapa dalam tahun (dimulai dari 1 Januari)
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final weekOfYear = (dayOfYear / 7).floor();

    // Gunakan modulo untuk cycling tips setiap 4 minggu
    final tipIndex = weekOfYear % _weeklyTips.length;
    return _weeklyTips[tipIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Tips & Panduan'),
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeaturedTip(context)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  Text(
                    'Panduan Perawatan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 16),
                  buildMaintenanceGuides(context),
                  const SizedBox(height: 24),
                  Text(
                    'Tips Penting',
                    style: Theme.of(context).textTheme.titleLarge,
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 16),
                  _buildImportantTips(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedTip(BuildContext context) {
    final currentTip = _getCurrentWeeklyTip();

    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    currentTip['icon'] as IconData,
                    size: 32,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips Minggu Ini',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentTip['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              currentTip['description'] as String,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                _showTipDetailsDialog(context, currentTip);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                side: BorderSide(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                ),
              ),
              child: const Text('Baca Selengkapnya'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTipDetailsDialog(BuildContext context, Map<String, dynamic> tip) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        tip['icon'] as IconData,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        tip['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  tip['description'] as String,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  'Tips Detail:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                ...(tip['tips'] as List<String>).asMap().entries.map((entry) {
                  final index = entry.key;
                  final tipText = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tipText,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        ).animate().scale(
              begin: const Offset(0.8, 0.8),
              duration: 200.ms,
              curve: Curves.easeOutBack,
            );
      },
    );
  }

  Widget _buildImportantTips(BuildContext context) {
    final tips = [
      {
        'title': 'Yang Harus Dilakukan',
        'items': [
          'Periksa tekanan ban secara rutin',
          'Ganti oli sesuai jadwal',
          'Periksa air radiator',
          'Periksa kondisi rem',
          'Jaga kebersihan kendaraan',
        ],
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'title': 'Yang Tidak Boleh Dilakukan',
        'items': [
          'Mengabaikan bunyi aneh',
          'Menunda servis berkala',
          'Menggunakan bensin yang salah',
          'Mengabaikan lampu indikator',
          'Mengemudi dengan kasar',
        ],
        'icon': Icons.cancel,
        'color': Colors.red,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (tip['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        tip['icon'] as IconData,
                        color: tip['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      tip['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...(tip['items'] as List<String>).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          tip['icon'] as IconData,
                          size: 16,
                          color: tip['color'] as Color,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ).animate(delay: (200 * index).ms).fadeIn().slideY();
      },
    );
  }
}
