import 'common_department_courses.dart';

class Statistics {
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

  List mandatoryMajorStat() {
    CommonDPCourses commonDPCourses = CommonDPCourses();

    return [
      addMajorString(
          commonDPCourses.introductionToProbabilityAndStatistics, true),
      addMajorString(statisticalMethods, true),
      addMajorString(regressionAnalysis, true),
      addMajorString(theoryOfStatistics_1, true),
      addMajorString(commonDPCourses.matrices, true),
      addMajorString(commonDPCourses.mathematicalAnalysis, true),
      addMajorString(non_parametricStatistics, true),
      addMajorString(simulationAndSamplingTechniques, true),
      addMajorString(theoryOfStatistics_2, true),
      addMajorString(multivariateStatisticalAnalysis, true),
      addMajorString(timeSeriesAnalysis, true),
      addMajorString(statisticalComputing, true),
      addMajorString(operationsResearch_1, true),
      addMajorString(linearStatisticalModels, true),
      addMajorString(stochasticProcesses, true),
      addMajorString(operationResearch_2, true),
      addMajorString(researchProject_statistics, true),
    ];
  }

  List mandatoryMinorStat() {
    CommonDPCourses commonDPCourses = CommonDPCourses();

    return [
      addMinorString(
          commonDPCourses.introductionToProbabilityAndStatistics, true),
      addMinorString(statisticalMethods, true),
      addMinorString(regressionAnalysis, true),
      addMinorString(non_parametricStatistics, true),
      addMinorString(multivariateStatisticalAnalysis, true),
      addMinorString(statisticalComputing, true),
    ];
  }

  List electiveMinorStat() {
    CommonDPCourses commonDPCourses = CommonDPCourses();

    return [
      addMinorString(statisticalQualityControl, false),
      addMinorString(analysisOfCategoricalData, false),
      addMinorString(differenceEquations, false),
      addMinorString(differentialEquationsAndTransformations, false),
      addMinorString(commonDPCourses.numericalMethods, false),
      addMinorString(dataMining, false),
      addMinorString(life_TestingAndReliability, false),
      addMinorString(orderStatistics, false),
      addMinorString(theoryOfProbability, false),
      addMinorString(researchMethodsInBusiness, false),
      addMinorString(projectManagement, false),
      addMinorString(selectedTopicsInStatistics, false),
      //###########################
      // stat major courses
      addMinorString(
          commonDPCourses.introductionToProbabilityAndStatistics, false),
      addMinorString(statisticalMethods, false),
      addMinorString(regressionAnalysis, false),
      addMinorString(theoryOfStatistics_1, false),
      addMinorString(commonDPCourses.matrices, false),
      addMinorString(commonDPCourses.mathematicalAnalysis, false),
      addMinorString(non_parametricStatistics, false),
      addMinorString(simulationAndSamplingTechniques, false),
      addMinorString(theoryOfStatistics_2, false),
      addMinorString(multivariateStatisticalAnalysis, false),
      addMinorString(timeSeriesAnalysis, false),
      addMinorString(statisticalComputing, false),
      addMinorString(operationsResearch_1, false),
      addMinorString(linearStatisticalModels, false),
      addMinorString(stochasticProcesses, false),
      addMinorString(operationResearch_2, false),
      addMinorString(researchProject_statistics, false)
    ];
  }

  final List statisticalMethods = [
    'Statistical Methods',
    '3',
    '040102201',
    [
      ['040102102'],
      []
    ]
  ];
  final List regressionAnalysis = [
    'Regression Analysis',
    '3',
    '040102202',
    [
      [],
      ['040101231', '040102201']
    ]
  ];
  final List non_parametricStatistics = [
    'Non-parametric Statistics',
    '2',
    '040102301',
    [
      ['040102201'],
      []
    ]
  ];
  final List multivariateStatisticalAnalysis = [
    'Multivariate Statistical Analysis',
    '3',
    '040102304',
    [
      [],
      ['040101231', '040102201']
    ]
  ];
  final List statisticalComputing = [
    'Statistical Computing',
    '3',
    '040102306',
    [
      ['040102201'],
      []
    ]
  ];
  final List theoryOfStatistics_1 = [
    'Theory of Statistics (1)',
    '3',
    '040102203',
    [
      ['040102102'],
      []
    ]
  ];
  final List simulationAndSamplingTechniques = [
    'Simulation and Sampling techniques',
    '3',
    '040102302',
    [
      ['040102201'],
      []
    ]
  ];
  final List theoryOfStatistics_2 = [
    'Theory of Statistics (2)',
    '3',
    '040102303',
    [
      ['040102203'],
      []
    ]
  ];
  final List timeSeriesAnalysis = [
    'Time Series Analysis',
    '3',
    '040102305',
    [
      ['040102201'],
      []
    ]
  ];
  final List operationsResearch_1 = [
    'Operation Research (1)',
    '3',
    '040102308',
    [
      [],
      ['040101203', '040101231']
    ]
  ];
  final List linearStatisticalModels = [
    'Linear Statistical Models',
    '3',
    '040102401',
    [
      ['040102201'],
      []
    ]
  ];
  final List stochasticProcesses = [
    'Stochastic Processes',
    '2',
    '040102402',
    [
      ['040102203'],
      []
    ]
  ];
  final List operationResearch_2 = [
    'Operation Research (2)',
    '3',
    '040102403',
    [
      ['040101308'],
      []
    ]
  ];
  final List researchProject_statistics = [
    'Research Project (Statistics)',
    '2',
    '040102490',
    [
      ['Four'],
      []
    ]
  ];
  final List statisticalQualityControl = [
    'Statistical Quality Control',
    '2',
    '040102307',
    [
      ['040102201'],
      []
    ]
  ];
  final List analysisOfCategoricalData = [
    'Analysis of categorical data',
    '3',
    '040102308',
    [
      ['040102201'],
      []
    ]
  ];
  final List differenceEquations = [
    'Difference Equations',
    '2',
    '040101311',
    [
      [],
      ['040101305', '040101333']
    ]
  ];
  final List differentialEquationsAndTransformations = [
    'Differential Equations and Transformations',
    '3',
    '040101331',
    [
      ['040101232'],
      []
    ]
  ];
  final List dataMining = [
    'Data Mining',
    '3',
    '040102404',
    [
      ['040102201'],
      []
    ]
  ];
  final List life_TestingAndReliability = [
    'Life-Testing and Reliability',
    '3',
    '040102405',
    [
      ['040102203'],
      []
    ]
  ];
  final List orderStatistics = [
    'Order Statistics',
    '2',
    '040102406',
    [
      ['040102301'],
      []
    ]
  ];
  final List theoryOfProbability = [
    'Theory of Probability',
    '3',
    '040102407',
    [
      ['040102203'],
      []
    ]
  ];
  final List researchMethodsInBusiness = [
    'Research Methods in Business',
    '3',
    '040102408',
    [
      ['040102201'],
      []
    ]
  ];
  final List projectManagement = [
    'Project Management',
    '3',
    '040102409',
    [
      ['040102201'],
      []
    ]
  ];
  final List selectedTopicsInStatistics = [
    'Selected Topics in Statistics',
    '3',
    '040102410',
    [
      ['Four'],
      []
    ]
  ];
}
