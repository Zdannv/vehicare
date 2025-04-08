class MaintenanceSchedule {
  final String id;
  final String vehicleId;
  final String serviceType;
  final DateTime scheduledDate;
  final String notes;
  final bool isCompleted;
  final DateTime? completedDate;

  MaintenanceSchedule({
    required this.id,
    required this.vehicleId,
    required this.serviceType,
    required this.scheduledDate,
    this.notes = '',
    this.isCompleted = false,
    this.completedDate,
  });

  MaintenanceSchedule copyWith({
    String? id,
    String? vehicleId,
    String? serviceType,
    DateTime? scheduledDate,
    String? notes,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return MaintenanceSchedule(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      serviceType: serviceType ?? this.serviceType,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

class MaintenanceRecommendation {
  final String serviceType;
  final int recommendedInterval; // in days
  final String description;
  final String importanceLevel; // 'low', 'medium', 'high'
  final String tips;
  final String icon;

  MaintenanceRecommendation({
    required this.serviceType,
    required this.recommendedInterval,
    required this.description,
    required this.importanceLevel,
    required this.tips,
    required this.icon,
  });
}

// Predefined maintenance recommendations
final List<MaintenanceRecommendation> defaultRecommendations = [
  MaintenanceRecommendation(
    serviceType: 'Ganti Oli',
    recommendedInterval: 60, // 2 bulan
    description: 'Penggantian oli mesin untuk menjaga performa',
    importanceLevel: 'high',
    tips: 'Gunakan oli yang sesuai dengan spesifikasi kendaraan Anda. Oli yang berkualitas dapat melindungi mesin lebih baik dan bertahan lebih lama.',
    icon: '🔧',
  ),
  MaintenanceRecommendation(
    serviceType: 'Kampas Rem',
    recommendedInterval: 90, // 3 bulan
    description: 'Periksa dan ganti kampas rem untuk keamanan',
    importanceLevel: 'high',
    tips: 'Perhatikan suara decit saat pengereman dan pastikan rem bekerja dengan responsif. Keselamatan adalah prioritas utama!',
    icon: '🛑',
  ),
  MaintenanceRecommendation(
    serviceType: 'Rotasi Ban',
    recommendedInterval: 90, // 3 bulan
    description: 'Rotasi ban untuk memastikan keausan yang merata',
    importanceLevel: 'medium',
    tips: 'Rotasi ban secara teratur membantu ban aus secara merata dan memperpanjang umur ban. Periksa juga tekanan ban setiap 2 minggu.',
    icon: '🚗',
  ),
  MaintenanceRecommendation(
    serviceType: 'Filter Udara',
    recommendedInterval: 90, // 3 bulan
    description: 'Ganti filter udara untuk performa mesin yang lebih baik',
    importanceLevel: 'medium',
    tips: 'Filter udara yang kotor dapat mengurangi efisiensi bahan bakar hingga 10%. Bersihkan atau ganti secara rutin untuk performa optimal.',
    icon: '💨',
  ),
  MaintenanceRecommendation(
    serviceType: 'Periksa Radiator',
    recommendedInterval: 180, // 6 bulan
    description: 'Periksa dan isi ulang cairan pendingin',
    importanceLevel: 'medium',
    tips: 'Jangan buka tutup radiator saat mesin masih panas! Tunggu minimal 30 menit setelah mesin dimatikan untuk menghindari luka bakar.',
    icon: '🌡️',
  ),
  MaintenanceRecommendation(
    serviceType: 'Periksa Aki',
    recommendedInterval: 180, // 6 bulan
    description: 'Periksa kondisi aki dan sambungan',
    importanceLevel: 'medium',
    tips: 'Bersihkan terminal aki dari korosi dan pastikan sambungan kencang. Aki yang terawat dapat bertahan hingga 3-5 tahun.',
    icon: '⚡',
  ),
]; 