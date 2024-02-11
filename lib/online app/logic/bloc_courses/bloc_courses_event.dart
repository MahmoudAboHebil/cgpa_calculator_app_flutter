import 'package:equatable/equatable.dart';

abstract class BlocCoursesEvent extends Equatable {}

class LoadedCoursesEvent extends BlocCoursesEvent {
  final String semesterId;
  LoadedCoursesEvent({required this.semesterId});
  @override
  List<Object> get props => [semesterId];
}
