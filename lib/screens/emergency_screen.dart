import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            backgroundColor: Colors.red,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text('Layanan Darurat'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.red, Colors.redAccent],
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
                  const Center(
                    child: Icon(
                      Icons.emergency,
                      size: 64,
                      color: Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEmergencyCard(context)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  Text(
                    'Kontak Darurat',
                    style: Theme.of(context).textTheme.titleLarge,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 16),
                  _buildContactsGrid(context),
                  const SizedBox(height: 24),
                  Text(
                    'Layanan Terdekat',
                    style: Theme.of(context).textTheme.titleLarge,
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 16),
                  _buildNearbyServicesGrid(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _launchUrl('tel:112'),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.phone, color: Colors.white),
        label: const Text(
          'EMERGENCY CALL',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dalam Keadaan Darurat?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tekan tombol emergency call di bawah untuk bantuan segera',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsGrid(BuildContext context) {
    final contacts = [
      {
        'title': 'Bantuan Jalan',
        'subtitle': 'Layanan Derek 24/7',
        'icon': Icons.local_taxi,
        'color': Colors.blue,
        'number': '+1234567890',
      },
      {
        'title': 'Polisi',
        'subtitle': 'Layanan Polisi Darurat',
        'icon': Icons.local_police,
        'color': Colors.indigo,
        'number': '110',
      },
      {
        'title': 'Pemadam',
        'subtitle': 'Layanan Pemadam Kebakaran',
        'icon': Icons.fire_truck,
        'color': Colors.orange,
        'number': '113',
      },
      {
        'title': 'Ambulans',
        'subtitle': 'Layanan Medis Darurat',
        'icon': Icons.emergency,
        'color': Colors.red,
        'number': '119',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Card(
          color: contact['color'] as Color,
          child: InkWell(
            onTap: () => _launchUrl('tel:${contact['number']}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      contact['icon'] as IconData,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    contact['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact['subtitle'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate(delay: (200 * index).ms).fadeIn().slideX();
      },
    );
  }

  Widget _buildNearbyServicesGrid(BuildContext context) {
    final services = [
      {
        'title': 'Rumah Sakit',
        'subtitle': 'Cari rumah sakit terdekat',
        'icon': Icons.local_hospital,
        'color': Colors.green,
      },
      {
        'title': 'SPBU',
        'subtitle': 'Cari SPBU terdekat',
        'icon': Icons.local_gas_station,
        'color': Colors.purple,
      },
      {
        'title': 'Bengkel',
        'subtitle': 'Cari bengkel terdekat',
        'icon': Icons.build,
        'color': Colors.blue,
      },
      {
        'title': 'Polisi',
        'subtitle': 'Cari kantor polisi terdekat',
        'icon': Icons.local_police,
        'color': Colors.indigo,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          child: InkWell(
            onTap: () {
              // TODO: Navigate to service search
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (service['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      service['icon'] as IconData,
                      color: service['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    service['title'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    service['subtitle'] as String,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate(delay: (200 * index).ms).fadeIn().slideX();
      },
    );
  }
} 