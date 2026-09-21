class Appointment {

  const Appointment({
    required this.id,
    required this.userId,
    required this.salonId,
    required this.serviceName,
    required this.stylistName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.totalPrice,
    this.notes = '',
  });
  final String id;
  final String userId;
  final String salonId;
  final String serviceName;
  final String stylistName;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String status;
  final double totalPrice;
  final String notes;

  String get formattedDate {
    final date = appointmentDate;
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedPrice => '\$${totalPrice.toStringAsFixed(2)}';

  bool get isUpcoming {
    final now = DateTime.now();
    return appointmentDate.isAfter(now) && status != 'cancelled';
  }

  bool get isCompleted => status == 'completed';

  bool get isCancelled => status == 'cancelled';

  @override
  String toString() => 'Appointment(id: $id, date: $formattedDate, status: $status)';
}
