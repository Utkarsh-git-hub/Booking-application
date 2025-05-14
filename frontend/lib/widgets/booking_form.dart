import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../services/api_service.dart';

class BookingForm extends StatefulWidget {
  final VoidCallback onComplete;
  const BookingForm({required this.onComplete, Key? key}) : super(key: key);

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  String? _startDate;   
  String? _startTime;   
  String? _endDate;
  String? _endTime;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return setState(() => _error = 'Please fill all fields');
    }

    final start = DateTime.parse('${_startDate!}T${_startTime!}');
    final end   = DateTime.parse('${_endDate!}T${_endTime!}');

    if (!start.isBefore(end)) {
      return setState(() => _error = 'Start time of booking must be before the end time of booking');
    }

    try {
      await ApiService.createBooking(
        _userCtrl.text,
        start.toUtc().toIso8601String(),
        end.toUtc().toIso8601String(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successfully created')),
      );
      _formKey.currentState!.reset();       
      _userCtrl.clear();                   
      setState(() {
        _error = null;
        _startDate = _startTime = _endDate = _endTime = null;
      });
      widget.onComplete();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext c) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_error!, style: TextStyle(color: Colors.red)),
            ),

          TextFormField(
            controller: _userCtrl,
            decoration: InputDecoration(labelText: 'Booking Title'),
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: 16),

          Text('Start'),
          Row(children: [
            Expanded(
              child: DateTimePicker(
                key: ValueKey(_startDate),
                initialValue: _startDate,
                type: DateTimePickerType.date,
                dateMask: 'yyyy-MM-dd',
                decoration: InputDecoration(labelText: 'Date'),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                onChanged: (val) => _startDate = val,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: DateTimePicker(
                key: ValueKey(_startTime),
                initialValue: _startTime,
                type: DateTimePickerType.time,
                decoration: InputDecoration(labelText: 'Time'),
                onChanged: (val) => _startTime = val,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
            ),
          ]),
          SizedBox(height: 16),

          Text('End'),
          Row(children: [
            Expanded(
              child: DateTimePicker(
                key: ValueKey(_endDate),
                initialValue: _endDate,
                type: DateTimePickerType.date,
                dateMask: 'yyyy-MM-dd',
                decoration: InputDecoration(labelText: 'Date'),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                onChanged: (val) => _endDate = val,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: DateTimePicker(
                key: ValueKey(_endTime),
                initialValue: _endTime,
                type: DateTimePickerType.time,
                decoration: InputDecoration(labelText: 'Time'),
                onChanged: (val) => _endTime = val,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
            ),
          ]),
          SizedBox(height: 24),

          Center(
            child: ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
