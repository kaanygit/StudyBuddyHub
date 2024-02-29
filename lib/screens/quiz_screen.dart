import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/firebase/firestore.dart';
import 'package:studybuddyhub/services/gemini.dart';
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
    begin: Colors.grey.shade500,
    end: textColorTwo,
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

    animateController.forward();

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (durationInSeconds > 0) {
        setState(() {
          updateTimeString();
          durationInSeconds--;
        });

        animateController.forward();
      } else {
        timer.cancel();
        print("Time is up");
      }
    });
  }

  void updateTimeString() {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    timeString = '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> getExamData() async {
    print("Data Retrieval Started");
    Map<String, dynamic> data = await FirestoreMethods().getProfileBio();
    List<dynamic> examList = data['examList'];
    // getQuestionAnswerFuture(examList);

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

  // Future<void> getQuestionAnswerFuture(List<dynamic> exam) async {
  //   List<dynamic> questions = exam[0]['examList'];
  //   List<String> questionListFowardGemini = [];
  //   for (final question in questions) {
  //     questionListFowardGemini.add(question['question']);
  //   }

  //   List<String> responseAnswer =
  //       await Gemini().geminiQuestionAnswerPrompt(questionListFowardGemini);

  //   print(responseAnswer != [] ? responseAnswer : "Empty List Returned");
  // }

  BoxDecoration getDecorationForIndex(int index) {
    if (previousQuestion.contains(index)) {
      return BoxDecoration(
        color: textColorTwo,
        shape: BoxShape.circle,
      );
    } else if (activateQuestionIndex == index) {
      return BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      );
    } else if (postQuestion.contains(index)) {
      return BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      );
    } else {
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
                "Exam - ${widget.quizIndex + 1}",
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
                          value: 1 - animateController.value,
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
                                  "What is monitored using CloudWatch?",
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
                                        print("Answer Tapped");
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
                                              "Memory usage of S3 bucket.",
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
                                        print("Answer Tapped");
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
                                              "Trigger event when CPU usage increases by x%.",
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
                                        print("Answer Tapped");
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
                                              "Unauthorized access of examples.",
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
                                        print("Answer Tapped");
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
                                              "User Interface and User Experience.",
                                              style: fontStyle(15, Colors.black,
                                                  FontWeight.normal),
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
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
                                activateQuestionIndex++;
                                previousQuestion.add(activateQuestionIndex - 1);
                                postQuestion.remove(activateQuestionIndex - 1);
                                if (activateQuestionIndex >= 9) {
                                  print("Confirmation Screen");
                                  showConfirmationPopup(context);
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
            'Are you sure? Do you want to submit?',
            style: fontStyle(25, Colors.black, FontWeight.normal),
          )),
          content: Text(
              'Your time is running out. You cannot change any answers. You should submit the exam now, or the system will automatically submit your answers in 10 seconds and show your score.',
              style: fontStyle(13, Colors.grey.shade800, FontWeight.normal)),
          actions: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                        print(
                          "Return to the test page",
                        );
                      },
                      child: Text('Confirm Submission',
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
    timer.cancel();
    animateController.dispose();
    super.dispose();
  }
}
