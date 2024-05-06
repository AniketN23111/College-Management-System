import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instattendance/controller/attendance_controller.dart';
import 'package:instattendance/view/attendance_view/show_attendance.dart';
import 'package:instattendance/view/home_view/teacher_home_view/teacher_home.dart';
import 'package:instattendance/view/offline_attendace_notepad/page/notes_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigoAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Take Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.offline_bolt),
            label: 'Offline Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt),
            label: 'attendance record',
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
    );
  }

  final List<Widget> _pages = <Widget>[
    const TeacherHome(),
    NotesPage(),
    ShowAttendance()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
