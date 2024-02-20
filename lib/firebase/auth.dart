import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User get user => _auth.currentUser!;

  Future<bool> signInWithGoogle() async {
    bool result = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore.collection('users').doc(user.uid).set({
            'displayName': user.displayName,
            'uid': user.uid,
            'profilePhoto': user.photoURL,
            'phoneNumber': '',
            'educationLevel': '',
            'address': '',
            'email': user.email,
            'createdAt': DateTime.now()
          });
        }
        result = true;
      }
      return result;
    } catch (e) {
      print("Error Google Sign In : $e");
    }
    return result;
  }

  //Sign İn with facebook write to firestore

  Future<bool> signInWithFacebook() async {
    bool result = false;
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          if (userCredential.additionalUserInfo!.isNewUser) {
            await _firestore.collection('users').doc(user.uid).set({
              'displayName': user.displayName,
              'uid': user.uid,
              'profilePhoto': user.photoURL
            });
          }
          result = true;
        }
      }
    } catch (e) {
      print("Error Facebook Sign In: $e");
    }
    return result;
  }

  void signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print('Can not SignOut as :$e');
    }
  }
}
