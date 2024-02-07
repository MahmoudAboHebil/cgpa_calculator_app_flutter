class UserModelWithSemester {
  final String semesterId;
  final int semesterIndex;
  final int? credits;
  final double? cgpa;
  UserModelWithSemester(
      {required this.semesterId,
      required this.semesterIndex,
      this.credits,
      this.cgpa});

  factory UserModelWithSemester.fromJson(Map<String, dynamic> json) {
    return UserModelWithSemester(
      semesterId: json['semesterId'],
      semesterIndex: json['semesterIndex'],
      credits: json['credits'],
      cgpa: json['cgpa'],
    );
  }
}
