import 'package:equatable/equatable.dart';

abstract class BlocInfoEvent extends Equatable {}

class LoadedInfoUserEvent extends BlocInfoEvent {
  @override
  List<Object> get props => [];
}
