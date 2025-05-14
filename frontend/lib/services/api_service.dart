import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ApiService {
  static final baseUrl = dotenv.env['API_BASE_URL']!;

  // function written to get all the bookings
  static Future<List<Booking>> fetchBookings() async {
    final res = await http.get(Uri.parse('$baseUrl/bookings'));
    if (res.statusCode != 200) throw Exception('Failed to load bookings');
    return (jsonDecode(res.body) as List)
        .map((e) => Booking.fromJson(e))
        .toList();
  }

  // function written to get the booking by ID
  static Future<Booking> fetchBookingById(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/bookings/$id'));
    if (res.statusCode == 200) {
      return Booking.fromJson(jsonDecode(res.body));
    } else {
      final msg = jsonDecode(res.body)['error'] ?? 'Failed to fetch booking';
      throw Exception(msg);
    }
  }

  // function written to create a booking
  static Future<Booking> createBooking(
    String bookingTitle,
    String start,
    String end,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'bookingTitle': bookingTitle,
        'startTime': start,
        'endTime': end,
      }),
    );
    if (res.statusCode == 201) {
      return Booking.fromJson(jsonDecode(res.body));
    } else {
      final msg = jsonDecode(res.body)['error'] ?? 'Error creating booking';
      throw Exception(msg);
    }
  }

  //function written to update the bookinb
  static Future<Booking> updateBooking(
    String id,
    String start,
    String end,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/bookings/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'startTime': start, 'endTime': end}),
    );
    if (res.statusCode == 200) {
      return Booking.fromJson(jsonDecode(res.body));
    } else {
      final msg = jsonDecode(res.body)['error'] ?? 'Error updating booking';
      throw Exception(msg);
    }
  }

  //function written to delete a particular booking
  static Future<void> deleteBooking(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/bookings/$id'));
    if (res.statusCode != 204) {
      throw Exception('Error deleting booking');
    }
  }
}
