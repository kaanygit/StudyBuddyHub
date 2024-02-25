// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:studybuddyhub/constants/fonts.dart';
// import 'package:studybuddyhub/firebase/firestore.dart';
// import 'package:studybuddyhub/widgets/loading.dart';

// class QuizScreen extends StatefulWidget {
//   final int quizIndex;
//   const QuizScreen({required this.quizIndex, Key? key}) : super(key: key);

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen>
//     with SingleTickerProviderStateMixin {
//   bool loadingExamData = true;
//   Map<String, dynamic> exam = {};
//   int durationInSeconds = 0;

//   ColorTween colorTween = ColorTween(
//     begin: Colors.grey.shade500, // Başlangıç rengi (örneğin mor)
//     end: textColorTwo, // Bitiş rengi (örneğin gri)
//   );
//   int remainingSeconds = 0;
//   late AnimationController animateController;
//   late Animation<Color?> colorAnimation;

//   bool isButtonDisabled = false;
//   int activateQuestionIndex = 0;
//   List<int> previousQuestion = [];
//   List<int> postQuestion = [];
//   List<int> activateQuestionIndexList = [0];
//   int quizDuration = 0;
//   late Timer timer;
//   String timeString = "";

//   @override
//   void initState() {
//     super.initState();
//     getExamData();
//     animateController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: durationInSeconds),
//     );
//     colorAnimation = colorTween.animate(animateController);
//     colorAnimation.addListener(() {
//       setState(() {});
//     });
//     animateController.addListener(() {
//       setState(() {
//         remainingSeconds = durationInSeconds - animateController.value.toInt();
//       });
//     });

//     // Forward ile animasyon başlatılır

//     // Timer'ı başlat
//     startTimer();
//   }

//   void startTimer() {
//     timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (durationInSeconds > 0) {
//         setState(() {
//           updateTimeString();
//           durationInSeconds--;
//         });

//         // Zamanı güncelledikten sonra animasyonu ileriye doğru çalıştır
//         animateController.forward();
//       } else {
//         timer.cancel();
//         print("Süre Doldu");
//       }
//     });
//   }

//   void updateTimeString() {
//     int minutes = durationInSeconds ~/ 60;
//     int seconds = durationInSeconds % 60;
//     timeString = '$minutes:${seconds.toString().padLeft(2, '0')}';
//   }

//   Future<void> getExamData() async {
//     print("Veri Getirme Başladı");
//     Map<String, dynamic> data = await FirestoreMethods().getProfileBio();
//     List<dynamic> examList = data['examList'];

//     setState(() {
//       exam = examList[widget.quizIndex];
//       quizDuration = exam['duration'] * 60;
//       remainingSeconds = 1 * 60;
//       durationInSeconds = 1 * 60;
//       print(quizDuration);
//       postQuestion =
//           List.generate((exam['examList'] as List).length, (index) => index);
//       postQuestion.remove(0);
//       loadingExamData = false;
//     });
//   }

//   BoxDecoration getDecorationForIndex(int index) {
//     if (previousQuestion.contains(index)) {
//       return BoxDecoration(
//         color: textColorTwo, // Önceki soru rengi
//         shape: BoxShape.circle,
//       );
//     } else if (activateQuestionIndex == index) {
//       return BoxDecoration(
//         color: Colors.black, // Aktif soru rengi
//         shape: BoxShape.circle,
//       );
//     } else if (postQuestion.contains(index)) {
//       return BoxDecoration(
//         color: Colors.grey, // Sonraki soru rengi
//         shape: BoxShape.circle,
//       );
//     } else {
//       // Default renk
//       return BoxDecoration(
//         color: Colors.grey,
//         shape: BoxShape.circle,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColorTwo,
//       appBar: AppBar(
//         backgroundColor: backgroundColorTwo,
//         leading: GestureDetector(
//           onTap: () {
//             showConfirmationPopup(context);
//           },
//           child: Container(
//             child: Icon(
//               Icons.arrow_back_ios,
//               color: textColorTwo,
//             ),
//           ),
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               child: Text("Exam - 1"),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10), color: Colors.black),
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//               child: Row(
//                 children: [
//                   FaIcon(
//                     FontAwesomeIcons.clock,
//                     color: Colors.white,
//                     size: 15,
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   Text(
//                     "${timeString}",
//                     style: fontStyle(15, Colors.white, FontWeight.normal),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: !loadingExamData
//           ? Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: Column(
//                       children: [
//                         SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: List.generate(
//                                 (exam['examList'] as List).length,
//                                 (index) => Container(
//                                   child: Container(
//                                       padding: EdgeInsets.all(15),
//                                       margin: EdgeInsets.all(5),
//                                       decoration: getDecorationForIndex(index),
//                                       child: Text(
//                                         "${index + 1}",
//                                         style: fontStyle(20, Colors.white,
//                                             FontWeight.normal),
//                                       )),
//                                 ),
//                               ),
//                             )),
//                         // SlideTransition(
//                         //   position: Tween<Offset>(
//                         //           begin: Offset(1, 0), end: Offset.zero)
//                         //       .animate(animateController),
//                         //   child: Container(
//                         //     width: double.infinity,
//                         //     height: 50,
//                         //     alignment: Alignment.center,
//                         //     color: textColorTwo,
//                         //   ),
//                         // ),

//                         SlideTransition(
//                           position: Tween<Offset>(
//                                   begin: Offset(1, 0), end: Offset.zero)
//                               .animate(animateController),
//                           child: Container(
//                             width: double.infinity,
//                             height: 50,
//                             alignment: Alignment.center,
//                             color: colorAnimation
//                                 .value, // Renk geçişini buradan al
//                             child: Text(
//                               "Your Text", // Kutu içinde görünen metin
//                               style: TextStyle(
//                                 color: Colors.white, // Metin rengi
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),

//                         Container(child: Text("Soru adgasgasgasg ")),
//                       ],
//                     )),
//                 Container(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: textColorTwo,
//                           fixedSize: Size(200, 50),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(0))),
//                       onPressed: !isButtonDisabled
//                           ? () {
//                               setState(() {
//                                 activateQuestionIndex++; // Soru indexini bir artır
//                                 previousQuestion.add(activateQuestionIndex -
//                                     1); // Önceki sorular listesine ekle
//                                 postQuestion.remove(activateQuestionIndex - 1);
//                                 if (activateQuestionIndex >= 9) {
//                                   print("Sınav Onaylama Ekranı");
//                                   isButtonDisabled = true;
//                                 }
//                               });
//                             }
//                           : null,
//                       child: Text(
//                         "Next",
//                         style: fontStyle(20, Colors.white, FontWeight.normal),
//                       )),
//                 )
//               ],
//             )
//           : Center(child: LoadingScreen()),
//     );
//   }

//   void showConfirmationPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Container(
//               child: Text(
//             'Confirmation',
//             style: fontStyle(25, textColorTwo, FontWeight.normal),
//           )),
//           content: Text('Testi bitirmek?',
//               style: fontStyle(15, Colors.black, FontWeight.normal)),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Dialog'u kapat
//               },
//               child: Text(
//                 'Hayır',
//                 style: fontStyle(15, Colors.black, FontWeight.bold),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Dialog'u kapat
//                 Navigator.pop(context);
//                 print(
//                   "test sayfasına dönüş",
//                 );
//               },
//               child: Text('Evet',
//                   style: fontStyle(15, textColorTwo, FontWeight.bold)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     // Timer ve controller'ı dispose et
//     timer.cancel();
//     animateController.dispose();
//     super.dispose();
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/firebase/firestore.dart';
import 'package:studybuddyhub/widgets/loading.dart';

class QuizScreen extends StatelessWidget {
  final int quizIndex;

  const QuizScreen({required this.quizIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuizScreenStateful(quizIndex: quizIndex);
  }
}

class QuizScreenStateful extends StatefulWidget {
  final int quizIndex;

  const QuizScreenStateful({required this.quizIndex, Key? key})
      : super(key: key);

  @override
  State<QuizScreenStateful> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreenStateful>
    with SingleTickerProviderStateMixin {
  bool loadingExamData = true;
  Map<String, dynamic> exam = {};
  int durationInSeconds = 0;

  ColorTween colorTween = ColorTween(
    begin: Colors.grey.shade500, // Başlangıç rengi (örneğin mor)
    end: textColorTwo, // Bitiş rengi (örneğin gri)
  );
  int remainingSeconds = 0;
  late AnimationController animateController;
  late Animation<Color?> colorAnimation;

  bool isButtonDisabled = false;
  int activateQuestionIndex = 0;
  List<int> previousQuestion = [];
  List<int> postQuestion = [];
  int quizDuration = 0;
  late Timer timer;
  String timeString = "";

  @override
  void initState() {
    super.initState();
    getExamData();
    animateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationInSeconds),
    );
    colorAnimation = colorTween.animate(animateController);
    colorAnimation.addListener(() {
      setState(() {});
    });
    animateController.addListener(() {
      setState(() {
        remainingSeconds = durationInSeconds - animateController.value.toInt();
      });
    });

    // Forward ile animasyon başlatılır
    animateController.forward();

    // Timer'ı başlat
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (durationInSeconds > 0) {
        setState(() {
          updateTimeString();
          durationInSeconds--;
        });

        // Zamanı güncelledikten sonra animasyonu ileriye doğru çalıştır
        animateController.forward();
      } else {
        timer.cancel();
        print("Süre Doldu");
      }
    });
  }

  void updateTimeString() {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    timeString = '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> getExamData() async {
    print("Veri Getirme Başladı");
    Map<String, dynamic> data = await FirestoreMethods().getProfileBio();
    List<dynamic> examList = data['examList'];

    setState(() {
      exam = examList[widget.quizIndex];
      quizDuration = exam['duration'] * 60;
      remainingSeconds = exam['duration'] * 60;
      durationInSeconds = exam['duration'] * 60;
      postQuestion =
          List.generate((exam['examList'] as List).length, (index) => index);
      postQuestion.remove(0);
      loadingExamData = false;
    });
  }

  BoxDecoration getDecorationForIndex(int index) {
    if (previousQuestion.contains(index)) {
      return BoxDecoration(
        color: textColorTwo, // Önceki soru rengi
        shape: BoxShape.circle,
      );
    } else if (activateQuestionIndex == index) {
      return BoxDecoration(
        color: Colors.black, // Aktif soru rengi
        shape: BoxShape.circle,
      );
    } else if (postQuestion.contains(index)) {
      return BoxDecoration(
        color: Colors.grey, // Sonraki soru rengi
        shape: BoxShape.circle,
      );
    } else {
      // Default renk
      return BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorTwo,
      appBar: AppBar(
        backgroundColor: backgroundColorTwo,
        leading: GestureDetector(
          onTap: () {
            showConfirmationPopup(context);
          },
          child: Container(
            child: Icon(
              Icons.arrow_back_ios,
              color: textColorTwo,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                "Exam - 1",
                style: fontStyle(20, Colors.black, FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.clock,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${timeString}",
                    style: fontStyle(15, Colors.white, FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: !loadingExamData
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                (exam['examList'] as List).length,
                                (index) => Container(
                                  child: Container(
                                      padding: EdgeInsets.all(15),
                                      margin: EdgeInsets.all(5),
                                      decoration: getDecorationForIndex(index),
                                      child: Text(
                                        "${index + 1}",
                                        style: fontStyle(20, Colors.white,
                                            FontWeight.normal),
                                      )),
                                ),
                              ),
                            )),
                        LinearProgressIndicator(
                          value: 1 -
                              animateController.value, // Geriye doğru animasyon
                          valueColor:
                              AlwaysStoppedAnimation(colorAnimation.value),
                        ),
                        Container(
                          width: double.infinity,
                          height: 5,
                          alignment: Alignment.center,
                          color: colorAnimation.value,
                        ),
                        Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    child: Text(
                                  "CloudWatch use to monitor ?",
                                  style: fontStyle(
                                      20, Colors.black, FontWeight.bold),
                                  textAlign: TextAlign.start,
                                )),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print("Soru Cevabı işaretlendi");
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey.shade500,
                                                width: 0.5)),
                                        child: Row(children: [
                                          Text(
                                            "a.",
                                            style: fontStyle(
                                                15,
                                                Colors.grey.shade500,
                                                FontWeight.normal),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Memory utilization of the s3 bucket.",
                                              style: fontStyle(15, Colors.black,
                                                  FontWeight.normal),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print("Soru Cevabı işaretlendi");
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey.shade500,
                                                width: 0.5)),
                                        child: Row(children: [
                                          Text(
                                            "b.",
                                            style: fontStyle(
                                                15,
                                                Colors.grey.shade500,
                                                FontWeight.normal),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Trigger the event after cpu utilization increase by x%.",
                                              style: fontStyle(15, Colors.black,
                                                  FontWeight.normal),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print("Soru Cevabı işaretlendi");
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey.shade500,
                                                width: 0.5)),
                                        child: Row(children: [
                                          Text(
                                            "c.",
                                            style: fontStyle(
                                                15,
                                                Colors.grey.shade500,
                                                FontWeight.normal),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Unauthorized access to the instances..",
                                              style: fontStyle(15, Colors.black,
                                                  FontWeight.normal),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print("Soru Cevabı işaretlendi");
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey.shade500,
                                                width: 0.5)),
                                        child: Row(children: [
                                          Text(
                                            "d.",
                                            style: fontStyle(
                                                15,
                                                Colors.grey.shade500,
                                                FontWeight.normal),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Interface and Using Experience..",
                                              style: fontStyle(15, Colors.black,
                                                  FontWeight.normal),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),

                                    //CEVAPLARRR
                                  ],
                                )
                              ],
                            )),
                      ],
                    )),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: textColorTwo,
                          fixedSize: Size(200, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      onPressed: !isButtonDisabled
                          ? () {
                              setState(() {
                                activateQuestionIndex++; // Soru indexini bir artır
                                previousQuestion.add(activateQuestionIndex -
                                    1); // Önceki sorular listesine ekle
                                postQuestion.remove(activateQuestionIndex - 1);
                                if (activateQuestionIndex >= 9) {
                                  print("Sınav Onaylama Ekranı");
                                  isButtonDisabled = true;
                                }
                              });
                            }
                          : null,
                      child: Text(
                        "Next",
                        style: fontStyle(20, Colors.white, FontWeight.normal),
                      )),
                )
              ],
            )
          : Center(child: LoadingScreen()),
    );
  }

  void showConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
              child: Text(
            'Are you sure you want to Submit?',
            style: fontStyle(25, Colors.black, FontWeight.normal),
          )),
          content: Text(
              'You are running out of time.  You can’t modify any questions. You must submit the exam now or system will automatically submit your answers in 10 second and shows score.',
              style: fontStyle(13, Colors.grey.shade800, FontWeight.normal)),
          actions: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Dialog'u kapat
                      },
                      child: Text(
                        'Continue Test',
                        style: fontStyle(15, textColorTwo, FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: textColorTwo,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Dialog'u kapat
                        Navigator.pop(context);
                        print(
                          "test sayfasına dönüş",
                        );
                      },
                      child: Text('Confirm Submit',
                          style: fontStyle(15, Colors.white, FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Timer ve controller'ı dispose et
    timer.cancel();
    animateController.dispose();
    super.dispose();
  }
}
