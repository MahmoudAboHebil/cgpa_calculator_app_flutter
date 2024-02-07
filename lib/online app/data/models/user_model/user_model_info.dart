import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelInfo {
  final String email;
  final String name;
  final String image;
  final String division;
  final String department;
  final bool divisionOption;
  final bool departmentOption;
  UserModelInfo({
    required this.name,
    required this.email,
    required this.image,
    required this.division,
    required this.department,
    required this.divisionOption,
    required this.departmentOption,
  });

  factory UserModelInfo.fromSnapshot(DocumentSnapshot snap) {
    return UserModelInfo(
      name: snap['name'],
      email: snap['email'],
      image: snap['image'],
      division: snap['division'],
      department: snap['department'],
      divisionOption: snap['divisionOption'],
      departmentOption: snap['departmentOption'],
    );
  }
  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'name': name,
      'image': image,
      'division': division,
      'department': department,
      'divisionOption': divisionOption,
      'departmentOption': departmentOption,
    };
  }
}
