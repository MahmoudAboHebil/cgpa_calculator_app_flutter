import 'dart:collection';
import 'package:cgp_calculator/online app/pages/home_with_firestore_page.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/computer_science.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/free_choice_courses.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/natural_sciences_division.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/statistics.dart';
import 'package:collection/collection.dart';

import '../collage_courses_data/common_department_courses.dart';
import '../collage_courses_data/university_requirement_courses.dart';

class CollegeService {
  static bool systemOption = false;
  static bool departmentOption = false;
  static String departmentName = '';
  static String divisionName = '';

  static List<String> divisions = [
    // 'Computer Science (Special) Alex ',

    'Natural Sciences Division (Alex)',
  ];
  static List<String> departments = ['Computer Science and Statistics (Alex)'];
  static List getDivisionList() {
    NaturalSciences naturalSciences = NaturalSciences();

    if (divisionName == 'Natural Sciences Division (Alex)') {
      return naturalSciences.collegeRequirementsCourses();
    }
    return [];
  }

  static List getMajor_Mandatory() {
    ComputerScience computerScience = ComputerScience();
    CommonDPCourses commonDPCourses = CommonDPCourses();
    if (departmentName == 'Computer Science and Statistics (Alex)') {
      return editingOnDepartment(computerScience.mandatoryMajorCS(),
          commonDPCourses.matrices, commonDPCourses.linearAlgebra);
    }
    return [];
  }

  static List getMajor_Elective() {
    ComputerScience computerScience = ComputerScience();
    CommonDPCourses commonDPCourses = CommonDPCourses();

    if (departmentName == 'Computer Science and Statistics (Alex)') {
      return returnListWithoutRepeatCourses(
          editingOnDepartment(computerScience.electiveMajorCS(),
              commonDPCourses.matrices, commonDPCourses.linearAlgebra),
          getMajor_Mandatory());
    }

    return [];
  }

  static List getMinor_Mandatory() {
    Statistics statistics = Statistics();
    CommonDPCourses commonDPCourses = CommonDPCourses();

    if (departmentName == 'Computer Science and Statistics (Alex)') {
      List returnList = editingOnDepartment(statistics.mandatoryMinorStat(),
          commonDPCourses.matrices, commonDPCourses.linearAlgebra);
      returnList =
          returnListWithoutRepeatCourses(returnList, getMajor_Mandatory());
      returnList =
          returnListWithoutRepeatCourses(returnList, getMajor_Elective());

      return returnList;
    }

    return [];
  }

  static List getMinor_Elective() {
    Statistics statistics = Statistics();
    CommonDPCourses commonDPCourses = CommonDPCourses();

    if (departmentName == 'Computer Science and Statistics (Alex)') {
      List returnList = editingOnDepartment(statistics.electiveMinorStat(),
          commonDPCourses.matrices, commonDPCourses.linearAlgebra);
      returnList =
          returnListWithoutRepeatCourses(returnList, getMajor_Mandatory());
      returnList =
          returnListWithoutRepeatCourses(returnList, getMajor_Elective());
      returnList =
          returnListWithoutRepeatCourses(returnList, getMinor_Mandatory());

      return returnList;
    }
    return [];
  }

  static List returnListWithoutRepeatCourses(List firstList, List secondList) {
    List returnList = [];
    List<String> sdListNames = [];
    for (List list in secondList) {
      sdListNames.add(list[4]);
    }

    for (int i = 0; i < firstList.length; i++) {
      if (!sdListNames.contains(firstList[i][4])) {
        returnList.add(firstList[i]);
      }
    }

    return returnList;
  }

  static List returnListWithoutRepeatCourses_sum(
      List firstListMajor, List secondListMinor) {
    List<String> ft_names = [];
    List<String> all_names = [];

    for (List list in firstListMajor) {
      all_names.add(list[4]);
      ft_names.add(list[4]);
    }
    for (List list in secondListMinor) {
      all_names.add(list[4]);
    }
    all_names = LinkedHashSet<String>.from(all_names).toList();

    List returnList = firstListMajor;

    for (List fl in firstListMajor) {
      if (all_names.contains(fl[4])) {
        all_names.remove(fl[4]);
      }
    }
    for (List sl in secondListMinor) {
      if (all_names.contains(sl[4])) {
        returnList.add(sl);
      }
    }

    return returnList;
  }

  static List editingOnDepartment(List list, List oldCourse, List newCourse) {
    ComputerScience computerScience = ComputerScience();

    List newList = [];
    String oldName = oldCourse[0];
    String oldNumber = oldCourse[2];
    newCourse[2] = oldNumber;
    for (List cor in list) {
      if (cor[4] == oldName) {
        if (cor[5] == 'Major-Mandatory') {
          newList.add(computerScience.addMajorString(newCourse, true));
        } else if (cor[5] == 'Major-Elective') {
          newList.add(computerScience.addMajorString(newCourse, false));
        } else if (cor[5] == 'Minor-Mandatory') {
          newList.add(computerScience.addMinorString(newCourse, true));
        } else {
          newList.add(computerScience.addMinorString(newCourse, false));
        }
      } else {
        newList.add(cor);
      }
    }
    return newList;
  }

  // static List getAllDepartmentCourses() {
  //   if (departmentName == 'Computer Science and Statistics (Alex)') {
  //     List allCourses = [];
  //
  //     ComputerScience computerScience = ComputerScience();
  //     Statistics statistics = Statistics();
  //     CommonDPCourses commonDPCourses = CommonDPCourses();
  //     for (List list in computerScience.mandatoryMajorCS()) {
  //       allCourses.add(list);
  //     }
  //     for (List list in statistics.mandatoryMinorStat()) {
  //       allCourses.add(list);
  //     }
  //     for (List list in computerScience.electiveMajorCS()) {
  //       allCourses.add(list);
  //     }
  //     for (List list in statistics.electiveMinorStat()) {
  //       allCourses.add(list);
  //     }
  //
  //     return allCourses;
  //   }
  //   return [];
  // }

  static List getDepartmentList() {
    if (departmentName == 'Computer Science and Statistics (Alex)') {
      ComputerScience computerScience = ComputerScience();
      Statistics statistics = Statistics();
      CommonDPCourses commonDPCourses = CommonDPCourses();
      List l1 = returnListWithoutRepeatCourses_sum(
          computerScience.mandatoryMajorCS(), statistics.mandatoryMinorStat());

      List l2 = returnListWithoutRepeatCourses_sum(
          computerScience.electiveMajorCS(), statistics.electiveMinorStat());

      List l3 = returnListWithoutRepeatCourses_sum(l1, l2);

      List l4 = editingOnDepartment(
          l3, commonDPCourses.matrices, commonDPCourses.linearAlgebra);

      return l4;
    }

    return [];
  }

  static List<String> getCoursesNames() {
    UniversityRequirement universityRequirement = UniversityRequirement();
    FreeChoice freeChoice = FreeChoice();
    List<String> names = [];
    for (List list in getDivisionList()) {
      names.add(list[0]);
    }
    for (List list in universityRequirement.universityRequirementsCourses) {
      names.add(list[0]);
    }

    for (List list in freeChoice.freeChoiceCourses) {
      names.add(list[0]);
    }
    if (departmentOption) {
      for (List list in getDepartmentList()) {
        names.add(list[0]);
      }
    }
    return names;
  }

  static String getCredit(String courseName) {
    UniversityRequirement universityRequirement = UniversityRequirement();
    FreeChoice freeChoice = FreeChoice();
    String credit = '';
    for (List course in getDivisionList()) {
      if (course[0] == courseName) {
        credit = course[1];
        return credit;
      }
    }
    for (List course in universityRequirement.universityRequirementsCourses) {
      if (course[0] == courseName) {
        credit = course[1];
        return credit;
      }
    }

    for (List course in freeChoice.freeChoiceCourses) {
      if (course[0] == courseName) {
        credit = course[1];
        return credit;
      }
    }
    if (departmentOption) {
      for (List course in getDepartmentList()) {
        if (course[0] == courseName) {
          credit = course[1];
          return credit;
        }
      }
    }
    return credit;
  }

//
  static List getOpenCoursesId(String id) {
    List ids = [];
    for (List course in getDivisionList()) {
      if (course[3][0].contains(id)) {
        ids.add([course[2], course[0]]);
      }
      if (course[3][1].contains(id)) {
        ids.add([course[2], course[0]]);
      }
    }

    for (List course in getDepartmentList()) {
      if (course[3][0].isNotEmpty) {
        if (course[3][0].contains(id)) {
          ids.add([course[2], course[0]]);
        }
      }
      if (course[3][1].isNotEmpty) {
        if (course[3][1].contains(id)) {
          ids.add([course[2], course[0]]);
        }
      }
    }
    return ids;
  }

  static String? getCourseNickNameDpByName(String courseName) {
    UniversityRequirement universityRequirement = UniversityRequirement();
    FreeChoice freeChoice = FreeChoice();
    String? nickDp;
    for (List course in getDivisionList()) {
      if (course[4] == courseName) {
        nickDp = course[5];
      }
    }
    if (departmentOption) {
      for (List course in getDepartmentList()) {
        if (course[4] == courseName) {
          nickDp = course[5];
        }
      }
    }
    for (List course in universityRequirement.universityRequirementsCourses) {
      if (course[4] == courseName) {
        nickDp = course[5];
      }
    }
    for (List course in freeChoice.freeChoiceCourses) {
      if (course[4] == courseName) {
        nickDp = course[5];
      }
    }
    return nickDp;
  }

  static String? getCourseNumberByName(String courseName) {
    String? number;
    for (List course in getDivisionList()) {
      if (course[0] == courseName) {
        number = course[2];
      }
    }
    if (departmentOption) {
      for (List course in getDepartmentList()) {
        if (course[0] == courseName) {
          number = course[2];
        }
      }
    }
    return number;
  }

  static String getDepartmentCourseNameById(String courseId) {
    String name = '';
    for (List course in getDepartmentList()) {
      if (course[2] == courseId) {
        name = course[0];
      }
    }
    for (List course in getDivisionList()) {
      if (course[2] == courseId) {
        name = course[0];
      }
    }
    return name;
  }

  static bool isGlobalDepartmentValidationOK() {
    List<bool> val = [true];
    List<List> validCourse = [];
    List<List> collegeRequirements = [];
    for (List course in CollegeService.getDivisionList()) {
      collegeRequirements.add([course[0], course[1]]);
    }
    for (List semester in allSemesters) {
      for (List course in semester) {
        if (course[1] != null && course[2] != null && course[3] != null) {
          if (course[3] != 'U' &&
              course[3] != 'F' &&
              course[3] != 'Non' &&
              course[3] != 'W' &&
              course[4] == null) {
            validCourse.add([course[1], course[2]]);
          } else if (course[4] != null &&
              course[1] != null &&
              course[2] != null &&
              course[4] != 'U' &&
              course[4] != 'F' &&
              course[4] != 'W' &&
              course[4] != 'Non') {
            validCourse.add([course[1], course[2]]);
          }
        }
      }
    }
    List<String> validCourseNames = [];
    for (List list in validCourse) {
      validCourseNames.add(list[0]);
    }
    List<String> validCourseReq = [];
    for (List list in collegeRequirements) {
      validCourseReq.add(list[0]);
    }
    for (List list in collegeRequirements) {
      if (!validCourseNames.contains(list[0])) {
        val.add(false);
      } else {
        int index = validCourseNames.indexOf(list[0]);
        String cre = validCourse[index][1];
        if (cre != list[1]) {
          val.add(false);
        }
      }
    }

    return !val.contains(false) && CollegeService.systemOption;
  }

  static bool courseEnrollingSystem(
      String courseName, int semestId, List listInSemester) {
    Function eq = DeepCollectionEquality.unordered().equals;

    bool isValidMustCourses = true;
    bool isValidOneCourses = true;
    bool isValidDp = true;

    List coursesMustBeEnrolled = [];
    List coursesMustOneBeEnrolled = [];
    List<String> val1 = [];
    List<bool> val = [];

    for (List course in getDivisionList()) {
      if (course[0] == courseName) {
        coursesMustBeEnrolled = course[3][0];
        coursesMustOneBeEnrolled = course[3][1];
      }
    }

    if (departmentOption) {
      for (List course in getDepartmentList()) {
        if (course[0] == courseName) {
          coursesMustBeEnrolled = course[3][0];
          coursesMustOneBeEnrolled = course[3][1];
        }
      }
    }
    for (String v in coursesMustOneBeEnrolled) {
      val.add(false);
    }

    if (!coursesMustBeEnrolled.contains('m')) {
      for (List semester in allSemesters) {
        for (List course in semester) {
          if (course[0] < semestId) {
            if (course[1] != null && course[3] != null) {
              if (course[3] != 'U' &&
                  course[3] != 'F' &&
                  course[3] != 'Non' &&
                  course[3] != 'W' &&
                  course[4] == null) {
                String? num = getCourseNumberByName(course[1]);
                if (num != null) {
                  if (coursesMustBeEnrolled.contains(num)) {
                    val1.add(num);
                  }
                }
              } else if (course[4] != null &&
                  course[4] != 'U' &&
                  course[4] != 'F' &&
                  course[4] != 'W' &&
                  course[4] != 'Non') {
                String? num = getCourseNumberByName(course[1]);
                if (num != null) {
                  if (coursesMustBeEnrolled.contains(num)) {
                    val1.add(num);
                  }
                }
              }
            }
          }
        }
      }
    } else {
      //###################################################

      // this type 1:
      val1 = [];

      for (List course in listInSemester) {
        if (course[1] != null) {
          String? num = getCourseNumberByName(course[1]);
          if (num != null) {
            if (coursesMustBeEnrolled.contains(num)) {
              val1.add(num);
            }
          }
        }
      }
      val1.add('m');
      if (!eq(val1, coursesMustBeEnrolled)) {
        val1 = [];
        for (List semester in allSemesters) {
          for (List course in semester) {
            if (course[0] < semestId) {
              if (course[1] != null && course[3] != null) {
                if (course[3] != 'U' &&
                    course[3] != 'F' &&
                    course[3] != 'Non' &&
                    course[3] != 'W' &&
                    course[4] == null) {
                  String? num = getCourseNumberByName(course[1]);
                  if (num != null) {
                    if (coursesMustBeEnrolled.contains(num)) {
                      val1.add(num);
                    }
                  }
                } else if (course[4] != null &&
                    course[4] != 'U' &&
                    course[4] != 'F' &&
                    course[4] != 'W' &&
                    course[4] != 'Non') {
                  String? num = getCourseNumberByName(course[1]);
                  if (num != null) {
                    if (coursesMustBeEnrolled.contains(num)) {
                      val1.add(num);
                    }
                  }
                }
              }
            }
          }
        }
        val1.add('m');
      }
      //###################################################
      // this type 2:
      // List<int> list = [0];
      // for (List semester in allSemesters) {
      //   for (List course in semester) {
      //     if (course[1] != null) {
      //       String? num = getCourseNumberByName(course[1]);
      //       if (coursesMustBeEnrolled.contains(num)) {
      //         list.add(course[0]);
      //       }
      //     }
      //   }
      // }
      //
      // int maxSemester = list.max;
      //
      // if (semestId >= maxSemester &&
      //     list.length >= coursesMustBeEnrolled.length) {
      //   val = [];
      //   coursesMustBeEnrolled = [];
      // }
    }
    if (coursesMustOneBeEnrolled.isNotEmpty) {
      for (List semester in allSemesters) {
        for (List course in semester) {
          if (course[0] < semestId) {
            if (course[1] != null && course[3] != null) {
              if (course[3] != 'U' &&
                  course[3] != 'F' &&
                  course[3] != 'Non' &&
                  course[3] != 'W' &&
                  course[4] == null) {
                String? num = getCourseNumberByName(course[1]);
                if (num != null) {
                  if (coursesMustOneBeEnrolled.isNotEmpty) {
                    if (coursesMustOneBeEnrolled.contains(num)) {
                      val = [];
                    }
                  }
                }
              } else if (course[4] != null &&
                  course[4] != 'U' &&
                  course[4] != 'F' &&
                  course[4] != 'W' &&
                  course[4] != 'Non') {
                String? num = getCourseNumberByName(course[1]);
                if (num != null) {
                  if (coursesMustOneBeEnrolled.isNotEmpty) {
                    if (coursesMustOneBeEnrolled.contains(num)) {
                      val = [];
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    val1 = LinkedHashSet<String>.from(val1).toList();
    coursesMustBeEnrolled =
        LinkedHashSet<String>.from(coursesMustBeEnrolled).toList();

    List<bool> isInValidSemester = [true];

    if (departmentOption) {
      List<String> departCoursesNames = [];
      List<String> divNames = [];

      for (List divC in getDivisionList()) {
        divNames.add(divC[0]);
      }
      for (List list in getDepartmentList()) {
        departCoursesNames.add(list[0]);
      }

      for (List course in listInSemester) {
        if (divNames.contains(course[1]) &&
            departCoursesNames.contains(courseName)) {
          isInValidSemester.add(false);
        }
      }

      if (!isGlobalDepartmentValidationOK() &&
          departmentOption &&
          departCoursesNames.contains(courseName)) {
        isValidDp = false;
      } else {
        isValidDp = true;
      }
    }

    if (val.isNotEmpty) {
      if (val.contains(false)) {
        isValidOneCourses = false;
      } else {
        isValidOneCourses = true;
      }
    }
    if (coursesMustBeEnrolled.contains('Four')) {
      if (earnCredit >= 100) {
        val1.add('Four');

        if (!eq(val1, coursesMustBeEnrolled)) {
          isValidMustCourses = false;
        }
      } else if (earnCredit == -1) {
        val1.add('Four');
      } else {
        isValidMustCourses = false;
      }
    } else {
      if (!eq(val1, coursesMustBeEnrolled)) {
        isValidMustCourses = false;
      }
    }
    if (val1.contains('Four')) {
      // print('isValidMustCourses :$isValidMustCourses');
      // print('isValidOneCourses :$isValidOneCourses');
      // print('isValidDp :$isValidDp');
      // print(
      //     '!isInValidSemester.contains(false) :${!isInValidSemester.contains(false)}');
      // print(isValidMustCourses &&
      //     isValidOneCourses &&
      //     isValidDp &&
      //     !isInValidSemester.contains(false));
    }
    return isValidMustCourses &&
        isValidOneCourses &&
        isValidDp &&
        !isInValidSemester.contains(false);
  }

  static List<String> getSuggestionsCoursePage(String query) {
    UniversityRequirement universityRequirement = UniversityRequirement();
    FreeChoice freeChoice = FreeChoice();

    List<String> matches = [];
    if (departmentOption) {
      for (List course in getDepartmentList()) {
        matches.add(course[4]);
      }
    }
    for (List course in getDivisionList()) {
      matches.add(course[4]);
    }
    for (List course in universityRequirement.universityRequirementsCourses) {
      matches.add(course[4]);
    }

    for (List course in freeChoice.freeChoiceCourses) {
      matches.add(course[4]);
    }

    if (matches.isNotEmpty) {
      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matches;
    }
    return ['There are no courses left'];
  }

  static List<String> getSuggestions(String query, List listInSemester,
      int semestId, bool isQuery, bool removeList, int semesterIndex) {
    UniversityRequirement universityRequirement = UniversityRequirement();
    FreeChoice freeChoice = FreeChoice();
    List<String> matches = <String>[];
    //
    int totalCredit_without_SU = 0;
    double totalPointsOfSemest = 0.0;
    double totalCredit = 0;
    double CGPA = 0.0;
    int earnCredit = 0;
    if (allSemesters.isNotEmpty) {
      for (int i = 1; i < semesterIndex; i++) {
        // semester = [[],[],]
        // print("i:$i ,semesterIndex :$semesterIndex");

        for (List course in allSemesters[i]) {
          if (course[1] != null && course[2] != null && course[3] != null) {
            String grade1 = course[3];
            String? grade2 = course[4];
            String grade = grade2 ?? grade1;

            // [[semesterNum,courseName,credit,grade1,grade2,('two' for two grade otherwise 'one') ],....]

            int credit = int.parse(course[2]);
            double pointOfGrade = 0.0;
            double pointOfGrade2 = 0.0;
            double pointOfCourse = 0.0;
            if (course[1] ==
                    universityRequirement.mandatoryUniversityRequirements[0]
                        [0] ||
                grade == 'W') {
              // totalCredit = totalCredit + credit;
              String grade = grade2 ?? grade1;
              // if (!(grade == 'Non' || grade == 'F' || grade == 'U')) {
              //   //  passed course
              //   earnCredit = earnCredit + credit;
              // }
            } else {
              if (grade1 == 'A') {
                pointOfGrade = 4.00;
              } else if (grade1 == 'A-') {
                pointOfGrade = 3.67;
              } else if (grade1 == 'B+') {
                pointOfGrade = 3.33;
              } else if (grade1 == 'B') {
                pointOfGrade = 3.00;
              } else if (grade1 == 'B-') {
                pointOfGrade = 2.67;
              } else if (grade1 == 'C+') {
                pointOfGrade = 2.33;
              } else if (grade1 == 'C') {
                pointOfGrade = 2.00;
              } else if (grade1 == 'C-') {
                pointOfGrade = 1.67;
              } else if (grade1 == 'D+') {
                pointOfGrade = 1.33;
              } else if (grade1 == 'D') {
                pointOfGrade = 1.00;
              } else if (grade1 == 'F') {
                pointOfGrade = 0.00;
              } else if (grade1 == 'S') {
                pointOfGrade = -1.00;
              } else if (grade1 == 'Non') {
                pointOfGrade = -3.00;
              } else {
                // u grade
                pointOfGrade = -2.00;
              }
              if (grade2 != null && grade2.isNotEmpty) {
                if (grade2 == 'A') {
                  pointOfGrade2 = 4.00;
                } else if (grade2 == 'A-') {
                  pointOfGrade2 = 3.67;
                } else if (grade2 == 'B+') {
                  pointOfGrade2 = 3.33;
                } else if (grade2 == 'B') {
                  pointOfGrade2 = 3.00;
                } else if (grade2 == 'B-') {
                  pointOfGrade2 = 2.67;
                } else if (grade2 == 'C+') {
                  pointOfGrade2 = 2.33;
                } else if (grade2 == 'C') {
                  pointOfGrade2 = 2.00;
                } else if (grade2 == 'C-') {
                  pointOfGrade2 = 1.67;
                } else if (grade2 == 'D+') {
                  pointOfGrade2 = 1.33;
                } else if (grade2 == 'D') {
                  pointOfGrade2 = 1.00;
                } else if (grade2 == 'F') {
                  pointOfGrade2 = 0.00;
                } else if (grade2 == 'S') {
                  pointOfGrade2 = -1.00;
                } else if (grade2 == 'Non') {
                  pointOfGrade2 = -3.00;
                } else {
                  // u grade
                  pointOfGrade2 = -2.00;
                }
              }
              if (grade2 == null) {
                if (pointOfGrade >= 0.00) {
                  // not s/u course
                  totalCredit_without_SU = totalCredit_without_SU + credit;
                  totalCredit = totalCredit + credit;
                  pointOfCourse = pointOfGrade * credit;
                  totalPointsOfSemest = totalPointsOfSemest + pointOfCourse;
                } else {
                  // s/u course
                  totalCredit = totalCredit + credit;
                }

                if (!(pointOfGrade == 0.00 ||
                    pointOfGrade == -2.00 ||
                    pointOfGrade == -3.00)) {
                  //  passed course
                  earnCredit = earnCredit + credit;
                }
              } else if ((pointOfGrade2 == -1.00 ||
                  pointOfGrade2 == -2.00 ||
                  pointOfGrade2 == -3.00)) {
                if (pointOfGrade2 == -1.00 && pointOfGrade == -2.00) {
                  earnCredit = earnCredit + credit;
                  totalCredit = totalCredit + credit;
                } else if (pointOfGrade2 == -2.00 && pointOfGrade == -1.00) {
                  earnCredit = earnCredit - credit;
                }
              } else {
                double p2 = pointOfGrade2 * credit;
                double p1 = pointOfGrade * credit;

                if (p2 >= p1 && pointOfGrade2 != 0.00) {
                  if (p1 == 0.00 && p2 == 0.00) {
                  } else if (p1 == 0.00 && p2 != 0.00) {
                    earnCredit = earnCredit + credit;
                    pointOfCourse = p2 - p1;
                    totalPointsOfSemest = totalPointsOfSemest + pointOfCourse;
                  } else {
                    pointOfCourse = p2 - p1;
                    totalPointsOfSemest = totalPointsOfSemest + pointOfCourse;
                  }
                } else {
                  // p2<p1
                  if (p2 == 0.00 && p1 != 0.00) {
                    earnCredit = earnCredit - credit;
                    totalCredit_without_SU = totalCredit_without_SU + credit;
                  } else {
                    // p1 == 0.00 && p2 == 0.00
                  }
                }
              }
            }
          }
        }
      }
      if (totalPointsOfSemest == 0.0 && totalCredit_without_SU == 0) {
        CGPA = 0.0;
      } else {
        CGPA = (totalPointsOfSemest / totalCredit_without_SU);
      }
      if (CGPA > 4.0) {
        CGPA = 4.0;
      }
      // print('semesterIndex:$semesterIndex , CGPA:$CGPA');
    } else {}
    //

    /// todo: the next line  may be cause some bugs
    double cgpa = (CGPA != 0.0) ? CGPA : 5.00;
    // print('semesterIndex:$semesterIndex , cgpa:$cgpa');

    if (systemOption) {
      // avoiding repeating course in the list
      List<String> coursesNamesEntered = [];
      for (int i = 0; i < semesterIndex; i++) {
        for (List course in allSemesters[i]) {
          if (cgpa <= 2) {
            if (coursesNamesEntered.contains(course[1])) {
              coursesNamesEntered.remove(course[1]);
            }
            if (course[1] != null && course[3] != null) {
              if (course[3] != 'A' &&
                  course[3] != 'A-' &&
                  course[3] != 'B+' &&
                  course[3] != 'B' &&
                  course[3] != 'B-' &&
                  course[3] != 'C+' &&
                  course[4] == null) {
                coursesNamesEntered.add(course[1]);
              } else if (course[4] != null &&
                  course[3] != 'A' &&
                  course[3] != 'A-' &&
                  course[3] != 'B+' &&
                  course[3] != 'B' &&
                  course[3] != 'B-' &&
                  course[3] != 'C+' &&
                  course[4] != 'Non') {
                coursesNamesEntered.add(course[1]);
              }
            }
          } else {
            if (course[1] != null && course[3] != null) {
              if (course[3] != 'U' &&
                  course[3] != 'F' &&
                  course[3] != 'Non' &&
                  course[3] != 'W' &&
                  course[4] == null) {
                coursesNamesEntered.add(course[1]);
              } else if (course[4] != null &&
                  course[4] != 'U' &&
                  course[4] != 'F' &&
                  course[4] != 'W' &&
                  course[4] != 'Non') {
                coursesNamesEntered.add(course[1]);
              }
            }
          }
        }
      }
      List<String> namesCoursesInSemest = [];
      if (!removeList) {
        for (List course in listInSemester) {
          if (course[1] != null) {
            namesCoursesInSemest.add(course[1]);
          }
        }
      }

      if (!isQuery && cgpa > 2) {
        coursesNamesEntered =
            LinkedHashSet<String>.from(coursesNamesEntered).toList();
        if (coursesNamesEntered.contains(query)) {
          coursesNamesEntered.remove(query);
        }
      }
      if (!isQuery) {
        namesCoursesInSemest =
            LinkedHashSet<String>.from(namesCoursesInSemest).toList();
        if (namesCoursesInSemest.contains(query)) {
          namesCoursesInSemest.remove(query);
        }
      }
      for (List course in getDivisionList()) {
        bool val;
        if (!(cgpa <= 2)) {
          val = !coursesNamesEntered.contains(course[0]);
        } else {
          // half load
          val = coursesNamesEntered.contains(course[0]);
        }
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            val &&
                !namesCoursesInSemest.contains(course[0]) &&
                courseEnrollingSystem(course[0], semestId, listInSemester)) {
          matches.add(course[0]);
        }
      }
      if (departmentOption) {
        for (List course in getDepartmentList()) {
          bool val;
          if (!(cgpa <= 2)) {
            val = !coursesNamesEntered.contains(course[0]);
          } else {
            val = coursesNamesEntered.contains(course[0]);
          }
          if (

              ///  TODO: in the next line you will not allow the user to improve their grade .
              val &&
                  !namesCoursesInSemest.contains(course[0]) &&
                  courseEnrollingSystem(course[0], semestId, listInSemester)) {
            matches.add(course[0]);
          }
        }
      }
      for (List course in universityRequirement.universityRequirementsCourses) {
        bool val;
        if (!(cgpa <= 2)) {
          val = !coursesNamesEntered.contains(course[0]);
        } else {
          val = coursesNamesEntered.contains(course[0]);
        }
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            val && !namesCoursesInSemest.contains(course[0])) {
          matches.add(course[0]);
        }
      }

      for (List course in freeChoice.freeChoiceCourses) {
        bool val;
        if (!(cgpa <= 2)) {
          val = !coursesNamesEntered.contains(course[0]);
        } else {
          val = coursesNamesEntered.contains(course[0]);
        }
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            val && !namesCoursesInSemest.contains(course[0])) {
          matches.add(course[0]);
        }
      }
    }
    matches = LinkedHashSet<String>.from(matches).toList();
    if (matches.isNotEmpty) {
      if (isQuery) {
        matches
            .retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      }
      return matches;
    }
    return ['There are no courses left'];
  }
}
