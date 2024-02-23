import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/firebase/firestore.dart';
import 'package:studybuddyhub/screens/create_exam_screen.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late Map<dynamic, dynamic> examList = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExamList();
  }

  Future<void> getExamList() async {
    Map<String, dynamic> data = await FirestoreMethods().getProfileBio();
    setState(() {
      examList = data;
      print(examList['examList']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: examList.length != 0
            ? ListView.builder(
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
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         alignment: Alignment.center,
                      //         child:
                      //             Image.asset("assets/images/${exam['photo']}"),
                      //       ),
                      //       SizedBox(width: 20),
                      //       Expanded(
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.stretch,
                      //           children: [
                      //             Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Text(
                      //                   "${exam['isim']}",
                      //                   style: fontStyle(
                      //                       20, Colors.black, FontWeight.bold),
                      //                 ),
                      //                 IconButton(
                      //                   onPressed: () {
                      //                     print("Bu sınavı sil $index");
                      //                   },
                      //                   icon: FaIcon(FontAwesomeIcons.trashCan),
                      //                 ),
                      //               ],
                      //             ),
                      //             Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 Row(
                      //                   children: [
                      //                     Text("${exam['soruSayisi']}",
                      //                         style: fontStyle(15, textColorTwo,
                      //                             FontWeight.normal)),
                      //                     SizedBox(
                      //                       width: 5,
                      //                     ),
                      //                     Text("Question",
                      //                         style: fontStyle(
                      //                             15,
                      //                             Colors.grey.shade500,
                      //                             FontWeight.normal)),
                      //                   ],
                      //                 ),
                      //                 Row(
                      //                   children: [
                      //                     Text("${exam['sure']}",
                      //                         style: fontStyle(15, textColorTwo,
                      //                             FontWeight.normal)),
                      //                     SizedBox(
                      //                       width: 5,
                      //                     ),
                      //                     Text("Remaining",
                      //                         style: fontStyle(
                      //                             15,
                      //                             Colors.grey.shade500,
                      //                             FontWeight.normal)),
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //             SizedBox(height: 10),
                      //             // Expanded'ı buraya taşıyın
                      //             ElevatedButton(
                      //               onPressed: () {
                      //                 print(
                      //                     "Teste başlıyor ${index + 1} numaralı teste");
                      //               },
                      //               style: ElevatedButton.styleFrom(
                      //                   backgroundColor: textColorTwo,
                      //                   shape: RoundedRectangleBorder(
                      //                       borderRadius:
                      //                           BorderRadius.circular(12))),
                      //               child: Text(
                      //                 "Start Test",
                      //                 style: fontStyle(
                      //                     15, Colors.white, FontWeight.normal),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                    ),
                  );
                },
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("Resim"),
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              print("Yeni Exam Oluştur");
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          CreateExamScreen()));
                            },
                            child: Text(
                              "Create the Exam",
                              style: fontStyle(
                                  30, textColorTwo, FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
