import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicare/providers/vehicle_provider.dart';
import 'package:vehicare/models/vehicle.dart';
import 'package:vehicare/screens/main_screen.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'car';
  final _nameController = TextEditingController();
  final _kilometerController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _kilometerController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final vehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        kilometer: _kilometerController.text,
      );

      context.read<VehicleProvider>().addVehicle(vehicle);
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (Route<dynamic> route) => false,
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kendaraan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jenis Kendaraan',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 300,
                        child: 
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'car',
                            label: Text('Mobil'),
                            icon: Icon(Icons.directions_car),
                          ),
                          ButtonSegment(
                            value: 'motorcycle',
                            label: Text('Motor'),
                            icon: Icon(Icons.motorcycle),
                          ),
                        ],
                        selected: {_selectedType},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _selectedType = newSelection.first;
                          });
                        },
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kendaraan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan nama kendaraan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kilometerController,
                decoration: const InputDecoration(
                  labelText: 'Kilometer',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon masukkan kilometer kendaraan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 300),
              ElevatedButton(
                  onPressed: _submitForm,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Tambah Kendaraan'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
