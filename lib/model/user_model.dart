import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
final String fullName;
final String emailadress;
final String password;
final String userUid;

UserModel({
required this.fullName,
required this.emailadress,
required this.password,
required this.userUid,

});

factory UserModel.fromDocument(DocumentSnapshot doc){

return UserModel(
fullName: doc['fullname'],
emailadress: doc['emailadress'],

password: doc['password'],
userUid: doc['userUid'],

);

}


}