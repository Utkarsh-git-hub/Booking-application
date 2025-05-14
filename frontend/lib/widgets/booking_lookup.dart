import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../services/api_service.dart';

class BookingLookup extends StatefulWidget {
  const BookingLookup({Key? key}) : super(key: key);
  @override
  _BookingLookupState createState() => _BookingLookupState();
}

class _BookingLookupState extends State<BookingLookup> {
  final _idCtrl = TextEditingController();
  Booking? _result;
  String? _error;

  String _fmt(DateTime dt) => DateFormat.yMd().add_jm().format(dt.toLocal());

  Future<void> _lookup() async {
    setState(() {
      _result = null;
      _error = null;
    });
    try {
      final b = await ApiService.fetchBookingById(_idCtrl.text.trim());
      setState(() => _result = b);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lookup Booking by ID',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _idCtrl,
                decoration: InputDecoration(labelText: 'Booking ID'),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(onPressed: _lookup, child: Text('Fetch')),
          ],
        ),
        if (_error != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(_error!, style: TextStyle(color: Colors.red)),
          ),
        if (_result != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Card(
              child: ListTile(
                title: Text('User: ${_result!.bookingTitle}'),
                subtitle: Text(
                  'Start: ${_fmt(_result!.startTime)}\nEnd:   ${_fmt(_result!.endTime)}',
                ),
              ),
            ),
          ),
        Divider(thickness: 1, height: 32),
      ],
    );
  }
}
