import 'package:flutter/material.dart';
import 'widgets/booking_form.dart';
import 'widgets/booking_lookup.dart';
import 'widgets/booking_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Booking',
      home: Scaffold(
        appBar: AppBar(title: const Text('Calendar Booking')),
        body: const BookingPage(),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);
  @override State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool _showList = false;

  void _reloadList() {
    if (_showList) {
      setState(() => _showList = false);
      Future.delayed(Duration.zero, () => setState(() => _showList = true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        IntrinsicHeight(    
          child: Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: BookingForm(onComplete: _reloadList),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const BookingLookup(),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => setState(() => _showList = !_showList),
          child: Text(_showList ? 'Hide All Bookings' : 'Show All Bookings'),
        ),
        const SizedBox(height: 24),
        if (_showList)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: BookingList(onRefresh: _reloadList),
            ),
          ),
      ]),
    );
  }
}

