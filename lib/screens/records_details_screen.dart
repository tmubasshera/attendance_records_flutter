import 'package:attendance_records_flutter/models/attendance_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RecordDetailsScreen extends StatelessWidget {
  final AttendanceRecord record;

  RecordDetailsScreen({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records Details'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${record.name}'),
            Text('Contact Number: ${record.contact}'),
            Text('Timestamp: ${record.timestamp.toString()}'),
          ],
        ),
      )
    );
  }
}