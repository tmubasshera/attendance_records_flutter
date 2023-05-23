import 'package:attendance_records_flutter/models/attendance_record.dart';
import 'package:attendance_records_flutter/screens/checkin_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<AttendanceRecord> attendanceRecordsList = [];

  bool toggle = false;

  void toggleTimeFormat() {
    setState(() {
      toggle = !toggle;
    });
  }

  void openCheckInScreen() async {
    final AttendanceRecord? record =
        await showModalBottomSheet<AttendanceRecord>(
            context: context,
            builder: (BuildContext context) => CheckInSheet());

    if (record != null) {
      setState(() {
        attendanceRecordsList.add(record);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text('Attendance Records'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openCheckInScreen,
        child: Text("Check In"),
      ),
      body: ListView.builder(
        itemCount: attendanceRecordsList.length,
        itemBuilder: (context, index) 
        {
          final AttendanceRecord record = attendanceRecordsList[index];
          final String formattedTimestamp = toggle? 
          DateFormat('dd MMM yyyy, h:mm a').format(record.timestamp)
              : timeAgoSinceDate(record.timestamp);

              return ListTile(
                title: Text(record.name),
                subtitle: Text(formattedTimestamp),
                trailing: Text(record.contact),
              );              
        }),
        bottomNavigationBar: BottomAppBar(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Display Time Format: '),
            Switch(value: toggle
            , onChanged: (value)=>toggleTimeFormat())
          ]),)
    );
  }
  
  timeAgoSinceDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 30) {
      return DateFormat('dd MMM yyyy, h:mm a').format(dateTime);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
