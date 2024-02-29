import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/firebase/firestore.dart';
import 'package:studybuddyhub/widgets/loading.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int question_number = 0;
  bool loading_value = false;
  bool active_daily_goal = false;
  bool congratulations_value = false;
  late ConfettiController _controller;
  late Timer _timer;

  late int dailyGoal;
  late int completed_question_number;
  late double linearIndicatorValue;

  @override
  void initState() {
    super.initState();
    dailyGoalActive();
    _controller = ConfettiController(duration: Duration(seconds: 5));
    _timer = Timer.periodic(Duration(hours: 24), (timer) {
      resetDailyCounter();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _timer.cancel();
  }

  Future<void> resetDailyCounter() async {
    try {
      await FirestoreMethods().resetDailyData();
    } catch (e) {
      print("An error occurred while resetting data");
    }
  }

  Future<void> dailyGoalActive() async {
    try {
      Map<String, dynamic> user = await FirestoreMethods().getProfileBio();
      bool dailyGoalActive = user['daily_goal_active'] ?? false;
      setState(() {
        active_daily_goal = dailyGoalActive;
        dailyGoal = user['daily_goal'] ?? 0;
        completed_question_number = user['daily_counter'] ?? 0;
        linearIndicatorValue =
            completed_question_number.toDouble() / dailyGoal.toDouble();
        congratulations_value = linearIndicatorValue == 1;
        loading_value = true;
      });
    } catch (e) {
      print("An error occurred while fetching data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: loading_value
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: active_daily_goal
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            size: 100.0,
                            color: textColorTwo,
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Daily Goal: $dailyGoal Questions',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Daily Progress: $completed_question_number/$dailyGoal Questions',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 20.0),
                          LinearProgressIndicator(
                            value: linearIndicatorValue,
                            backgroundColor: Colors.grey[300],
                            valueColor:
                                AlwaysStoppedAnimation<Color>(textColorTwo),
                          ),
                          SizedBox(height: 20.0),
                          if (!congratulations_value)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        print("Adding Questions");
                                        showConfirmationPopup(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: textColorTwo,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12))),
                                      child: Text(
                                        "Add Questions",
                                        style: fontStyle(17, Colors.white,
                                            FontWeight.normal),
                                      )),
                                ),
                              ],
                            ),
                        ],
                      )
                    : Center(
                        child: Container(
                            child: TextButton(
                                onPressed: () {
                                  print("Create Daily Goal");
                                  showCreateDailyGoal(context);
                                },
                                child: Text(
                                  "Create Daily Goal",
                                  style: fontStyle(
                                      40, textColorTwo, FontWeight.normal),
                                )))),
              )
            : Center(child: LoadingScreen()));
  }

  Container confetti() {
    return Container(
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
        ],
      ),
    );
  }

  void showCreateDailyGoal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Daily Goal"),
          content: Row(
            children: [
              Text('$question_number'),
              SizedBox(width: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        question_number++;
                      });
                    },
                    child: Text("+"),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (question_number > 0) {
                          question_number--;
                        }
                      });
                    },
                    child: Text("-"),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  question_number = 0;
                });
              },
              child: Text(
                'Cancel',
                style: fontStyle(15, textColorTwo, FontWeight.bold),
              ),
            ),
            SizedBox(width: 20.0),
            Container(
              decoration: BoxDecoration(
                color: textColorTwo,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  FirestoreMethods().addToDailyData(question_number);
                  setState(() {
                    question_number = 0;
                  });
                },
                child: Text(
                  'Add',
                  style: fontStyle(15, Colors.white, FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Questions"),
          content: Row(
            children: [
              Text('$question_number'),
              SizedBox(width: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        question_number++;
                      });
                    },
                    child: Text("+"),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (question_number > 0) {
                          question_number--;
                        }
                      });
                    },
                    child: Text("-"),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  question_number = 0;
                });
              },
              child: Text(
                'Cancel',
                style: fontStyle(15, textColorTwo, FontWeight.bold),
              ),
            ),
            SizedBox(width: 20.0),
            Container(
              decoration: BoxDecoration(
                color: textColorTwo,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  FirestoreMethods().addToDailyQuestionData(question_number);
                  setState(() {
                    question_number = 0;
                  });
                },
                child: Text(
                  'Add',
                  style: fontStyle(15, Colors.white, FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
