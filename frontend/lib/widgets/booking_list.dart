import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/api_service.dart';

class BookingList extends StatelessWidget {
  final VoidCallback onRefresh;
  const BookingList({required this.onRefresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Booking>>(
      future: ApiService.fetchBookings(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final bookings = snapshot.data!;
        if (bookings.isEmpty) {
          return Center(child: Text('No bookings found.'));
        }
        return RefreshIndicator(
          onRefresh: () async {
            onRefresh();
            await Future.delayed(Duration(milliseconds: 100));
          },
          child: ListView.separated(
            itemCount: bookings.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (ctx, i) {
              final b = bookings[i];
              return ListTile(
                title: Text('Booking Title: ${b.bookingTitle}'),
                subtitle: Text(
                  'ID:    ${b.id}\n'
                  'Start: ${b.startTime.toLocal()}\n'
                  'End:   ${b.endTime.toLocal()}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () async {
                    await ApiService.deleteBooking(b.id);
                    onRefresh();
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
