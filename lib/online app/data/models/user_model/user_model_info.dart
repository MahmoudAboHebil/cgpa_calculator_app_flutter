class UserModelInfo {
  final String email;
  String name;
  String image;
  String division;
  String department;
  bool divisionOption;
  bool departmentOption;
  UserModelInfo({
    required this.name,
    required this.email,
    required this.image,
    required this.division,
    required this.department,
    required this.divisionOption,
    required this.departmentOption,
  });

  factory UserModelInfo.fromJson(Map<String, dynamic> json) {
    return UserModelInfo(
      name: json['name'],
      email: json['email'],
      image: json['image'],
      division: json['division'],
      department: json['department'],
      divisionOption: json['divisionOption'],
      departmentOption: json['departmentOption'],
    );
  }
}
