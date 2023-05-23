import 'package:attendance_records_flutter/models/attendance_record.dart';
import 'package:attendance_records_flutter/screens/checkin_screen.dart';
import 'package:attendance_records_flutter/screens/records_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<AttendanceRecord> attendanceRecordsList = [];
  List<AttendanceRecord> filteredRecords = [];
  bool isToggleOn = false;

  void toggleTimeFormat() {
    setState(() {
      isToggleOn = !isToggleOn;
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

  void searchRecords(String keyword){
    setState(() {
      filteredRecords = attendanceRecordsList.where((record) {
        return record.name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    attendanceRecordsList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text('Attendance Records'),
        actions: [
          IconButton(
            onPressed: () async{
              final String? result = await showSearch(
              context: context,
              delegate: RecordSearchDelegate(searchRecords),
              );

              if (result!=null)
                searchRecords(result);
              
            }, 
            icon: Icon(Icons.search))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: openCheckInScreen,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Check In", style: TextStyle(fontSize: 12),),
          
        ),
      ),
      body: ListView.builder(
        itemCount: attendanceRecordsList.length,
        itemBuilder: (context, index) 
        {
          final AttendanceRecord record = attendanceRecordsList[index];
          final String formattedTimestamp = isToggleOn? 
          DateFormat('dd MMM yyyy, h:mm a').format(record.timestamp)
              : timeAgoSinceDate(record.timestamp);

              return ListTile(
                title: Text(record.name, style: TextStyle(color: Colors.white),),
                subtitle: Text(formattedTimestamp),
                trailing: Text(record.contact),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordDetailsScreen(record: record),));
                },
              );              
        }),
        bottomNavigationBar: BottomAppBar(child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Display Time Format: '),
            TimeFormatToggle(
            isToggleOn: isToggleOn,
            toggleTimeFormat: toggleTimeFormat,
          ),
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

class RecordSearchDelegate extends SearchDelegate<String> {
  final Function(String) searchMethod;

  RecordSearchDelegate(this.searchMethod);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchMethod('');
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    searchMethod(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        //
      },
    );
  }
}

class TimeFormatToggle extends StatelessWidget {
  final bool isToggleOn;
  final VoidCallback toggleTimeFormat;

  const TimeFormatToggle({
    required this.isToggleOn,
    required this.toggleTimeFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isToggleOn,
      onChanged: (value) => toggleTimeFormat(),
    );
  }
}