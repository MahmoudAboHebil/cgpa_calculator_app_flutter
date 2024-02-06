class UserModelCourses {
  final String courseId;
  final String semesterId;
  String? courseName;
  int? credit;
  String? grade1;
  String? grade2;
  int type;
  UserModelCourses({
    required this.courseId,
    required this.semesterId,
    this.courseName,
    this.credit,
    this.grade1,
    this.grade2,
    this.type = 1,
  });
  factory UserModelCourses.fromJson(Map<String, dynamic> json) {
    return UserModelCourses(
      courseId: json['courseId'],
      semesterId: json['semesterId'],
      courseName: json['courseName'],
      grade2: json['grade2'],
      grade1: json['grade1'],
      credit: json['credit'],
      type: json['type'],
    );
  }
}
