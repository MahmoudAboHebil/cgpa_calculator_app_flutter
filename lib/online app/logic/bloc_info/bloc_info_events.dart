import 'package:equatable/equatable.dart';

import '../../data/models/user_model/user_model_info.dart';

abstract class BlocInfoEvent extends Equatable {}

class LoadedInfoUserEvent extends BlocInfoEvent {
  @override
  List<Object> get props => [];
}

class UpdateInfoUserEvent extends BlocInfoEvent {
  final String? email;
  final String? name;
  final String? image;
  final String? division;
  final String? department;
  final bool? divisionOption;
  final bool? departmentOption;
  final UserModelInfo currentInfo;
  late UserModelInfo updatedInfo;
  UpdateInfoUserEvent({
    required this.currentInfo,
    this.name,
    this.email,
    this.image,
    this.division,
    this.department,
    this.divisionOption,
    this.departmentOption,
  }) {
    updatedInfo = UserModelInfo(
      name: name ?? currentInfo.name,
      email: email ?? currentInfo.email,
      image: image ?? currentInfo.image,
      division: division ?? currentInfo.division,
      department: department ?? currentInfo.department,
      divisionOption: divisionOption ?? currentInfo.divisionOption,
      departmentOption: departmentOption ?? currentInfo.departmentOption,
    );
  }
  @override
  List<Object?> get props => [
        name,
        email,
        image,
        division,
        department,
        departmentOption,
        divisionOption,
        currentInfo,
        updatedInfo,
      ];
}
