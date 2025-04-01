class Booking {
  final String id;
  final String userId;
  final String propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final double totalPrice;
  final String status;

  Booking({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    this.status = 'Pending',
  });

  factory Booking.fromFirestore(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      userId: data['userId'] ?? '',
      propertyId: data['propertyId'] ?? '',
      checkIn: DateTime.parse(data['checkIn'] ?? DateTime.now().toString()),
      checkOut: DateTime.parse(data['checkOut'] ?? DateTime.now().toString()),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'propertyId': propertyId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status,
    };
  }
}