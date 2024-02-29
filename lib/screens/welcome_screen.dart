import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/screens/auth_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> titleList = [
    'Welcome',
    'About',
    'About',
    'Content consent and user agreement',
    'Congratulations!'
  ];
  final List<String> contentList = [
    'Mock University is a one-stop platform where users can attend different mock exams with the ease of our mobile and web app. This not only provides the mock exams but also gives users a better understanding of the topics.',
    'All mock exams contain detailed explanations for each question. You will have the opportunity to view details. You can open tests in Learning mode or Exam mode.',
    'Learning mode is not time-limited, and you can view answers immediately and review topics. You can only review topics and correct answers after the submission of the test.',
    'The content of all courses is prepared to give the best experience and knowledge on each topic. We do not guarantee that the course content is up to date, but we are working continuously to improve the course content.',
    'You have reached the end of our introduction. We are excited to enroll you in our online Mock University. Thank you for choosing us and “Happy Mocking”!'
  ];

  final List<String> imageList = [
    'study_welcome.png',
    'time.png',
    'time.png',
    'handshake.png',
    'congratulations.png'
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  Future<void> setTrue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isValueTrue', true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: PageView.builder(
        controller: _pageController,
        itemCount: titleList.length,
        itemBuilder: (context, index) {
          return buildWelcomeScreen(index);
        },
      ),
    );
  }

  Widget buildWelcomeScreen(int index) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Text(
                  titleList[index],
                  style: fontStyle(35, Colors.black, FontWeight.w600),
                ),
              ),
            ),
            Container(
              child: Image.asset(
                'assets/images/${imageList[index] as String}',
                width: 300,
                height: 300,
              ),
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(15.0),
              child: Text(
                contentList[index],
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: textColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onPressed: () {
                  if (index < titleList.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    // Navigate to AuthScreen and set true in SharedPreferences
                    setTrue().then((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                      );
                    });
                    print("Last Screen");
                  }
                },
                child: Text(
                  index == titleList.length - 1 ? 'Finish' : 'Continue',
                  style: fontStyle(30, Colors.white, FontWeight.normal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
