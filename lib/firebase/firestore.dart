import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> addToDailyQuestionData(int question_value) async {
    try {
      print("Veri eklemeye başlıyor");
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'daily_counter': FieldValue.increment(question_value),
        'updatedUser': DateTime.now(),
      });
      print("Profil verisi güncellendi");
    } catch (e) {
      print("Profile veri eklenirken bir hata oluştu");
    }
  }

  Future<void> addToDailyData(int question) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'daily_goal': FieldValue.increment(question),
        'updatedUser': DateTime.now(),
        'daily_goal_active': true
      });
      print("Profil verisi güncellendi");
    } catch (e) {
      print("Profile veri eklenirken bir hata oluştu");
    }
  }

  Future<void> resetDailyData() async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'daily_counter': 0,
        'updatedUser': DateTime.now(),
      });
    } catch (e) {
      print("Veri güncellenirken bir hata oluştu : $e");
    }
  }

  Future<void> resetDailyCounterDataAll() async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'daily_goal': 0,
        'daily_goal_active': false,
        'updatedUser': DateTime.now(),
        'daily_counter': 0,
      });
    } catch (e) {
      print("Veri güncellenirken bir hata oluştu : $e");
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

  Future<void> deleteAccount() async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).delete();
      await _auth.currentUser!.delete();
    } catch (e) {
      print("Profil verileri silinirken bir hata oluştu : $e");
    }
  }
}
