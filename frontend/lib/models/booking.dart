class Booking {
  final String id;
  final String bookingTitle;
  final DateTime startTime;
  final DateTime endTime;

  Booking({
    required this.id,
    required this.bookingTitle,
    required this.startTime,
    required this.endTime,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      bookingTitle: json['bookingTitle'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}
