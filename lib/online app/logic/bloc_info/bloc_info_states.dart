import 'package:cgp_calculator/online%20app/data/models/user_model/user_model_info.dart';
import 'package:equatable/equatable.dart';

abstract class BlocInfoState extends Equatable {}

class BlocInfoLoading extends BlocInfoState {
  @override
  List<Object> get props => [];
}

class BlocInfoLoaded extends BlocInfoState {
  final UserModelInfo userModelInfo;
  BlocInfoLoaded({required this.userModelInfo});
  @override
  List<Object> get props => [userModelInfo];
}

class BlocInfoUpdate extends BlocInfoState {
  @override
  List<Object> get props => [];
}

class BlocInfoError extends BlocInfoState {
  final String error;
  BlocInfoError({required this.error});
  @override
  List<Object> get props => [error];
}
