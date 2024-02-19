import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studybuddyhub/constants/fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatTextBoxController = TextEditingController();
  final gemini = Gemini.instance;

  bool isGeminiVisiable = true;
  String? currentUserPhoto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          if (isGeminiVisiable)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 50,
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
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Row(
                          children: [
                            Container(
                                child: currentUserPhoto != null
                                    ? Image.network("$currentUserPhoto",
                                        width: 50, height: 50)
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey,
                                      )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                "Got my createive ideas for a 10 year old's birtday",
                                style: fontStyle(
                                    14, Colors.black, FontWeight.normal),
                              ),
                            )
                          ],
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: Row(
                          children: [
                            Container(
                                child: Image.asset(
                                    "assets/images/gemini_logo.png",
                                    width: 50,
                                    height: 50)),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                'Bu hatayı çözmek için, currentUserPhoto değişkenini late olarak tanımlamak yerine, null olarak başlatıp ardından kullanıcı bilgisi gelirse güncellemek daha iyi bir yol olabilir. Aşağıda bu yaklaşımı kullanarak bir örnek görebilirsiniz:',
                                style: fontStyle(
                                    14, Colors.black, FontWeight.normal),
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(30), // Yuvarlak kenarlıklar
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  borderSide: BorderSide
                                      .none, // Border'ın kenarlığını kaldırma
                                ),
                              ),
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
                              onTap: () {
                                print("Gönder");

                                setState(() {
                                  if (_chatTextBoxController.text != "") {
                                    isGeminiVisiable = false;
                                    print(_chatTextBoxController.text);
                                    gemini
                                        .text(_chatTextBoxController.text)
                                        .then((value) => print(value?.output))
                                        .catchError((error) => print(
                                            "Gönderilirken bir hata oluştu : $error"));
                                  }
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
