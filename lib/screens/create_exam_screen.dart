import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studybuddyhub/constants/fonts.dart';
import 'package:studybuddyhub/services/ocr.dart';
import 'package:studybuddyhub/widgets/loading.dart';

class CreateExamScreen extends StatefulWidget {
  const CreateExamScreen({super.key});

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends State<CreateExamScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool loading = false;
  bool _imageSelected = false;
  late File _image;
  final picker = ImagePicker();
  final OCR ocr = OCR();
  late String imageToText = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageSelected = true;
        loading = true;
        _navigateToNextPage();
      });

      try {
        String text = await ocr.getImageToText(pickedFile.path);
        _navigateToNextPage();

        setState(() {
          imageToText = text;
        });

        print(text);
      } catch (e) {
        print("Error getting image text: $e");
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageSelected = true;
        loading = true;
        _navigateToNextPage();
      });

      try {
        String text = await ocr.getImageToText(pickedFile.path);

        setState(() {
          loading = false;
        });
        _navigateToNextPage();

        print(text);
      } catch (e) {
        print("Error getting image text: $e");
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextPage() {
    if (_currentPageIndex < 2) {
      _currentPageIndex++;
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToPreviousPage() {
    if (_currentPageIndex > 0) {
      _currentPageIndex--;
      _currentPageIndex == 1 ? _currentPageIndex-- : null;
      ;
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: GestureDetector(
          onTap: () {
            if (_currentPageIndex > 0) {
              _navigateToNextPage();
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            child: Icon(
              Icons.arrow_back_ios,
              color: textColorTwo,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  showOptions();
                },
                child: Text("Select Image"),
              ),
            ),
          ),
          // Screen 2: Analyzing (Loading Screen)
          Container(
            child: Center(
              child: LoadingScreen(),
            ),
          ),
          // Screen 3: Generated Questions
          Container(
            color: backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      print("Return to Home");
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Process Completed ",
                          style: fontStyle(25, Colors.black, FontWeight.bold),
                        ),
                        FaIcon(
                          FontAwesomeIcons.check,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
