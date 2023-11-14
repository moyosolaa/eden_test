import 'dart:developer';

import 'package:ably_flutter/ably_flutter.dart' as ably;
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
  ably.RealtimeChannel? channel;
  String orderStatus = 'vvvv';

  Future<void> signInWithGoogle() async {
    state = state.copyWith(loading: true, loginState: LoginState.loggingIn);
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
      createAblyRealtimeInstance();
    } catch (error) {
      log(error.toString());
      state = state.copyWith(loading: false, loginState: LoginState.loggedOut);
    }
  }

  void createAblyRealtimeInstance() async {
    var clientOptions = ably.ClientOptions(
      key: 'oiDOrA.HnDEIw:_vcQQwIA8iy1HEPQVKTenBUnaC6LUY7VvueQ7993uZs',
      clientId: state.user!.user!.uid,
    );
    try {
      ably.Realtime realtime = ably.Realtime(options: clientOptions);
      channel = realtime.channels.get('order-status');
      subscribeToChatChannel();
      realtime.connection.on(ably.ConnectionEvent.connected).listen(
        (ably.ConnectionStateChange stateChange) async {
          print('Realtime connection state changed: ${stateChange.event}');
        },
      );
    } catch (error) {
      print('Error creating Ably Realtime Instance: $error');
      rethrow;
    }
  }

  void subscribeToChatChannel() {
    var messageStream = channel!.subscribe();
    messageStream.listen((ably.Message message) {
      orderStatus = message.name.toString();
      state = state.copyWith(value: orderStatus);
    });
  }

  // curl -X POST https://realtime.ably.io/channels/order-status/messages -u "oiDOrA.HnDEIw:_vcQQwIA8iy1HEPQVKTenBUnaC6LUY7VvueQ7993uZs" -H "Content-Type: application/json"  --data '{ "name": "xpendingnnnn" }'
}
