import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthServer extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? gUser;

  Future googleLogin() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;
    gUser = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();
  }

  Future googleLogout() async {
    if (gUser != null) {
      await googleSignIn.disconnect();
    }
    FirebaseAuth.instance.signOut();
    gUser = null;
    notifyListeners();
  }
}
