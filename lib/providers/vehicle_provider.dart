import 'package:flutter/material.dart';
import 'package:vehicare/models/vehicle.dart';

class VehicleProvider with ChangeNotifier {
  final List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void removeVehicle(String id) {
    _vehicles.removeWhere((vehicle) => vehicle.id == id);
    notifyListeners();
  }

  void updateVehicle(Vehicle updatedVehicle) {
    final index = _vehicles.indexWhere((vehicle) => vehicle.id == updatedVehicle.id);
    if (index != -1) {
      _vehicles[index] = updatedVehicle;
      notifyListeners();
    }
  }
} 