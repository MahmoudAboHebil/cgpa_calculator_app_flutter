import 'common_department_courses.dart';

class ComputerScience {
  List addMajorString(List course, bool isMandatoryCourse) {
    String courseName = course[0];
    String newName = '';
    String nickDpName = '';
    if (isMandatoryCourse) {
      newName = '$courseName _ رئيسى إجبارى';
      nickDpName = 'Major-Mandatory';
    } else {
      newName = '$courseName _ رئيسى إختيارى';
      nickDpName = 'Major-Elective';
    }
    List newCourse = [
      newName,
      course[1],
      course[2],
      course[3],
      courseName,
      nickDpName
    ];
    return newCourse;
  }

  List addMinorString(List course, bool isMandatoryCourse) {
    String courseName = course[0];
    String newName = '';
    String nickDpName = '';
    if (isMandatoryCourse) {
      newName = '$courseName _ فرعى إجبارى';
      nickDpName = 'Minor-Mandatory';
    } else {
      newName = '$courseName _ فرعى إختيارى';
      nickDpName = 'Minor-Elective';
    }
    List newCourse = [
      newName,
      course[1],
      course[2],
      course[3],
      courseName,
      nickDpName
    ];
    return newCourse;
  }

  List mandatoryMajorCS() {
    CommonDPCourses commonDPCourses = CommonDPCourses();

    return [
      addMajorString(
          commonDPCourses.introductionToProbabilityAndStatistics, true),
      addMajorString(objectOrientedProgramming, true),
      addMajorString(dataStructuresAndFileProcessing, true),
      addMajorString(discreteStructures, true),
      addMajorString(theoryOfComputation, true),
      addMajorString(networkAndInternetProgramming, true),
      addMajorString(advancedProgramming, true),
      addMajorString(computerProgramming_Practical, true),
      addMajorString(commonDPCourses.matrices, true),

      // addMajorString(CommonDPCourses.linearAlgebra, true),
      addMajorString(digitalLogicCircuits, true),
      addMajorString(operatingSystems, true),
      addMajorString(databaseManagementSystems, true),
      addMajorString(artificialIntelligence, true),
      addMajorString(computerGraphics, true),
      addMajorString(computingAlgorithms, true),
      addMajorString(systemProgramming, true),
      addMajorString(computerNetwork, true),
      addMajorString(researchProject_CS, true),
    ];
  }

  List electiveMajorCS() {
    CommonDPCourses commonDPCourses = CommonDPCourses();
    return [
      addMajorString(ordinaryDifferentialEquations, false),
      addMajorString(mathematicalLogic_1, false),
      addMajorString(theoryOfNumbers, false),
      addMajorString(introductionToInformationSystems, false),
      addMajorString(introductionToSoftwareEngineering, false),
      addMajorString(conceptsOfProgrammingLanguages, false),
      addMajorString(human_ComputerInteraction, false),
      addMajorString(commonDPCourses.mathematicalAnalysis, false),
      addMajorString(computerArchitecturalAndOrganization, false),
      addMajorString(onlineMultimediaAndInformationAccess, false),
      addMajorString(intelligentMachines, false),
      addMajorString(algorithmsInBioinformatics, false),
      addMajorString(intermediateSoftwareDesignAndEngineering, false),
      addMajorString(softwareTestingAndQuality, false),
      addMajorString(objectOrientedDesign, false),
      addMajorString(commonDPCourses.numericalMethods, false),
      addMajorString(systemSimulationAndModeling, false),
      addMajorString(distributedAndParallelSystems, false),
      addMajorString(informationStorageAndRetrieval, false),
      addMajorString(computerAndInformationSecurity, false),
      addMajorString(advancedComputerNetworks, false),
      addMajorString(digitalLibraries, false),
      addMajorString(digitalImageProcessing, false),
      addMajorString(selectedTopicsInComputer, false),
    ];
  }

  final List objectOrientedProgramming = [
    'Object Oriented Programming',
    '2',
    '040103201',
    [
      ['040103102'],
      []
    ]
  ];
  final List dataStructuresAndFileProcessing = [
    'Data Structures and File Processing',
    '3',
    '040103202',
    [
      ['040103201'],
      []
    ]
  ];
  final List discreteStructures = [
    'Discrete Structures',
    '2',
    '040103203',
    [[], []]
  ];
  final List theoryOfComputation = [
    'Theory of Computation',
    '2',
    '040103204',
    [
      ['040103203'],
      []
    ]
  ];
  final List networkAndInternetProgramming = [
    'Network and Internet Programming',
    '3',
    '040103205',
    [
      ['040103102'],
      []
    ]
  ];
  final List advancedProgramming = [
    'Advanced Programming',
    '3',
    '040103206',
    [
      ['040103201'],
      []
    ]
  ];
  final List computerProgramming_Practical = [
    'Computer Programming (Practical)',
    '1',
    '040103207',
    [
      ['040103205', '040103201', 'm'],
      []
    ]
  ];

  final List digitalLogicCircuits = [
    'Digital Logic Circuits',
    // '3', not in reality
    '2',
    '040103250',
    [[], []]
  ];
  final List operatingSystems = [
    'Operating Systems',
    '3',
    '040103301',
    [
      ['040103202'],
      []
    ]
  ];

  final List databaseManagementSystems = [
    'DatabaseManagement Systems',
    '3',
    '040103302',
    [
      ['040103202'],
      []
    ]
  ];
  final List artificialIntelligence = [
    'Artificial Intelligence',
    '3',
    '040103303',
    [
      ['040103203'],
      []
    ]
  ];
  final List computerGraphics = [
    'Computer Graphics',
    '3',
    '040103304',
    [
      ['040103201'],
      []
    ]
  ];
  final List computingAlgorithms = [
    'Computing Algorithms',
    '3',
    '040103305',
    [
      ['040103204'],
      []
    ]
  ];
  final List systemProgramming = [
    'System Programming',
    '3',
    '040103306',
    [
      ['040103201'],
      []
    ]
  ];
  final List computerNetwork = [
    'Computer Network',
    '3',
    '040103401',
    [
      ['040103301'],
      []
    ]
  ];
  final List researchProject_CS = [
    'Research Project (CS)',
    '2',
    '040103490',
    [
      ['Four'],
      []
    ]
  ];
  final List ordinaryDifferentialEquations = [
    'Ordinary Differential Equations',
    // '3', not in  reality
    '2',
    '040101204',
    [
      ['040101102'],
      []
    ]
  ];
  final List mathematicalLogic_1 = [
    'Mathematical Logic (1)',
    '2',
    '040101205',
    [[], []]
  ];
  final List theoryOfNumbers = [
    'Theory of Numbers',
    '2',
    '040101206',
    [[], []]
  ];
  final List introductionToInformationSystems = [
    'Introduction to Information Systems',
    '3',
    '040103208',
    [[], []]
  ];
  final List introductionToSoftwareEngineering = [
    'Introduction to Software Engineering',
    '2',
    '040103209',
    [
      ['040103201'],
      []
    ]
  ];
  final List conceptsOfProgrammingLanguages = [
    'Concepts of Programming Languages',
    '3',
    '040103210',
    [
      ['040103201'],
      []
    ]
  ];
  final List human_ComputerInteraction = [
    'Human-Computer Interaction',
    '2',
    '040103211',
    [
      [
        '040103102',
        // '040102102'
      ],
      []
    ]
  ];

  final List computerArchitecturalAndOrganization = [
    'Computer Architectural and Organization',
    '3',
    '040103307',
    [
      ['040103250'],
      []
    ]
  ];
  final List onlineMultimediaAndInformationAccess = [
    'Online Multimedia and Information Access',
    '3',
    '040103308',
    [
      ['040103205'],
      []
    ]
  ];
  final List intelligentMachines = [
    'Intelligent Machines',
    '3',
    '040103309',
    [
      ['040103303'],
      []
    ]
  ];
  final List algorithmsInBioinformatics = [
    'Algorithms in Bioinformatics',
    '3',
    '040103310',
    [
      ['040103305'],
      []
    ]
  ];
  final List intermediateSoftwareDesignAndEngineering = [
    'Intermediate Software Design and Engineering',
    '3',
    '040103311',
    [
      ['040103209'],
      []
    ]
  ];
  final List softwareTestingAndQuality = [
    'Software Testing and Quality',
    '3',
    '040103312',
    [
      ['040103209'],
      []
    ]
  ];
  final List objectOrientedDesign = [
    'ObjectOriented Design',
    '3',
    '040103313',
    [
      ['040103209'],
      []
    ]
  ];

  final List systemSimulationAndModeling = [
    'System Simulation and Modeling',
    '3',
    '040103402',
    [
      ['040103305'],
      []
    ]
  ];
  final List distributedAndParallelSystems = [
    'Distributed and Parallel Systems',
    '3',
    '040103403',
    [
      ['040103304'],
      []
    ]
  ];
  final List informationStorageAndRetrieval = [
    'Information Storage and Retrieval',
    '3',
    '040103404',
    [
      ['040103202'],
      []
    ]
  ];
  final List computerAndInformationSecurity = [
    'Computer and Information Security',
    '3',
    '040103405',
    [
      ['040103301'],
      []
    ]
  ];
  final List advancedComputerNetworks = [
    'Advanced Computer Networks',
    '3',
    '040103406',
    [
      ['040103401'],
      []
    ]
  ];
  final List digitalLibraries = [
    'Digital Libraries',
    '3',
    '040103407',
    [
      ['040103302'],
      []
    ]
  ];
  final List digitalImageProcessing = [
    'Digital Image Processing',
    '3',
    '040103408',
    [
      ['040103304'],
      []
    ]
  ];
  final List selectedTopicsInComputer = [
    'Selected Topics in Computer',
    '3',
    '040103420',
    [
      ['Four'],
      []
    ]
  ];
}
