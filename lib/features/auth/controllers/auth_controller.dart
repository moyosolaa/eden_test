import 'dart:developer';

import 'package:eden_test/features/auth/models/auth_state_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseAuth.instance.authStateChanges(),

  Future<void> signInWithGoogle() async {
    state = state.copyWith(loading: true);
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      var user = await _auth.signInWithCredential(credential);
      state = state.copyWith(
        loading: false,
        user: user,
        loginState: LoginState.loggedIn,
      );
    } catch (error) {
      log(error.toString());
      state = state.copyWith(loading: false);
    }
  }
}
