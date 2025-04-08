class Vehicle {
  final String id;
  final String name;
  final String type;
  final String brand;
  final String model;
  final String year;
  final String plateNumber;
  final String imageUrl;

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.brand,
    required this.model,
    required this.year,
    required this.plateNumber,
    this.imageUrl = '',
  });
} 