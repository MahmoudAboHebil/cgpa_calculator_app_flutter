import 'package:equatable/equatable.dart';

import '../../data/models/user_model/user_model.dart';

abstract class BlocUserState extends Equatable {}

class LoadingUser extends BlocUserState {
  @override
  List<Object> get props => [];
}

class LoadedUser extends BlocUserState {
  final UserModel user;
  LoadedUser({required this.user});
  @override
  List<Object> get props => [user];
}

class ErrorUser extends BlocUserState {
  final String err;
  ErrorUser({required this.err});
  @override
  List<Object> get props => [err];
}
