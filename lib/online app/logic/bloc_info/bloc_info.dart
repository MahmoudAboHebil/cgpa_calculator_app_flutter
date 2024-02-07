import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info_events.dart';
import 'package:cgp_calculator/online%20app/logic/bloc_info/bloc_info_states.dart';

import '../../data/models/user_model/user_model_info.dart';
import '../../data/repository/user_info_repo/user_info_repo.dart';

class BlocInfo extends Bloc<BlocInfoEvent, BlocInfoState> {
  final UserInfoRepo userInfoRepo;
  final String email;
  late StreamSubscription _streamSubscription;
  BlocInfo({required this.userInfoRepo, required this.email})
      : super(BlocInfoLoading()) {
    on<LoadedInfoUserEvent>((event, emit) async {
      emit(BlocInfoLoading());
      try {
        await _mapLoadedEventToLoadedState();
      } catch (e) {
        emit(BlocInfoError(error: e.toString()));
      }
    });
  }

  Future<StreamSubscription<UserModelInfo>>
      _mapLoadedEventToLoadedState() async {
    Stream<UserModelInfo> stream = await userInfoRepo.getUserInfo(email);
    return _streamSubscription = stream.listen((userModelInfo) {
      emit(BlocInfoLoaded(userModelInfo: userModelInfo));
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<BlocInfoState> change) {
    print(change);
    super.onChange(change);
  }
}
