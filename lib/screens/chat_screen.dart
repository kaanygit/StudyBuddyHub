import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/firebase/firestore.dart';
import 'package:studybuddyhub/services/gemini.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatTextBoxController = TextEditingController();
  bool _isLoadingGeminiChat = false;
  final Gemini _gemini = Gemini();
  List<String> _responseGemini = [];
  List<String> _responseUser = [];
  List<String> _allResponse = [];
  String? _returnResponse = "";
  String? _sendResponse = "";
  bool isGeminiVisible = true;
  String? currentUserPhoto;

  Map<String, dynamic> userProfile = {};

  @override
  void initState() {
    super.initState();
    _initializeUserProfile();
    _responseUser = [];
    _responseGemini = [];
    _allResponse = [];
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("Kullanıcı bulunamadı");
      } else {
        setState(() {
          currentUserPhoto = user.photoURL ?? '';
          print(currentUserPhoto);
        });
      }
    });
  }

  Future<void> _initializeUserProfile() async {
    userProfile = await FirestoreMethods().getProfileBio();
    print(userProfile);

    _responseUser = [];

    // State değişikliklerini tetikle
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          if (isGeminiVisible)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 150,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      'Powered by',
                      style: fontStyle(
                          15, Colors.blue.shade400, FontWeight.normal),
                    ),
                    Image.asset(
                      'assets/images/gemini_logo.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _allResponse.length; i++)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  children: [
                                    Container(
                                      child: i % 2 == 0
                                          ? currentUserPhoto != null
                                              ? ClipOval(
                                                  child: Image.network(
                                                    "$currentUserPhoto",
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                )
                                              : Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.grey,
                                                )
                                          : ClipOval(
                                              child: Image.asset(
                                                "assets/images/gemini_logo.png",
                                                width: 50,
                                                height: 50,
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        _responseUser[i],
                                        style: fontStyle(
                                          14,
                                          Colors.black,
                                          FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              // Alt kısım (Input ve diğer widget'lar)
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatTextBoxController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: "Message",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            enabled: !_isLoadingGeminiChat,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: textColorTwo,
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                _isLoadingGeminiChat = true;
                                _sendResponse =
                                    _chatTextBoxController.text.trim();
                                _responseUser.add(_sendResponse!);
                                _allResponse.add(_sendResponse!);
                                isGeminiVisible = false;
                              });

                              final String text =
                                  _chatTextBoxController.text.trim();
                              _returnResponse =
                                  await _gemini.geminiTextPrompt(text);
                              _responseGemini.add(_returnResponse!);

                              setState(() {
                                _isLoadingGeminiChat = false;
                                _responseUser.add(_returnResponse!);
                                _allResponse.add(_returnResponse!);
                                _chatTextBoxController.clear();
                                _chatTextBoxController.text = "";
                                FirestoreMethods().setGeminiChat(_allResponse);
                                _chatTextBoxController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(offset: 0),
                                );
                              });
                            },
                            child: FaIcon(
                              FontAwesomeIcons.arrowUp,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
