import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelCourses {
  final String courseId;
  final String semesterId;
  final String? courseName;
  final int? credit;
  final String? grade1;
  final String? grade2;
  final int type;
  UserModelCourses({
    required this.courseId,
    required this.semesterId,
    this.courseName,
    this.credit,
    this.grade1,
    this.grade2,
    this.type = 1,
  });
  factory UserModelCourses.fromSnapshot(DocumentSnapshot snap) {
    return UserModelCourses(
      courseId: snap['courseId'],
      semesterId: snap['semesterId'],
      courseName: snap['courseName'],
      grade2: snap['grade2'],
      grade1: snap['grade1'],
      credit: snap['credit'],
      type: snap['type'],
    );
  }
}
