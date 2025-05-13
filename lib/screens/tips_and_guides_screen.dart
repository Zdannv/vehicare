import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'maintenance_guides_router.dart';

class TipsAndGuidesScreen extends StatelessWidget {
  const TipsAndGuidesScreen({super.key});

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
                  buildMaintenanceGuides(
                      context), // Using the updated function from maintenance_guides_router.dart
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
                    Icons.auto_awesome,
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
                        'Cara Menghemat Bahan Bakar',
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
              'Pelajari cara menghemat bahan bakar dengan tips dan trik yang efektif',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Navigate to fuel saving tips
                // Could be implemented in a future enhancement
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
