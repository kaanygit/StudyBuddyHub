// import 'package:flutter/material.dart';
// import 'package:studybuddyhub/constants/fonts.dart';

// class LoadingScreen extends StatefulWidget {
//   const LoadingScreen({Key? key});

//   @override
//   State<LoadingScreen> createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat(reverse: true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               RotationTransition(
//                 turns:
//                     Tween(begin: 0.0, end: 1.0).animate(_animationController),
//                 child: Icon(
//                   Icons.adjust,
//                   size: 40,
//                   color: textColorFour,
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "Loading...",
//                 style: fontStyle(20, textColorFour, FontWeight.normal),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:studybuddyhub/constants/fonts.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorTwo,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Image.asset(
                "assets/images/loading.png",
                width: 200,
                height: 200,
              )),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Loading",
                          style:
                              fontStyle(20, textColorFour, FontWeight.normal),
                        ),
                        Opacity(
                          opacity: _animationController.value >= 0.0 &&
                                  _animationController.value < 0.33
                              ? 1.0
                              : 0.5,
                          child: Text(
                            '.',
                            style:
                                fontStyle(20, textColorFour, FontWeight.normal),
                          ),
                        ),
                        Opacity(
                          opacity: _animationController.value >= 0.33 &&
                                  _animationController.value < 0.66
                              ? 1.0
                              : 0.5,
                          child: Text(
                            '..',
                            style:
                                fontStyle(20, textColorFour, FontWeight.normal),
                          ),
                        ),
                        Opacity(
                          opacity:
                              _animationController.value >= 0.66 ? 1.0 : 0.5,
                          child: Text(
                            '...',
                            style:
                                fontStyle(20, textColorFour, FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
