import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  final String? uid;

  DataService({
    this.uid
  });
  final CollectionReference packageDetailsCollection =
      FirebaseFirestore.instance.collection("packageDetails");
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference porterVerification =
      FirebaseFirestore.instance.collection('porterVerification');
  final CollectionReference paymentCollection =
      FirebaseFirestore.instance.collection('paymentRequest');
  final CollectionReference topUpPorterCollection =
      FirebaseFirestore.instance.collection('topUpPorter');
  final CollectionReference topUpUserCollection =
      FirebaseFirestore.instance.collection('topUpUser');

// ---------------------Setting User Details------------------------
  Future setUserDetails(
      {String? name,
      String? email,
      String? timestamp,
      String? uid}) async {
    return await usersCollection.doc(uid).set({
      'firstName': name,
      'email': email,
      'uid': uid,
      'created': timestamp,
    });
  }

  /// ----------------------------------------------------------
  /// Set Notification Controller Status
  /// ----------------------------------------------------------
  /// Setting notification controllers status
  Future setNotificationStatus() async {
    return await usersCollection
        .doc(uid)
        .collection('notificationsControllers')
        .doc(uid)
        .set({
      'inbox_msg': true,
      'new_order_msg': true,
      'inbox_mail': true,
      'new_order__mail': true,
      "order_updates": true,
      "sound_control": true,
      "vibration": true,
    });
  }

  // ---------------------Update Notification Status------------------------
  Future updateNotificationStatus({String? key, dynamic value}) async {
    return usersCollection
        .doc(uid)
        .collection("notificationsControllers")
        .doc(uid)
        .update({
      "$key": value,
    });
  }


// ------------------Update User Details----------------------------
  Future updateUserDetails({String? key, dynamic value}) async {
    return usersCollection.doc(uid).update({
      "$key": value,
    });
  }

  // ------------------Update User Details----------------------------
  Future updateUserDetailsMap(Map<String, dynamic> user) async {
    return usersCollection.doc(uid).update(user);
  }

// ------------------Update Save contacts----------------------------
  Future saveContact({String? key, dynamic value}) async {
    return usersCollection.doc(uid).update({
      "$key": FieldValue.arrayUnion([value])
    });
  }

// ------------------Update Porter's Live Location----------------------------
  Future updatePortersLiveLocation(
      {String? key, Map<dynamic, dynamic>? value}) async {
    return packageDetailsCollection.doc(uid).update({
      "$key": value,
    });
  }

// // -------------------Get User Details--------------------------------
//   Future<Map<dynamic, dynamic>> getUserDetails() {
//     return usersCollection.doc(uid).get().then((value) {
//       return value.data();
//     });
//   }

// // -------------------Get User Details--------------------------------
//   getUserDetailsFromSPref() {
//     CarieUsers users =
//         CarieUsers.fromJson(jsonDecode((sp.getString(SpUtil.carieUserData))));
//     return users;
//   }

}