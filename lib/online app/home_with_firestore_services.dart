import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeWithFireStoreServices {
  final User _loggedInUser;
  final CollectionReference _coursesRef;
  HomeWithFireStoreServices(this._coursesRef, this._loggedInUser);

  void addCourseInDB(int semestID, String courseId, String? name,
      String? credit, String? grade1, String? grade2, String type) async {
    await FirebaseFirestore.instance
        .collection('UsersCourses')
        .doc('${_loggedInUser.email}')
        .collection('courses')
        .doc(courseId)
        .set({
      'courseName': name,
      'credit': credit,
      'grade1': grade1,
      'grade2': grade2,
      'semestId': semestID,
      'type': type,
      'id': courseId,
    });
  }

  void updateData(var semestId, var courseId, var name, var credit, var grade1,
      var grade2, var type) async {
    await _coursesRef.doc(courseId).set({
      'id': courseId,
      'courseName': name,
      'credit': credit,
      'grade1': grade1,
      'grade2': grade2,
      'semestId': semestId,
      'type': '$type',
    });
  }

  void deleteSemesterFromDB(int semesterId) async {
    await _coursesRef.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final DocumentSnapshot course = doc;
        if (course['semestId'] == semesterId) {
          String id = course.id;
          _coursesRef.doc(id).delete();
        }
      });
    });
  }

  void deleteCourseFromDB(String courseId) async {
    _coursesRef.doc(courseId).delete();
  }
}
