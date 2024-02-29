import 'package:flutter/material.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/firebase/auth.dart';
import 'package:studybuddyhub/firebase/firestore.dart';
import 'package:studybuddyhub/screens/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  Map<String, dynamic> userProfile = {};
  bool loadingProfile = true;
  bool editingScreen = false;
  late TextEditingController nameController;
  late TextEditingController educationController;
  late TextEditingController addressController;
  late TextEditingController phoneNumberController;

  @override
  void initState() {
    super.initState();
    _initializeUserProfile();
    nameController = TextEditingController();
    educationController = TextEditingController();
    addressController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  Future<void> _initializeUserProfile() async {
    Map<String, dynamic> user = await _firestoreMethods.getProfileBio();
    setState(() {
      userProfile = user;
      loadingProfile = false;
      nameController.text = userProfile['displayName'] ?? '';
      educationController.text = userProfile['educationLevel'] ?? '';
      addressController.text = userProfile['address'] ?? '';
      phoneNumberController.text = userProfile['phoneNumber'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorTwo,
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
                            NetworkImage(userProfile['profilePhoto']),
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage("assets/images/placeholder.png"),
                      ),
                    ),
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
                        "Personal Information",
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
                        !editingScreen
                            ? Text(
                                !loadingProfile
                                    ? userProfile['displayName']
                                    : "Null",
                                style: fontStyle(
                                    17, Colors.black, FontWeight.bold),
                              )
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 90.0),
                                  child: TextField(
                                    controller: nameController,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
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
                        !editingScreen
                            ? Text(
                                !loadingProfile
                                    ? userProfile['educationLevel']
                                    : "Null",
                                style: fontStyle(
                                    17, Colors.black, FontWeight.bold),
                              )
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: TextField(
                                    controller: educationController,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
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
                        !editingScreen
                            ? Text(
                                !loadingProfile
                                    ? userProfile['address']
                                    : "Null",
                                style: fontStyle(
                                    17, Colors.black, FontWeight.bold),
                              )
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 75.0),
                                  child: TextField(
                                    controller: addressController,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
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
                        "Contact Information",
                        style: fontStyle(20, Colors.black, FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Phone",
                            style: fontStyle(
                                17, Colors.grey.shade800, FontWeight.normal)),
                        !editingScreen
                            ? Text(
                                !loadingProfile
                                    ? userProfile['phoneNumber']
                                    : "Null",
                                style: fontStyle(
                                    17, Colors.black, FontWeight.bold),
                              )
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: TextField(
                                    controller: phoneNumberController,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("E-Mail",
                            style: fontStyle(
                                17, Colors.grey.shade800, FontWeight.normal)),
                        Text(
                            !loadingProfile
                                ? /*userProfile['email']*/ "test@test.com"
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
                          if (editingScreen) {
                            _saveProfileChanges();
                          }
                          setState(() {
                            editingScreen = !editingScreen;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: textColorThree,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text(
                          editingScreen ? "Save" : "Edit",
                          style: fontStyle(17, Colors.white, FontWeight.normal),
                        )),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          print("Reset Daily Goal Data");
                          await FirestoreMethods().resetDailyCounterDataAll();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text(
                          "Reset Daily Goal",
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
                          print("Signing Out");
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          print("Deleting Account");
                          await FirestoreMethods().deleteAccount();
                          AuthMethods().signOut();
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new AuthScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: Text(
                          "Delete Account",
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

  void _saveProfileChanges() {
    FirestoreMethods().setEditProfileBio(
      addressController.text,
      nameController.text,
      educationController.text,
      phoneNumberController.text,
    );
    _initializeUserProfile(); // Reload updated data
  }
}
