import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String name, location, email;
  String? photoUrl;

  UserModel(
      {required this.name,
      required this.location,
      required this.email,
      required this.photoUrl});

  static Map<String, Object?> toJson({required UserModel userModel}) => {
        'name': userModel.name,
        'location': userModel.location,
        'email': userModel.email,
        'photoUrl': userModel.photoUrl,
      };

  static UserModel fromJson({required Map mapValue}) => UserModel(
        name: mapValue['name'],
        location: mapValue['location'],
        email: mapValue['email'],
        photoUrl: mapValue['photoUrl'],
      );

  static Future<void> updateInDB({required UserModel userModel}) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Users');
    return await collectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(UserModel.toJson(userModel: userModel));
  }
}
