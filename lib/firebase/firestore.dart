import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:studybuddyhub/screens/create_exam_screen.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final container = ProviderContainer();

  Stream<QuerySnapshot<Map<String, dynamic>>> get collectionData => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('arttifical')
      .snapshots();

  Future<void> setGeminiChat(List<String> chatData) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('arttifical')
          .add({'geminiChat': chatData, 'timestamp': DateTime.now()});
      print("Veri eklendi");
    } catch (e) {
      print("Chat verisi eklenirken hata oluştu : $e");
    }
  }

  Future<void> setEditProfileBio(String newAddress, String newDisplayName,
      String newEducationLevel, String newPhoneNumber) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'address': newAddress,
        'displayName': newDisplayName,
        'educationLevel': newEducationLevel,
        'phoneNumber': newPhoneNumber,
        'lastUpdated': FieldValue.serverTimestamp(),
        'examList': []
      });
      print(
          "Profil Verisi Güncellendi"); //buradaki bilgileri güncelliycem sistemdekiyle
    } catch (e) {
      print("Profil Verisi Eklenirken bir hata oluştu : $e");
    }
  }

  Future<Map<String, dynamic>> getProfileBio() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        data['id'] = snapshot.id;
        return data;
      } else {
        print("Belirtilen kullanıcının profil bilgisi bulunamadı.");
        return {};
      }
    } catch (e) {
      print("Profil verisi getirilirken hata oluştu: $e");
      return {};
    }
  }

  Future<void> setExamProfileFirestore(
      List<Map<String, dynamic>> examList) async {
    try {
      if (examList.isEmpty) {
        print("examList boş, veri gönderilemiyor.");
        return;
      }

      List<Map<String, dynamic>> questionList = [
        {'examList': examList, 'duration': examList.length + 5}
      ];

      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'examList': FieldValue.arrayUnion(questionList),
      });

      print("Sorular veritabanına kaydedildi");
      return;
      //burada da next navigationsayfası yapalım en son soru sayfasına gitsin
    } catch (e) {
      print("Profil Soruları yüklenirken bir hata oluştu: $e");
      return;
    }
  }
}
