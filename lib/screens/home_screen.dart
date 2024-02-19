import 'package:flutter/material.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/screens/chat_screen.dart';
import 'package:studybuddyhub/screens/exams_screen.dart';
import 'package:studybuddyhub/screens/profile_screen.dart';
import 'package:studybuddyhub/screens/search_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ChatScreen(),
    SearchScreen(),
    ExamScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "StudyBuddy",
                style: fontStyle(20, textColorTwo, FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Hub",
                style: fontStyle(20, Colors.black, FontWeight.bold),
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: _pages[_currentIndex],
      backgroundColor: backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedLabelStyle: TextStyle(color: textColorTwo),
        selectedItemColor: textColorTwo,
        unselectedItemColor: textColorThree,
        unselectedLabelStyle: TextStyle(color: textColorThree),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.comment), label: 'Chat'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.pencil), label: 'Exam'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user), label: 'Profile')
        ],
      ),
    );
  }
}
