import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/firebase/auth.dart';
import 'package:studybuddyhub/screens/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> _currentUserProfile = {
    'userPhoto': '',
    'userName': '',
    'userEducationLevel': '',
    'userTelephoneNumber': '',
    'userEmail': ''
  };
  bool loadingProfile = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("Kullanıcı bulunamadı");
      } else {
        setState(() {
          _currentUserProfile['userPhoto'] = user.photoURL ?? '';
          _currentUserProfile['userName'] = user.displayName ?? '';
          _currentUserProfile['userEmail'] = user.email ?? '';
          _currentUserProfile['userTelephoneNumber'] = user.phoneNumber ?? '';
          loadingProfile = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !loadingProfile
                  ? Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(_currentUserProfile['userPhoto']),
                      ))
                  : Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage("assets/images/placeholder.png"),
                      )),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Personal Info",
                        style: fontStyle(20, Colors.black, FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Name",
                            style: fontStyle(
                                17, Colors.grey.shade800, FontWeight.normal)),
                        Text(
                          !loadingProfile
                              ? _currentUserProfile['userName']
                              : "Null",
                          style: fontStyle(17, Colors.black, FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Education Level",
                            style: fontStyle(
                                17, Colors.grey.shade800, FontWeight.normal)),
                        Text("Null",
                            style:
                                fontStyle(17, Colors.black, FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Address",
                          style: fontStyle(
                              17, Colors.grey.shade800, FontWeight.normal),
                        ),
                        Text("Null",
                            style:
                                fontStyle(17, Colors.black, FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Contact Info",
                        style: fontStyle(20, Colors.black, FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Phone Number",
                            style: fontStyle(
                                17, Colors.grey.shade800, FontWeight.normal)),
                        Text(
                          _currentUserProfile['userTelephoneNumber'] == ""
                              ? "Null"
                              : _currentUserProfile['userTelephoneNumber'],
                          style: fontStyle(17, Colors.black, FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Email",
                            style: fontStyle(
                                17, Colors.grey.shade800, FontWeight.normal)),
                        Text(
                            !loadingProfile
                                ? _currentUserProfile['userEmail']
                                : "Null",
                            style:
                                fontStyle(17, Colors.black, FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          print("Edit Personal Data");
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: textColorThree,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text(
                          "Edit",
                          style: fontStyle(17, Colors.white, FontWeight.normal),
                        )),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          print("Sign Out yapılıyor");
                          AuthMethods().signOut();
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new AuthScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: textColorTwo,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text(
                          "Sign Out",
                          style: fontStyle(17, Colors.white, FontWeight.normal),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
