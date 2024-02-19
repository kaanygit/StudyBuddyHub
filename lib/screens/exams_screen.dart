import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studybuddyhub/constants/fonts.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final List<Map<String, dynamic>> examList = [
    {'photo': 'test.png', 'soruSayisi': '10', 'isim': 'Biyoloji', 'sure': '60'},
    {
      'photo': 'test.png',
      'soruSayisi': '15',
      'isim': 'Matematik',
      'sure': '45'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView.builder(
        itemCount: examList.length,
        itemBuilder: (context, index) {
          var exam = examList[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/${exam['photo']}"),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${exam['isim']}",
                              style:
                                  fontStyle(20, Colors.black, FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                print("Bu sınavı sil $index");
                              },
                              icon: FaIcon(FontAwesomeIcons.trashCan),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("${exam['soruSayisi']}",
                                    style: fontStyle(
                                        15, textColorTwo, FontWeight.normal)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Question",
                                    style: fontStyle(15, Colors.grey.shade500,
                                        FontWeight.normal)),
                              ],
                            ),
                            Row(
                              children: [
                                Text("${exam['sure']}",
                                    style: fontStyle(
                                        15, textColorTwo, FontWeight.normal)),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Remaining",
                                    style: fontStyle(15, Colors.grey.shade500,
                                        FontWeight.normal)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Expanded'ı buraya taşıyın
                        ElevatedButton(
                          onPressed: () {
                            print("Teste başlıyor ${index + 1} numaralı teste");
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: textColorTwo,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: Text(
                            "Start Test",
                            style:
                                fontStyle(15, Colors.white, FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
