// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:StayFit/models/firebase_user_info.dart';

Future<bool> addUser(
    String firebaseUId, FirebaseUserInfo firebaseUserInfo) async {
  bool error = false;
  FirebaseFirestore.instance
      .collection("Users")
      .doc(firebaseUId)
      .set({
        'userName': firebaseUserInfo.userName,
        'userEmail': firebaseUserInfo.userEmail,
        'userProfilePhotoUrl': "",
      })
      // ignore: avoid_print
      .then((value) => print("User Added"))
      // // ignore: avoid_print
      // .catchError((error) => print("Failed to add user: $error"));
      // If there's an error remove the user
      .catchError((error) => error = true);
  return !error;
}

void getCurrentUserInfo(String firebaseUID, FirebaseUserInfo userInfo) {
  // var url = Uri.parse(
  //     'https://fittrack-e5a63-default-rtdb.firebaseio.com/Users/${firebaseUID}.json?');
  // inal response = await http.get(url);
  // final extractedData = json.decode(response.body) as Map<String, dynamic>;
  FirebaseFirestore.instance
      .collection("Users")
      .doc(firebaseUID)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      final extractedData = documentSnapshot.data() as Map<String, dynamic>;
      userInfo.userName = extractedData['userName'];
      userInfo.userEmail = extractedData['userEmail'];
      userInfo.userProfilePhotoUrl = extractedData['userProfilePhotoUrl'];
    } else {}
  });
}
