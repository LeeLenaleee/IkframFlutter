import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final Function setDate;
  final MainAxisAlignment mainAxisAlignment;

  DatePicker(this.setDate,
      {this.mainAxisAlignment = MainAxisAlignment.spaceBetween});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _selectedDate;

  Duration get _yearDuration => Duration(days: 365);

  void _openDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(_yearDuration),
      locale: const Locale('nl', 'NL'),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });

      widget.setDate(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        children: <Widget>[
          Text(
            _selectedDate == null
                ? 'Geen datum gekozen!'
                : 'Gekozen datum: ${DateFormat.yMMMd().format(_selectedDate)}',
          ),
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              'Selecteer datum',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _openDatePicker,
          )
        ],
      ),
    );
  }
}
