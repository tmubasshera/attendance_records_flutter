import 'package:attendance_records_flutter/screens/attendance_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Records',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    home: AttendanceScreen(),
    );
  }
}

