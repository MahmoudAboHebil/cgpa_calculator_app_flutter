import 'package:cgp_calculator/online app/pages/home_with_firestore_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoursesService {
  static bool systemOption = false;
  static bool departmentOption = false;
  static String departmentName = '';
  static String divisionName = '';
  static List collegeRequirementsForTheNaturalSciences = [
    [
      'Calculus (1) and Geometry',
      '3',
      '040101101',
      [[], []]
    ],
    [
      'Calculus (2) and Algebra',
      '3',
      '040101102',
      [
        ['040101101'],
        []
      ]
    ],
    [
      'Mechanics (1)',
      '2',
      '040101151',
      [[], []]
    ],
    [
      'Mechanics (2)',
      '2',
      '040101152',
      [
        ['040101151'],
        []
      ]
    ],
    // [
    //   'Computer Programming and Applications',
    //   '2',
    //   '040102102',
    //   [[], []]
    // ],
    // [
    //   'General Physics (1)',
    //   '3',
    //   '040204101',
    //   [[], []]
    // ],
    // [
    //   'General Physics (2)',
    //   '3',
    //   '040204102',
    //   [[], []]
    // ],
    // [
    //   'General Chemistry (1)',
    //   '2',
    //   '040306101',
    //   [[], []]
    // ],
    // [
    //   'General Chemistry (2)',
    //   '2',
    //   '040306102',
    //   [[], []]
    // ],
    // [
    //   'General Chemistry Lab (1)',
    //   '1',
    //   '040306103',
    //   [[], []]
    // ],
    // [
    //   'General Chemistry Lab (2)',
    //   '1',
    //   '040306104',
    //   [[], []]
    // ],
    // [
    //   'General Chemistry (3)',
    //   '2',
    //   '040306106',
    //   [[], []]
    // ],
  ];
  static List universityRequirements = [
    ['مبادئ علم الفلسفة', '2'],
    ['الأنسان و البيئة', '2'],
    ['أساسيات الادارة', '2'],
    ['المحاسبة', '2'],
    ['مبادئ الصحة العامة', '2'],
    ['مقدمة فى علم الأثار', '2'],
    ['أخلاقيات المهنة', '2'],
    ['ادارة الذات', '2'],
    ['مبادئ علم النفس', '2'],
    ['تصميم وفنون جميلة', '2'],
    ['مدخل القانون', '2'],
    ['تاريخ علوم', '2'],
  ];
  static List mandatoryUniversityRequirements = [
    ['اللغة العربية', '2'],
    ['اللغة الانجليزية', '2'],
    ['الابتكار وريادة الأعمال', '2'],
    ['حقوق الإنسان', '2'],
  ];
  static List freeChoiceCourses = [
    ['أخلاقيات المهنة', '2'],
    ['السياحة البيئية', '2'],
    ['الجيولوجيا الأثرية', '2'],
  ];
  static List majorCS = [
    [
      'Introduction to Probability and Statistics',
      '2',
      '040102102',
      [[], []]
    ],
    [
      'Object Oriented Programming',
      '2',
      '040103201',
      [
        ['040102102'],
        ['040102102', '040103202']
      ]
    ],
    [
      'Data Structures and File Processing',
      '3',
      '040103202',
      [
        ['040103201'],
        []
      ]
    ],
    [
      'Discrete Structures',
      '2',
      '040103203',
      [[], []]
    ],
    [
      'Theory of Computation',
      '2',
      '040103204',
      [
        ['040103203'],
        []
      ]
    ],
    //
    [
      'Network and Internet Programming',
      '3',
      '040103205',
      [
        ['040102102'],
        []
      ]
    ],
    [
      'Advanced Programming',
      '3',
      '040103206',
      [
        ['040103201'],
        []
      ]
    ],
    [
      'Computer Programming (Practical)',
      '1',
      '040103207',
      [
        ['040103205', '040103201'],
        []
      ]
    ],
    [
      'Matrices',
      '2',
      '040101231',
      [[], []]
    ],
    [
      'Digital Logic Circuits',
      '3',
      '040103250',
      [[], []]
    ],

    //
  ];
  static List<String> divisions = [
    // 'Computer Science (Special) Alex ',
    'Natural Sciences Division  Alex',
  ];
  static List<String> departments = [
    'Computer Science (Special) Alex ',
  ];
  static List getDepartmentList() {
    if (departmentName == 'Computer Science (Special) Alex ') {
      return majorCS;
    }
    return [];
  }

  static List getDivisionList() {
    if (divisionName == 'Natural Sciences Division  Alex') {
      return collegeRequirementsForTheNaturalSciences;
    }
    return [];
  }

  static List<String> getCoursesNames() {
    List<String> names = [];
    for (List list in getDivisionList()) {
      names.add(list[0]);
    }
    for (List list in universityRequirements) {
      names.add(list[0]);
    }
    for (List list in mandatoryUniversityRequirements) {
      names.add(list[0]);
    }
    for (List list in freeChoiceCourses) {
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
    for (List course in universityRequirements) {
      if (course[0] == courseName) {
        credit = course[1];
        return credit;
      }
    }
    for (List course in mandatoryUniversityRequirements) {
      if (course[0] == courseName) {
        credit = course[1];
        return credit;
      }
    }
    for (List course in freeChoiceCourses) {
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
    if (eq(val1, coursesMustBeEnrolled)) {
      isValidMustCourses = true;
    } else {
      isValidMustCourses = false;
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
      for (List course in universityRequirements) {
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            !coursesNamesEntered.contains(course[0]) &&
                !namesCoursesInSemest.contains(course[0])) {
          matches.add(course[0]);
        }
      }
      for (List course in mandatoryUniversityRequirements) {
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            !coursesNamesEntered.contains(course[0]) &&
                !namesCoursesInSemest.contains(course[0])) {
          matches.add(course[0]);
        }
      }
      for (List course in freeChoiceCourses) {
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
