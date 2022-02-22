class UserModel {
  String name, location, email, photoUrl;

  UserModel(
      {required this.name,
      required this.location,
      required this.email,
      required this.photoUrl});

  Map toJson({required UserModel userModel}) => {
        'name': userModel.name,
        'location': userModel.location,
        'email': userModel.email,
        'photoUrl': userModel.photoUrl,
      };

  UserModel fromJson({required Map mapValue}) => UserModel(
        name: mapValue['name'],
        location: mapValue['location'],
        email: mapValue['email'],
        photoUrl: mapValue['photoUrl'],
      );
}
