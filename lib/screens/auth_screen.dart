import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/firebase/auth.dart';
import 'package:studybuddyhub/screens/home_screen.dart';
import 'package:studybuddyhub/screens/welcome_screen.dart';
import 'package:studybuddyhub/widgets/loading.dart';
import 'package:sign_button/sign_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late SharedPreferences prefs;
  bool isValueTrue = false;
  bool loadingState = false;
  bool _mounted = false;
  final AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mounted = true;
    initSharedPrefences();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> initSharedPrefences() async {
    prefs = await SharedPreferences.getInstance();

    bool storedValue = prefs.getBool('isValueTrue') ?? false;
    if (_mounted) {
      setState(() {
        isValueTrue = storedValue;
        loadingState = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadingState
        ? !isValueTrue
            ? WelcomeScreen()
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: backgroundColor,
                ),
                backgroundColor: backgroundColor,
                body: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "StudyBuddy",
                                style:
                                    fontStyle(25, textColor, FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Hub",
                                style: fontStyle(
                                    25, Colors.black, FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: SignInButton(
                            buttonType: ButtonType.google,
                            onPressed: () async {
                              print("Google ile giriş yap");
                              bool result =
                                  await _authMethods.signInWithGoogle();
                              if (result) {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            new HomeScreen()));
                              }
                            },
                          ),
                        ),
                        Container(
                          child: SignInButton(
                              buttonType: ButtonType.github,
                              onPressed: () {
                                print("Github ile giriş yap");
                              }),
                        ),
                        Container(
                          child: SignInButton(
                              buttonType: ButtonType.facebookDark,
                              onPressed: () {
                                print("Facebook ile giriş yap");
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              )
        : LoadingScreen();
  }
}
