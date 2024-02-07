import 'package:cgp_calculator/online%20app/data/firebase_services/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firebase_services/user_info_service/user_info_service.dart';
import '../../models/user_model/user_model_info.dart';

class UserInfoRepo {
  final _userInfoService = UserInfoService();

  Future<Stream<UserModelInfo>> getUserInfo(String email) async {
    CollectionReference cr =
        await _userInfoService.getUserInfoCollection(email);
    return cr.snapshots().map((snapshot) {
      return snapshot.docs
          .map((snap) => UserModelInfo.fromSnapshot(snap))
          .toList()
          .first;
    });
  }

  Future<void> updateUserInfo(UserModelInfo userModelInfo) async {
    try {
      DocumentReference dr =
          await _userInfoService.getUserInfoDocument(userModelInfo.email);
      return dr.update(userModelInfo.toDocument());
    } catch (e) {
      DocumentReference dr =
          await _userInfoService.getUserInfoDocument(userModelInfo.email);
      return dr.set(userModelInfo.toDocument());
    }
  }
}
