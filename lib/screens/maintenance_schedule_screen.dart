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
  String? _selectedServiceType;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Jadwal Perawatan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedServiceType,
              decoration: const InputDecoration(
                labelText: 'Jenis Perawatan',
                border: OutlineInputBorder(),
              ),
              items: defaultRecommendations.map((recommendation) {
                return DropdownMenuItem(
                  value: recommendation.serviceType,
                  child: Text(recommendation.serviceType),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedServiceType = value;
                });
              },
            ),
            const SizedBox(height: 16),
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
                );
                context.read<MaintenanceProvider>().addSchedule(schedule);
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
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
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: 'Mendatang'),
                      Tab(text: 'Riwayat'),
                      //Tab(text: 'Tips'),
                    ],
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: TabBarView(
                      children: [
                        // Tab Jadwal Mendatang
                        Consumer<MaintenanceProvider>(
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
                                final daysUntil = schedule.scheduledDate
                                    .difference(DateTime.now())
                                    .inDays;
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      child: Text(schedule.serviceType[0]),
                                    ),
                                    title: Text(schedule.serviceType),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dijadwalkan: ${schedule.scheduledDate.day}/${schedule.scheduledDate.month}/${schedule.scheduledDate.year}',
                                        ),
                                        if (daysUntil <= 7)
                                          Text(
                                            daysUntil <= 0
                                                ? 'Hari ini!'
                                                : 'Dalam $daysUntil hari',
                                            style: TextStyle(
                                              color: daysUntil <= 3
                                                  ? Colors.red
                                                  : Colors.orange,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.check_circle_outline),
                                          onPressed: () {
                                            provider
                                                .completeSchedule(schedule.id);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            provider
                                                .deleteSchedule(schedule.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        // Tab Riwayat
                        Consumer<MaintenanceProvider>(
                          builder: (context, provider, child) {
                            final completedSchedules =
                                provider.completedSchedules;
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
                                      child: Icon(Icons.check,
                                          color: Colors.white),
                                    ),
                                    title: Text(schedule.serviceType),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Selesai: ${schedule.completedDate?.day}/${schedule.completedDate?.month}/${schedule.completedDate?.year}',
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
                        )
                        // Tab Tips Perawatan
                        /*ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: defaultRecommendations.length,
                          itemBuilder: (context, index) {
                            final recommendation =
                                defaultRecommendations[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ExpansionTile(
                                leading: Text(
                                  recommendation.icon,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                title: Text(
                                  recommendation.serviceType,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Setiap ${recommendation.recommendedInterval ~/ 30} bulan',
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recommendation.description,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.lightbulb,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  recommendation.tips,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),*/
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
}
