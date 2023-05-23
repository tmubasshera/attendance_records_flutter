import 'package:attendance_records_flutter/models/attendance_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CheckInSheet extends StatelessWidget {
  //const CheckInSheet({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  String? validateContactNumber(String value) {
    if (value.isEmpty) {
      return 'Contact number is required';
    } else if (value.length != 11) {
      return 'Contact number should be 11 digits';
    }
    return null;
  }

  void submitForm(BuildContext context) {
    // Validate the contact number
    String? contactNumberError = validateContactNumber(contactNumberController.text);
    if (contactNumberError != null) {
      // Show an error message if the contact number is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(contactNumberError)),
      );
      return;
    }}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Your Name'),
        ),
        TextField(
          controller: contactNumberController,
          decoration: InputDecoration(labelText: 'Contact Number'),
        ),
        ElevatedButton(
            onPressed: () {
              submitForm(context);
              final AttendanceRecord record = AttendanceRecord(
                name: nameController.text,
                contact: contactNumberController.text,
                timestamp: DateTime.now(),
              );
              Navigator.pop(context, record);
            },
            child: Text("Check in"))
      ]),
    );
  }
}
