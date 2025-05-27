import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class BengkelSearchScreen extends StatefulWidget {
  const BengkelSearchScreen({super.key});

  @override
  State<BengkelSearchScreen> createState() => _BengkelSearchScreenState();
}

class _BengkelSearchScreenState extends State<BengkelSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _isListView = false;
  String _selectedFilter = 'Semua';
  String _selectedWorkshopType = 'Semua';

  // Updated dummy data bengkel with isOfficial field
  final List<Map<String, dynamic>> bengkelData = [
    {
      'id': '1',
      'name': 'Bengkel Resmi Toyota',
      'position': const LatLng(-6.200000, 106.816666),
      'rating': 4.5,
      'isOpen': true,
      'type': 'Mobil',
      'distance': '0.8 km',
      'address': 'Jl. Raya Kemang No. 10, Jakarta Selatan',
      'phone': '021-7654321',
      'services': ['Tune Up', 'Ganti Oli', 'AC Service', 'Ban'],
      'openHours': '08:00 - 20:00',
      'reviews': 128,
      'price': '💰💰',
      'isOfficial': true,
      'brand': 'Toyota',
    },
    {
      'id': '2',
      'name': 'Bengkel Resmi Honda',
      'position': const LatLng(-6.195000, 106.820000),
      'rating': 4.8,
      'isOpen': true,
      'type': 'Mobil',
      'distance': '1.2 km',
      'address': 'Jl. Gatot Subroto No. 15, Jakarta Selatan',
      'phone': '021-8765432',
      'services': ['Full Service', 'Body Repair', 'Cat Mobil', 'Spooring'],
      'openHours': '24 Jam',
      'reviews': 256,
      'price': '💰💰💰',
      'isOfficial': true,
      'brand': 'Honda',
    },
    {
      'id': '3',
      'name': 'Bengkel Motor Express',
      'position': const LatLng(-6.198000, 106.818000),
      'rating': 4.3,
      'isOpen': true,
      'type': 'Motor',
      'distance': '1.5 km',
      'address': 'Jl. Panglima Polim No. 5, Jakarta Selatan',
      'phone': '021-9876543',
      'services': ['Service Rutin', 'Ganti Oli', 'Ban & Rantai'],
      'openHours': '08:00 - 22:00',
      'reviews': 92,
      'price': '💰',
      'isOfficial': false,
    },
    {
      'id': '4',
      'name': 'Bengkel Resmi Yamaha',
      'position': const LatLng(-6.197000, 106.819000),
      'rating': 4.6,
      'isOpen': true,
      'type': 'Motor',
      'distance': '1.3 km',
      'address': 'Jl. Senopati No. 8, Jakarta Selatan',
      'phone': '021-5432109',
      'services': ['Service Berkala', 'Ganti Oli', 'Tune Up'],
      'openHours': '08:00 - 20:00',
      'reviews': 150,
      'price': '💰💰',
      'isOfficial': true,
      'brand': 'Yamaha',
    },
  ];

  // Initial camera position (Jakarta)
  static const CameraPosition _jakarta = CameraPosition(
    target: LatLng(-6.200000, 106.816666),
    zoom: 11.0,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadNearbyBengkel();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    if (_currentPosition != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('user_position'),
            position:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            infoWindow: const InfoWindow(title: 'Posisi Anda'),
          ),
        );
      });
    }
  }

  Future<void> _loadNearbyBengkel() async {
    setState(() {
      _markers = bengkelData.map((bengkel) {
        return Marker(
          markerId: MarkerId(bengkel['id']),
          position: bengkel['position'],
          infoWindow: InfoWindow(
            title: bengkel['name'],
            snippet: '${bengkel['rating']}⭐ • ${bengkel['type']}',
          ),
          onTap: () {
            _showBengkelDetail(bengkel);
          },
        );
      }).toSet();
    });
  }

  Widget _buildBengkelListItem(Map<String, dynamic> bengkel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () => _showBengkelDetail(bengkel),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://picsum.photos/seed/${bengkel['id']}/400/200'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  if (bengkel['isOfficial'] == true)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Bengkel Resmi ${bengkel['brand'] ?? ''}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: bengkel['isOpen'] ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        bengkel['isOpen'] ? 'Buka' : 'Tutup',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bengkel['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        bengkel['price'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bengkel['address'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        ' ${bengkel['rating']}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        ' (${bengkel['reviews']})',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.location_on,
                          size: 16, color: Theme.of(context).primaryColor),
                      Text(
                        ' ${bengkel['distance']}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: (bengkel['services'] as List<String>)
                        .take(2)
                        .map((service) {
                      return Chip(
                        label: Text(
                          service,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  void _showBengkelDetail(Map<String, dynamic> bengkel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://picsum.photos/seed/${bengkel['id']}/400/200'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              bengkel['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color:
                                  bengkel['isOpen'] ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              bengkel['isOpen'] ? 'Buka' : 'Tutup',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bengkel['address'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(
                            ' ${bengkel['rating']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' (${bengkel['reviews']} reviews)',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const Spacer(),
                          Text(
                            bengkel['price'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Informasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.build, bengkel['type']),
                      _buildInfoRow(Icons.access_time, bengkel['openHours']),
                      _buildInfoRow(Icons.phone, bengkel['phone']),
                      _buildInfoRow(Icons.location_on, bengkel['distance']),
                      const SizedBox(height: 16),
                      const Text(
                        'Layanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (bengkel['services'] as List<String>)
                            .map((service) {
                          return Chip(
                            label: Text(service),
                            backgroundColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement directions
                              },
                              icon: const Icon(Icons.directions),
                              label: const Text('Petunjuk Arah'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Implement call
                              },
                              icon: const Icon(Icons.phone),
                              label: const Text('Hubungi'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari bengkel...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(_isListView ? Icons.map : Icons.list),
                onPressed: () {
                  setState(() {
                    _isListView = !_isListView;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                _buildFilterChip('Bengkel Resmi'),
                _buildFilterChip('Bengkel Umum'),
                _buildFilterChip('1 KM'),
                _buildFilterChip('Mobil'),
                _buildFilterChip('Motor'),
                _buildFilterChip('24 Jam'),
                _buildFilterChip('Rating 4+'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {
          setState(() {
            _selectedFilter = value ? label : 'Semua';
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter bengkel based on selected filter
    List<Map<String, dynamic>> filteredBengkel = bengkelData.where((bengkel) {
      if (_selectedFilter == 'Semua') return true;
      if (_selectedFilter == 'Bengkel Resmi')
        return bengkel['isOfficial'] == true;
      if (_selectedFilter == 'Bengkel Umum')
        return bengkel['isOfficial'] == false;
      if (_selectedFilter == 'Mobil') return bengkel['type'] == 'Mobil';
      if (_selectedFilter == 'Motor') return bengkel['type'] == 'Motor';
      if (_selectedFilter == '24 Jam') return bengkel['openHours'] == '24 Jam';
      if (_selectedFilter == 'Rating 4+')
        return (bengkel['rating'] as double) >= 4.0;
      if (_selectedFilter == '1 KM') {
        double distance = double.parse(bengkel['distance'].split(' ')[0]);
        return distance <= 1.0;
      }
      return true;
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          _isListView
          ? ListView.builder(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 140,
                bottom: 16,
              ),
              itemCount: filteredBengkel.length,
              itemBuilder: (context, index) =>
                  _buildBengkelListItem(filteredBengkel[index]),
            )
          :
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _jakarta,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _getFilteredMarkers(filteredBengkel),
              zoomControlsEnabled: false,
            ),
          SafeArea(
            child: Column(
              children: [
                _buildSearchBar(),
              ],
            ),
          ),
          if (!_isListView)
            Positioned(
              right: 16,
              bottom: 16,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'location',
                    onPressed: _getCurrentLocation,
                    child: const Icon(Icons.my_location),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: 'layers',
                    onPressed: () {
                      // TODO: Implement layer toggle
                    },
                    child: const Icon(Icons.layers),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Set<Marker> _getFilteredMarkers(List<Map<String, dynamic>> filteredBengkel) {
    return filteredBengkel.map((bengkel) {
      return Marker(
        markerId: MarkerId(bengkel['id']),
        position: bengkel['position'],
        infoWindow: InfoWindow(
          title: bengkel['name'],
          snippet:
              '${bengkel['rating']}⭐ • ${bengkel['type']}${bengkel['isOfficial'] ? ' • Resmi' : ''}',
        ),
        onTap: () {
          _showBengkelDetail(bengkel);
        },
      );
    }).toSet();
  }
}
