import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/firebase/firestore.dart';
import 'package:studybuddyhub/screens/quiz_screen.dart';
import 'package:studybuddyhub/widgets/loading.dart';

class ExamPreviewScreen extends StatefulWidget {
  final int examIndex;
  final String examName;
  const ExamPreviewScreen(
      {required this.examIndex, required this.examName, Key? key})
      : super(key: key);

  @override
  State<ExamPreviewScreen> createState() => _ExamPreviewScreenState();
}

class _ExamPreviewScreenState extends State<ExamPreviewScreen> {
  bool loadingExamData = true;
  Map<String, dynamic> exam = {};

  @override
  void initState() {
    super.initState();
    getExamData();
  }

  Future<void> getExamData() async {
    print("Fetching Data Started");
    Map<String, dynamic> data = await FirestoreMethods().getProfileBio();
    List<dynamic> examList = data['examList'];
    setState(() {
      exam = examList[widget.examIndex];
      loadingExamData = false;
      print(exam);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorTwo,
      appBar: AppBar(
        backgroundColor: backgroundColorTwo,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
              child: Text(widget.examName),
            ),
            Container(
              child: FaIcon(FontAwesomeIcons.bookmark),
            ),
          ],
        ),
      ),
      body: !loadingExamData
          ? Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/study_welcome.png',
                                    width: 200,
                                    height: 200,
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Exam - ${widget.examIndex + 1}",
                                              style: fontStyle(
                                                25,
                                                Colors.black,
                                                FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                Text(
                                                  "4.7",
                                                  style: fontStyle(
                                                    15,
                                                    Colors.black,
                                                    FontWeight.w500,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: textColorTwo,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${(exam['examList'] as List).length} Questions",
                                                        style: fontStyle(
                                                          15,
                                                          Colors.black,
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "10 points for correct answer",
                                                        style: fontStyle(
                                                          13,
                                                          Colors.grey.shade500,
                                                          FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: textColorTwo,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${exam['duration']} Minutes",
                                                        style: fontStyle(
                                                          15,
                                                          Colors.black,
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Exam duration",
                                                        style: fontStyle(
                                                          13,
                                                          Colors.grey.shade500,
                                                          FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: textColorTwo,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.star,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Earn ${(exam['examList'] as List).length} Stars",
                                                        style: fontStyle(
                                                          15,
                                                          Colors.black,
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Answer all questions correctly",
                                                        style: fontStyle(
                                                          13,
                                                          Colors.grey.shade500,
                                                          FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Add here
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Please read the text below carefully to understand",
                                        style: fontStyle(
                                          15,
                                          Colors.black,
                                          FontWeight.normal,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "\u2022",
                                              style: fontStyle(
                                                15,
                                                Colors.black,
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "10 points are given for the correct answer, and no points are given for the wrong answer.",
                                                style: fontStyle(
                                                  15,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "\u2022",
                                              style: fontStyle(
                                                15,
                                                Colors.black,
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "Tap the options to select the correct answer.",
                                                style: fontStyle(
                                                  15,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "\u2022",
                                              style: fontStyle(
                                                15,
                                                Colors.black,
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "Tap the bookmark icon to save interesting questions.",
                                                style: fontStyle(
                                                  15,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "\u2022",
                                              style: fontStyle(
                                                15,
                                                Colors.black,
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                "If you are sure you want to complete all questions, click the submit button.",
                                                style: fontStyle(
                                                  15,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                ),
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () {
                        print("Start Test question");
                        showConfirmationPopup(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: textColorTwo,
                        fixedSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Text(
                        "Start Test",
                        style: fontStyle(
                          20,
                          Colors.white,
                          FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
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
              'Confirmation',
              style: fontStyle(25, textColorTwo, FontWeight.normal),
            ),
          ),
          content: Text(
            'Do you want to start the test?',
            style: fontStyle(15, Colors.black, FontWeight.normal),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'No',
                style: fontStyle(15, Colors.black, FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                print("Start Test");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuizScreen(quizIndex: widget.examIndex),
                  ),
                );
              },
              child: Text(
                'Yes',
                style: fontStyle(15, textColorTwo, FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
