import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/maintenance_schedule.dart';
import '../providers/maintenance_provider.dart';

class MaintenanceScheduleScreen extends StatefulWidget {
  const MaintenanceScheduleScreen({Key? key}) : super(key: key);

  @override
  _MaintenanceScheduleScreenState createState() =>
      _MaintenanceScheduleScreenState();
}

class _MaintenanceScheduleScreenState extends State<MaintenanceScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _kmIntervalController = TextEditingController();
  final TextEditingController _dayIntervalController = TextEditingController();
  String? _selectedServiceType;
  bool _enableAutoTracking = false;

  // Service type configurations
  final Map<String, Map<String, int>> _serviceIntervals = {
    'Ganti Oli': {'km': 5000, 'days': 90},
    'Servis Berkala': {'km': 10000, 'days': 180},
    'Ganti Ban': {'km': 40000, 'days': 365 * 2},
    'Tune Up': {'km': 20000, 'days': 365},
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaintenanceProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _kmIntervalController.dispose();
    _dayIntervalController.dispose();
    super.dispose();
  }

  void _updateIntervalFields() {
    if (_selectedServiceType != null &&
        _serviceIntervals.containsKey(_selectedServiceType)) {
      final intervals = _serviceIntervals[_selectedServiceType]!;
      _kmIntervalController.text = intervals['km'].toString();
      _dayIntervalController.text = intervals['days'].toString();
    }
  }

  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Jadwal Perawatan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedServiceType,
                decoration: const InputDecoration(
                  labelText: 'Jenis Perawatan',
                  border: OutlineInputBorder(),
                ),
                items: _serviceIntervals.keys.map((serviceType) {
                  return DropdownMenuItem(
                    value: serviceType,
                    child: Text(serviceType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedServiceType = value;
                    _updateIntervalFields();
                  });
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Aktifkan Pelacakan Otomatis'),
                subtitle: const Text(
                    'Sistem akan melacak jarak dan waktu secara otomatis'),
                value: _enableAutoTracking,
                onChanged: (value) {
                  setState(() {
                    _enableAutoTracking = value ?? false;
                  });
                },
              ),
              if (_enableAutoTracking) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _kmIntervalController,
                        decoration: const InputDecoration(
                          labelText: 'Interval KM',
                          border: OutlineInputBorder(),
                          suffixText: 'km',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _dayIntervalController,
                        decoration: const InputDecoration(
                          labelText: 'Interval Hari',
                          border: OutlineInputBorder(),
                          suffixText: 'hari',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_selectedServiceType != null && _selectedDay != null) {
                final schedule = MaintenanceSchedule(
                  id: DateTime.now().toString(),
                  vehicleId: 'current_vehicle_id',
                  serviceType: _selectedServiceType!,
                  scheduledDate: _selectedDay!,
                  notes: _notesController.text,
                  autoTrackingEnabled: _enableAutoTracking,
                  intervalKm: _enableAutoTracking
                      ? int.tryParse(_kmIntervalController.text)
                      : null,
                  intervalDays: _enableAutoTracking
                      ? int.tryParse(_dayIntervalController.text)
                      : null,
                );
                context.read<MaintenanceProvider>().addSchedule(schedule);

                // Clear form
                _selectedServiceType = null;
                _enableAutoTracking = false;
                _notesController.clear();
                _kmIntervalController.clear();
                _dayIntervalController.clear();

                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTrackingCard() {
    return Consumer<MaintenanceProvider>(
      builder: (context, provider, child) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      provider.isTrackingLocation
                          ? Icons.location_on
                          : Icons.location_off,
                      color: provider.isTrackingLocation
                          ? Colors.green
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pelacakan Lokasi',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Switch(
                      value: provider.isTrackingLocation,
                      onChanged: (value) async {
                        try {
                          if (value) {
                            await provider.startLocationTracking();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Pelacakan lokasi dimulai')),
                            );
                          } else {
                            await provider.stopLocationTracking();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Pelacakan lokasi dihentikan')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Jarak: ${provider.totalDistanceKm.toStringAsFixed(1)} km',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (!provider.isTrackingLocation)
                  const Text(
                    'Aktifkan untuk melacak jarak perjalanan secara otomatis',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Perawatan'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLocationTrackingCard(),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Bulan'},
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
            DefaultTabController(
              length: 3, // Added one more tab for overdue items
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Mendatang'),
                      Tab(text: 'Perlu Perhatian'),
                      Tab(text: 'Riwayat'),
                      // Tab(text: 'Tips'),
                    ],
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: TabBarView(
                      children: [
                        _buildUpcomingTab(),
                        _buildOverdueTab(),
                        _buildHistoryTab(),
                        // _buildTipsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleDialog,
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildUpcomingTab() {
    return Consumer<MaintenanceProvider>(
      builder: (context, provider, child) {
        final schedules = provider.upcomingSchedules;
        if (schedules.isEmpty) {
          return const Center(
            child: Text('Belum ada jadwal perawatan'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final schedule = schedules[index];
            final daysUntil =
                schedule.scheduledDate.difference(DateTime.now()).inDays;
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(schedule.serviceType[0]),
                ),
                title: Text(schedule.serviceType),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dijadwalkan: ${schedule.scheduledDate.day}/${schedule.scheduledDate.month}/${schedule.scheduledDate.year}',
                    ),
                    if (schedule.autoTrackingEnabled)
                      Row(
                        children: [
                          const Icon(Icons.track_changes,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 0),
                          const Text('Auto-tracking aktif',
                              style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    // if (daysUntil <= 7)
                    //   Text(
                    //     daysUntil <= 0 ? 'Hari ini!' : 'Dalam $daysUntil hari',
                    //     style: TextStyle(
                    //       color: daysUntil <= 3 ? Colors.red : Colors.orange,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    if (schedule.notes.isNotEmpty)
                      Text(
                        'Catatan: ${schedule.notes}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () {
                        provider.completeSchedule(schedule.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteSchedule(schedule.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOverdueTab() {
    return Consumer<MaintenanceProvider>(
      builder: (context, provider, child) {
        final overdueSchedules = provider.overdueSchedules;
        if (overdueSchedules.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green),
                SizedBox(height: 16),
                Text('Semua perawatan up-to-date!'),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: overdueSchedules.length,
          itemBuilder: (context, index) {
            final schedule = overdueSchedules[index];
            final daysSinceService =
                DateTime.now().difference(schedule.completedDate!).inDays;
            final kmSinceService =
                provider.totalDistanceKm - (schedule.kmAtService ?? 0);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: Colors.red.shade50,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.warning, color: Colors.white),
                ),
                title: Text(
                  '${schedule.serviceType} - Perlu Dilakukan!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Terakhir: ${schedule.completedDate!.day}/${schedule.completedDate!.month}/${schedule.completedDate!.year}'),
                    if (schedule.intervalDays != null)
                      Text(
                          'Waktu: $daysSinceService dari ${schedule.intervalDays} hari'),
                    if (schedule.intervalKm != null)
                      Text(
                          'Jarak: ${kmSinceService.toStringAsFixed(0)} dari ${schedule.intervalKm} km'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Create new service schedule
                    final newSchedule = MaintenanceSchedule(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      vehicleId: schedule.vehicleId,
                      serviceType: schedule.serviceType,
                      scheduledDate: DateTime.now(),
                      notes: 'Dijadwalkan berdasarkan auto-tracking',
                      autoTrackingEnabled: true,
                      intervalKm: schedule.intervalKm,
                      intervalDays: schedule.intervalDays,
                    );
                    provider.addSchedule(newSchedule);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Jadwalkan'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<MaintenanceProvider>(
      builder: (context, provider, child) {
        final completedSchedules = provider.completedSchedules;
        if (completedSchedules.isEmpty) {
          return const Center(
            child: Text('Belum ada riwayat perawatan'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: completedSchedules.length,
          itemBuilder: (context, index) {
            final schedule = completedSchedules[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                title: Text(schedule.serviceType),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selesai: ${schedule.completedDate?.day}/${schedule.completedDate?.month}/${schedule.completedDate?.year}',
                    ),
                    if (schedule.kmAtService != null)
                      Text(
                          'Pada: ${schedule.kmAtService!.toStringAsFixed(0)} km'),
                    if (schedule.autoTrackingEnabled)
                      Row(
                        children: [
                          const Icon(Icons.track_changes,
                              size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          const Text('Auto-tracking',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    if (schedule.notes.isNotEmpty)
                      Text(
                        'Catatan: ${schedule.notes}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTipsTab() {
    // Your existing tips implementation
    return const Center(child: Text('Tips Perawatan'));
  }
}
