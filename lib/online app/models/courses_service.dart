import 'package:cgp_calculator/online app/pages/home_with_firestore_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllCourses {
  static List universityRequirements = [
    [' متطلب جامعة _ مبادئ علم الفلسفة', '2'],
    [' متطلب جامعة _ الأنسان و البيئة', '2'],
    [' متطلب جامعة _ أساسيات الادارة', '2'],
    [' متطلب جامعة _ المحاسبة', '2'],
    [' متطلب جامعة _ مبادئ الصحة العامة', '2'],
    [' متطلب جامعة _ مقدمة فى علم الأثار', '2'],
    [' متطلب جامعة _ أخلاقيات المهنة', '2'],
    [' متطلب جامعة _ ادارة الذات', '2'],
    [' متطلب جامعة _ مبادئ علم النفس', '2'],
    [' متطلب جامعة _ تصميم وفنون جميلة', '2'],
    [' متطلب جامعة _ مدخل القانون', '2'],
    [' متطلب جامعة _ تاريخ علوم', '2'],
  ];
  static List mandatoryUniversityRequirements = [
    [' متطلب جامعة _ اللغة العربية', '2'],
    [' متطلب جامعة _ اللغة الانجليزية', '2'],
    [' متطلب جامعة _ الابتكار وريادة الأعمال', '2'],
    [' متطلب جامعة _ حقوق الإنسان', '2'],
  ];
  static List freeChoiceCourses = [
    [' إختيار حر _ أخلاقيات المهنة', '2'],
    [' إختيار حر _ السياحة البيئية', '2'],
    [' إختيار حر _ الجيولوجيا الأثرية', '2'],
  ];
  static List collegeRequirementsForTheNaturalSciences = [
    AllCourses.calculus_1_andGeometry,
    AllCourses.calculus_2_andAlgebra,
    // AllCourses.mechanics_1,
    // AllCourses.mechanics_2,
    // AllCourses.computerProgrammingAndApplications,
    // AllCourses.generalPhysics_1,
    // AllCourses.generalPhysics_2,
    // AllCourses.generalChemistry_1,
    // AllCourses.generalChemistry_2,
    // AllCourses.generalChemistry_Lab_1,
    // AllCourses.generalChemistry_Lab_2,
    // AllCourses.generalChemistry_3,
  ];
  static List addMajorString(List course, bool isMandatoryCourse) {
    String courseName = course[0];
    String newName = '';
    if (isMandatoryCourse) {
      newName = '$courseName رئيسى إجبارى _ ';
    } else {
      newName = '$courseName رئيسى إختيارى _ ';
    }
    List newCourse = [newName, course[1], course[2], course[3]];
    return newCourse;
  }

  static List addMinorString(List course, bool isMandatoryCourse) {
    String courseName = course[0];
    String newName = '';
    if (isMandatoryCourse) {
      newName = '$courseName فرعى إجبارى _ ';
    } else {
      newName = '$courseName فرعى إختيارى _ ';
    }
    List newCourse = [newName, course[1], course[2], course[3]];
    return newCourse;
  }

  static List mandatoryMajorCS = [
    addMajorString(AllCourses.introductionToProbabilityAndStatistics, true),
    addMajorString(AllCourses.objectOrientedProgramming, true),
    addMajorString(AllCourses.dataStructuresAndFileProcessing, true),
    addMajorString(AllCourses.discreteStructures, true),
    addMajorString(AllCourses.theoryOfComputation, true),
    addMajorString(AllCourses.networkAndInternetProgramming, true),
    addMajorString(AllCourses.advancedProgramming, true),
    addMajorString(AllCourses.computerProgramming_Practical, true),
    addMajorString(AllCourses.matrices, true),
    addMajorString(AllCourses.digitalLogicCircuits, true),
    addMajorString(AllCourses.operatingSystems, true),
    addMajorString(AllCourses.databaseManagementSystems, true),
    addMajorString(AllCourses.artificialIntelligence, true),
    addMajorString(AllCourses.computerGraphics, true),
    addMajorString(AllCourses.computingAlgorithms, true),
    addMajorString(AllCourses.systemProgramming, true),
    addMajorString(AllCourses.computerNetwork, true),
    addMajorString(AllCourses.researchProject_CS, true),
  ];
  static List electiveMajorCS = [
    addMajorString(AllCourses.ordinaryDifferentialEquations, false),
    addMajorString(AllCourses.mathematicalLogic_1, false),
    addMajorString(AllCourses.theoryOfNumbers, false),
    addMajorString(AllCourses.introductionToInformationSystems, false),
    addMajorString(AllCourses.introductionToSoftwareEngineering, false),
    addMajorString(AllCourses.conceptsOfProgrammingLanguages, false),
    addMajorString(AllCourses.human_ComputerInteraction, false),
    addMajorString(AllCourses.mathematicalAnalysis, false),
    addMajorString(AllCourses.computerArchitecturalAndOrganization, false),
    addMajorString(AllCourses.onlineMultimediaAndInformationAccess, false),
    addMajorString(AllCourses.intelligentMachines, false),
    addMajorString(AllCourses.algorithmsInBioinformatics, false),
    addMajorString(AllCourses.intermediateSoftwareDesignAndEngineering, false),
    addMajorString(AllCourses.softwareTestingAndQuality, false),
    addMajorString(AllCourses.objectOrientedDesign, false),
    addMajorString(AllCourses.numericalMethods, false),
    addMajorString(AllCourses.systemSimulationAndModeling, false),
    addMajorString(AllCourses.distributedAndParallelSystems, false),
    addMajorString(AllCourses.informationStorageAndRetrieval, false),
    addMajorString(AllCourses.computerAndInformationSecurity, false),
    addMajorString(AllCourses.advancedComputerNetworks, false),
    addMajorString(AllCourses.digitalLibraries, false),
    addMajorString(AllCourses.digitalImageProcessing, false),
    addMajorString(AllCourses.selectedTopicsInComputer, false),
  ];
  static final List calculus_1_andGeometry = [
    'Calculus (1) and Geometry _ متطلب كلية ',
    '3',
    '040101101',
    [[], []]
  ];
  static final List calculus_2_andAlgebra = [
    'Calculus (2) and Algebra _ متطلب كلية ',
    '3',
    '040101102',
    [
      ['040101101'],
      []
    ]
  ];
  static final List mechanics_1 = [
    'Mechanics (1) _ متطلب كلية ',
    '2',
    '040101151',
    [[], []]
  ];
  static final List mechanics_2 = [
    'Mechanics (2) _ متطلب كلية ',
    '2',
    '040101152',
    [
      ['040101151'],
      []
    ]
  ];
  static final List computerProgrammingAndApplications = [
    'Computer Programming and Applications _ متطلب كلية ',
    '2',
    '040102102',
    [[], []]
  ];
  static final List generalPhysics_1 = [
    'General Physics (1) _ متطلب كلية ',
    '3',
    '040204101',
    [[], []]
  ];
  static final List generalPhysics_2 = [
    'General Physics (2) _ متطلب كلية ',
    '3',
    '040204102',
    [[], []]
  ];
  static final List generalChemistry_1 = [
    'General Chemistry (1) _ متطلب كلية ',
    '2',
    '040306101',
    [[], []]
  ];
  static final List generalChemistry_2 = [
    'General Chemistry (2) _ متطلب كلية ',
    '2',
    '040306102',
    [[], []]
  ];
  static final List generalChemistry_Lab_1 = [
    'General Chemistry Lab (1) _ متطلب كلية ',
    '1',
    '040306103',
    [[], []]
  ];
  static final List generalChemistry_Lab_2 = [
    'General Chemistry Lab (2) _ متطلب كلية ',
    '1',
    '040306104',
    [[], []]
  ];
  static final List generalChemistry_3 = [
    'General Chemistry (3) _ متطلب كلية ',
    '2',
    '040306106',
    [[], []]
  ];
  //################################################################
  static final List introductionToProbabilityAndStatistics = [
    'Introduction to Probability and Statistics',
    '2',
    '040102102',
    [
      [],
      ['040101101', '040101111']
    ]
  ];
  static final List objectOrientedProgramming = [
    'Object Oriented Programming',
    '2',
    '040103201',
    [
      ['040102102'],
      []
    ]
  ];
  static final List dataStructuresAndFileProcessing = [
    'Data Structures and File Processing',
    '3',
    '040103202',
    [
      ['040103201'],
      []
    ]
  ];
  static final List discreteStructures = [
    'Discrete Structures',
    '2',
    '040103203',
    [[], []]
  ];
  static final List theoryOfComputation = [
    'Theory of Computation',
    '2',
    '040103204',
    [
      ['040103203'],
      []
    ]
  ];
  static final List networkAndInternetProgramming = [
    'Network and Internet Programming',
    '3',
    '040103205',
    [
      ['040102102'],
      []
    ]
  ];
  static final List advancedProgramming = [
    'Advanced Programming',
    '3',
    '040103206',
    [
      ['040103201'],
      []
    ]
  ];
  static final List computerProgramming_Practical = [
    'Computer Programming (Practical)',
    '1',
    '040103207',
    [
      ['040103205', '040103201'],
      []
    ]
  ];
  static final List matrices = [
    'Matrices',
    '2',
    '040101231',
    [[], []]
  ];

  static final List digitalLogicCircuits = [
    'Digital Logic Circuits',
    '3',
    '040103250',
    [[], []]
  ];
  static final List operatingSystems = [
    'Operating Systems',
    '3',
    '040103301',
    [
      ['040103202'],
      []
    ]
  ];

  static final List databaseManagementSystems = [
    'DatabaseManagement Systems',
    '3',
    '040103302',
    [
      ['040103202'],
      []
    ]
  ];
  static final List artificialIntelligence = [
    'Artificial Intelligence',
    '3',
    '040103303',
    [
      ['040103203'],
      []
    ]
  ];
  static final List computerGraphics = [
    'Computer Graphics',
    '3',
    '040103304',
    [
      ['040103201'],
      []
    ]
  ];
  static final List computingAlgorithms = [
    'Computing Algorithms',
    '3',
    '040103305',
    [
      ['040103204'],
      []
    ]
  ];
  static final List systemProgramming = [
    'System Programming',
    '3',
    '040103306',
    [
      ['040103201'],
      []
    ]
  ];
  static final List computerNetwork = [
    'Computer Network',
    '3',
    '040103401',
    [
      ['040103301'],
      []
    ]
  ];
  static final List researchProject_CS = [
    'Research Project (CS)',
    '2',
    '040103490',
    [
      ['4'],
      []
    ]
  ];
  static final List ordinaryDifferentialEquations = [
    'Ordinary Differential Equations',
    '3',
    '040101204',
    [
      ['040101102'],
      []
    ]
  ];
  static final List mathematicalLogic_1 = [
    'Mathematical Logic (1)',
    '2',
    '040101205',
    [[], []]
  ];
  static final List theoryOfNumbers = [
    'Theory of Numbers',
    '2',
    '040101206',
    [[], []]
  ];
  static final List introductionToInformationSystems = [
    'Introduction to Information Systems',
    '3',
    '040103208',
    [[], []]
  ];
  static final List introductionToSoftwareEngineering = [
    'Introduction to Software Engineering',
    '2',
    '040103209',
    [
      ['040103201'],
      []
    ]
  ];
  static final List conceptsOfProgrammingLanguages = [
    'Concepts of Programming Languages',
    '3',
    '040103210',
    [
      ['040103201'],
      []
    ]
  ];
  static final List human_ComputerInteraction = [
    'Human-Computer Interaction',
    '2',
    '040103211',
    [
      ['040103102'],
      []
    ]
  ];
  static final List mathematicalAnalysis = [
    'Mathematical Analysis',
    '3',
    '040101232',
    [
      [],
      ['040101102', '040101111']
    ]
  ];
  static final List computerArchitecturalAndOrganization = [
    'Computer Architectural and Organization',
    '3',
    '040103307',
    [
      ['040103250'],
      []
    ]
  ];
  static final List onlineMultimediaAndInformationAccess = [
    'Online Multimedia and Information Access',
    '3',
    '040103308',
    [
      ['040103205'],
      []
    ]
  ];
  static final List intelligentMachines = [
    'Intelligent Machines',
    '3',
    '040103309',
    [
      ['040103303'],
      []
    ]
  ];
  static final List algorithmsInBioinformatics = [
    'Algorithms in Bioinformatics',
    '3',
    '040103310',
    [
      ['040103305'],
      []
    ]
  ];
  static final List intermediateSoftwareDesignAndEngineering = [
    'Intermediate Software Design and Engineering',
    '3',
    '040103311',
    [
      ['040103209'],
      []
    ]
  ];
  static final List softwareTestingAndQuality = [
    'Software Testing and Quality',
    '3',
    '040103312',
    [
      ['040103209'],
      []
    ]
  ];
  static final List objectOrientedDesign = [
    'ObjectOriented Design',
    '3',
    '040103313',
    [
      ['040103209'],
      []
    ]
  ];
  static final List numericalMethods = [
    'Numerical Methods',
    '3',
    '040101333',
    [
      ['040101231'],
      []
    ]
  ];
  static final List systemSimulationAndModeling = [
    'System Simulation and Modeling',
    '3',
    '040103402',
    [
      ['040103305'],
      []
    ]
  ];
  static final List distributedAndParallelSystems = [
    'Distributed and Parallel Systems',
    '3',
    '040103403',
    [
      ['040103304'],
      []
    ]
  ];
  static final List informationStorageAndRetrieval = [
    'Information Storage and Retrieval',
    '3',
    '040103404',
    [
      ['040103202'],
      []
    ]
  ];
  static final List computerAndInformationSecurity = [
    'Computer and Information Security',
    '3',
    '040103405',
    [
      ['040103301'],
      []
    ]
  ];
  static final List advancedComputerNetworks = [
    'Advanced Computer Networks',
    '3',
    '040103406',
    [
      ['040103401'],
      []
    ]
  ];
  static final List digitalLibraries = [
    'Digital Libraries',
    '3',
    '040103407',
    [
      ['040103302'],
      []
    ]
  ];
  static final List digitalImageProcessing = [
    'Digital Image Processing',
    '3',
    '040103408',
    [
      ['040103304'],
      []
    ]
  ];
  static final List selectedTopicsInComputer = [
    'Selected Topics in Computer',
    '3',
    '040103420',
    [
      ['4'],
      []
    ]
  ];
}

class CoursesService {
  static bool systemOption = false;
  static bool departmentOption = false;
  static String departmentName = '';
  static String divisionName = '';

  static List minor = [];

  static List<String> divisions = [
    // 'Computer Science (Special) Alex ',
    'Natural Sciences Division  Alex',
  ];
  static List<String> departments = [
    'Computer Science (Special) Alex ',
  ];
  static List getDepartmentList() {
    List list = [];
    if (departmentName == 'Computer Science (Special) Alex ') {
      for (List lt1 in AllCourses.mandatoryMajorCS) {
        list.add(lt1);
      }
      for (List lt2 in AllCourses.electiveMajorCS) {
        list.add(lt2);
      }
      return list;
    }

    return [];
  }

  static List getDivisionList() {
    if (divisionName == 'Natural Sciences Division  Alex') {
      return AllCourses.collegeRequirementsForTheNaturalSciences;
    }
    return [];
  }

  static List<String> getCoursesNames() {
    List<String> names = [];
    for (List list in getDivisionList()) {
      names.add(list[0]);
    }
    for (List list in AllCourses.universityRequirements) {
      names.add(list[0]);
    }
    for (List list in AllCourses.mandatoryUniversityRequirements) {
      names.add(list[0]);
    }
    for (List list in AllCourses.freeChoiceCourses) {
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
    for (List course in AllCourses.universityRequirements) {
      if (course[0] == courseName) {
        credit = course[1];
        return credit;
      }
    }
    for (List course in AllCourses.mandatoryUniversityRequirements) {
      if (course[0] == courseName) {
        credit = course[1];
        return credit;
      }
    }
    for (List course in AllCourses.freeChoiceCourses) {
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
      for (List course in AllCourses.universityRequirements) {
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            !coursesNamesEntered.contains(course[0]) &&
                !namesCoursesInSemest.contains(course[0])) {
          matches.add(course[0]);
        }
      }
      for (List course in AllCourses.mandatoryUniversityRequirements) {
        if (

            ///  TODO: in the next line you will not allow the user to improve their grade .
            !coursesNamesEntered.contains(course[0]) &&
                !namesCoursesInSemest.contains(course[0])) {
          matches.add(course[0]);
        }
      }
      for (List course in AllCourses.freeChoiceCourses) {
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
