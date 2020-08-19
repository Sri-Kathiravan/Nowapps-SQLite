
import 'dart:convert';

class UserDataModel {
  UserDataModel({
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.phoneNumber,
    this.emailId,
  });

  String firstName;
  String lastName;
  int age;
  String gender;
  String phoneNumber;
  String emailId;

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    firstName: json["first_name"],
    lastName: json["last_name"],
    age: json["age"],
    gender: json["gender"],
    phoneNumber: json["phone_number"],
    emailId: json["email_id"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "age": age,
    "gender": gender,
    "phone_number": phoneNumber,
    "email_id": emailId,
  };
}

UserDataModel userDataFromJson(String str) {
  final jsonData = json.decode(str);
  return UserDataModel.fromJson(jsonData);
}

String userDataToJson(UserDataModel data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}