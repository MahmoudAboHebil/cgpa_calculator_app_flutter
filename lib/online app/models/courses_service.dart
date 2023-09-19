import 'dart:collection';

import 'package:cgp_calculator/online app/pages/home_with_firestore_page.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/computer_science.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/free_choice_courses.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/natural_sciences_division.dart';
import 'package:cgp_calculator/online%20app/collage_courses_data/statistics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../collage_courses_data/university_requirement_courses.dart';

class CoursesService {
  static bool systemOption = false;
  static bool departmentOption = false;
  static String departmentName = '';
  static String divisionName = '';

  static List<String> divisions = [
    // 'Computer Science (Special) Alex ',

    'Natural Sciences Division  Alex',
  ];
  static List<String> departments = ['Computer Science and Statistics (Alex)'];
  static List getDivisionList() {
    if (divisionName == 'Natural Sciences Division  Alex') {
      return NaturalSciences.collegeRequirementsCourses;
    }
    return [];
  }

  static List returnListWithoutRepeatCourses(
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

  static List getDepartmentList() {
    List list = [];
    if (departmentName == 'Computer Science and Statistics (Alex)') {
      List l1 = returnListWithoutRepeatCourses(
          ComputerScience.mandatoryMajorCS, Statistics.mandatoryMinorStat);

      List l2 = returnListWithoutRepeatCourses(
          ComputerScience.electiveMajorCS, Statistics.electiveMinorStat);

      List l3 = returnListWithoutRepeatCourses(l1, l2);

      return l3;
    }

    return [];
  }

  static List<String> getCoursesNames() {
    List<String> names = [];
    for (List list in getDivisionList()) {
      names.add(list[0]);
    }
    for (List list in UniversityRequirement.universityRequirementsCourses) {
      names.add(list[0]);
    }

    for (List list in FreeChoice.freeChoiceCourses) {
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
    String credit = '';
    for (List course in getDivisionList()) {
      if (course[0] == courseName) {
        credit = course[1];
        return credit;
      }
    }
    for (List course in UniversityRequirement.universityRequirementsCourses) {
      if (course[0] == courseName) {
        credit = course[1];
        return credit;
      }
    }

    for (List course in FreeChoice.freeChoiceCourses) {
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

  static bool isGlobalDepartmentValidationOK() {
    List<bool> val = [true];
    List<List> validCourse = [];
    List<List> collegeRequirements = [];
    for (List course in CoursesService.getDivisionList()) {
      collegeRequirements.add([course[0], course[1]]);
    }
    for (List semester in allSemesters) {
      for (List course in semester) {
        if (course[1] != null && course[2] != null && course[3] != null) {
          if (course[3] != 'U' &&
              course[3] != 'F' &&
              course[3] != 'Non' &&
              course[4] == null) {
            validCourse.add([course[1], course[2]]);
          } else if (course[4] != null &&
              course[1] != null &&
              course[2] != null &&
              course[4] != 'U' &&
              course[4] != 'F' &&
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

    return !val.contains(false);
  }

  static bool courseEnrollingSystem(String courseName, int semestId) {
    Function eq = const ListEquality().equals;

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

    for (List semester in allSemesters) {
      for (List course in semester) {
        if (course[0] < semestId) {
          if (course[1] != null && course[3] != null) {
            if (course[3] != 'U' &&
                course[3] != 'F' &&
                course[3] != 'Non' &&
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
    if (coursesMustOneBeEnrolled.isNotEmpty) {
      for (List semester in allSemesters) {
        for (List course in semester) {
          if (course[0] < semestId) {
            if (course[1] != null && course[3] != null) {
              if (course[3] != 'U' &&
                  course[3] != 'F' &&
                  course[3] != 'Non' &&
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

    if (departmentOption) {
      List<String> departCoursesNames = [];
      for (List list in getDepartmentList()) {
        departCoursesNames.add(list[0]);
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
    if (coursesMustBeEnrolled.contains('4')) {
      if (earnCredit >= 100) {
        coursesMustBeEnrolled.remove('4');
        if (!eq(val1, coursesMustBeEnrolled)) {
          isValidMustCourses = false;
        }
      } else {
        isValidMustCourses = false;
      }
    } else {
      if (!eq(val1, coursesMustBeEnrolled)) {
        isValidMustCourses = false;
      }
    }
    return isValidMustCourses && isValidOneCourses && isValidDp;
  }

  static List<String> getSuggestions(
      String query, List listInSemester, int semestId) {
    List<String> matches = <String>[];
    if (systemOption) {
      // avoiding repeating course in the list
      List<String> coursesNamesEntered = [];
      for (List semester in allSemesters) {
        for (List course in semester) {
          if (course[1] != null && course[3] != null) {
            if (course[3] != 'U' &&
                course[3] != 'F' &&
                course[3] != 'Non' &&
                course[4] == null) {
              coursesNamesEntered.add(course[1]);
            } else if (course[4] != null &&
                course[4] != 'U' &&
                course[4] != 'F' &&
                course[4] != 'Non') {
              coursesNamesEntered.add(course[1]);
            }
          }
        }
      }

      List<String> namesCoursesInSemest = [];
      for (List course in listInSemester) {
        if (course[1] != null) {
          namesCoursesInSemest.add(course[1]);
        }
      }

      for (List course in getDivisionList()) {
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            !coursesNamesEntered.contains(course[0]) &&
                !namesCoursesInSemest.contains(course[0]) &&
                courseEnrollingSystem(course[0], semestId)) {
          matches.add(course[0]);
        }
      }
      if (departmentOption) {
        for (List course in getDepartmentList()) {
          if (

              ///  TODO: in the next line you will not allow the user to improve their grade .
              !coursesNamesEntered.contains(course[0]) &&
                  !namesCoursesInSemest.contains(course[0]) &&
                  courseEnrollingSystem(course[0], semestId)) {
            matches.add(course[0]);
          }
        }
      }
      for (List course in UniversityRequirement.universityRequirementsCourses) {
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            !coursesNamesEntered.contains(course[0]) &&
                !namesCoursesInSemest.contains(course[0])) {
          matches.add(course[0]);
        }
      }

      for (List course in FreeChoice.freeChoiceCourses) {
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            !coursesNamesEntered.contains(course[0]) &&
                !namesCoursesInSemest.contains(course[0])) {
          matches.add(course[0]);
        }
      }
    }

    if (matches.isNotEmpty) {
      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
      return matches;
    }
    return ['There are no courses left'];
  }
}
