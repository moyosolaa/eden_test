import 'dart:developer';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:eden_test/features/auth/models/auth_state_model.dart';
import 'package:eden_test/features/orders/controllers/order_controller.dart';
import 'package:eden_test/features/orders/models/order_status_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  ably.RealtimeChannel? channel;

  Future<bool> googleSignIn(WidgetRef? ref) async {
    state = state.copyWith(loading: true, loginState: LoginState.loggingIn);
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
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
      await ref!.watch(orderProvider.notifier).createAblyRealtimeInstance(ref);
      return true;
    } catch (error) {
      log(error.toString());
      state = state.copyWith(loading: false, loginState: LoginState.loggedOut);
      return false;
    }
  }

  Future<bool> githubSignIn(BuildContext context, WidgetRef? ref) async {
    state = state.copyWith(loading: true, loginState: LoginState.loggingIn);
    try {
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: '507ba3bbe5e0e79808d0',
        clientSecret: '9946b66251452b145d29d71a6efca18dbf9a7a1d',
        redirectUrl: 'https://eden-eab1d.firebaseapp.com/__/auth/handler',
      );
      final GitHubSignInResult result = await gitHubSignIn.signIn(context);
      final AuthCredential credential = GithubAuthProvider.credential(result.token!);
      var user = await _auth.signInWithCredential(credential);
      state = state.copyWith(
        loading: false,
        user: user,
        loginState: LoginState.loggedIn,
      );
      await ref!.watch(orderProvider.notifier).createAblyRealtimeInstance(ref);
      return true;
    } catch (error) {
      log(error.toString());
      state = state.copyWith(loading: false, loginState: LoginState.loggedOut);
      return false;
    }
  }

  Future<bool> googleSignout() async {
    state = state.copyWith(loading: true, loginState: LoginState.loggingIn);
    try {
      await Future.delayed(const Duration(seconds: 1), () async {
        await _googleSignIn.signOut();
        await _auth.signOut();
        state = state.copyWith(
          loading: false,
          user: null,
          loginState: LoginState.loggedOut,
          orderStatus: OrderStatusEnum.orderPlaced,
          timestamp: null,
        );
      });
      return true;
    } catch (error) {
      log(error.toString());
      state = state.copyWith(loading: false, loginState: LoginState.loggedIn);
      return false;
    }
  }
}
