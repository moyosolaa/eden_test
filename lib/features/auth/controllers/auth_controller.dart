import 'dart:developer';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:eden_test/features/auth/models/auth_state_model.dart';
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

  Future<bool> googleSignIn() async {
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
      await createAblyRealtimeInstance();
      return true;
    } catch (error) {
      log(error.toString());
      state = state.copyWith(loading: false, loginState: LoginState.loggedOut);
      return false;
    }
  }

  Future<bool> githubSignIn(BuildContext context) async {
    state = state.copyWith(loading: true, loginState: LoginState.loggingIn);
    try {
      final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: '507ba3bbe5e0e79808d0',
        clientSecret: '9946b66251452b145d29d71a6efca18dbf9a7a1d',
        redirectUrl: 'https://github.com/moyosolaa',
      );
      final GitHubSignInResult result = await gitHubSignIn.signIn(context);
      final AuthCredential credential = GithubAuthProvider.credential(result.token!);
      var user = await _auth.signInWithCredential(credential);
      state = state.copyWith(
        loading: false,
        user: user,
        loginState: LoginState.loggedIn,
      );
      await createAblyRealtimeInstance();
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
          orderStatus: OrderStatus.orderPlaced,
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

  Future<void> createAblyRealtimeInstance() async {
    var clientOptions = ably.ClientOptions(
      key: 'oiDOrA.HnDEIw:_vcQQwIA8iy1HEPQVKTenBUnaC6LUY7VvueQ7993uZs',
      clientId: state.user!.user!.uid,
    );
    try {
      ably.Realtime realtime = ably.Realtime(options: clientOptions);
      channel = realtime.channels.get('order-status');
      await subscribeToChannel();
      realtime.connection.on(ably.ConnectionEvent.connected).listen(
        (ably.ConnectionStateChange stateChange) async {
          log('Realtime connection state changed: ${stateChange.event}');
        },
      );
    } catch (error) {
      log('Error creating Ably Realtime Instance: $error');
      rethrow;
    }
  }

  Future<void> subscribeToChannel() async {
    var messageStream = channel!.subscribe();
    messageStream.listen((ably.Message message) {
      var orderStatus = OrderStatus.values.firstWhere((e) => message.name!.toLowerCase() == e.name.toLowerCase());
      var timestamp = message.timestamp;
      state = state.copyWith(orderStatus: orderStatus, timestamp: timestamp);
    });
  }

  int handleOrderStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.orderPlaced:
        log('Order Placed');
        return 0;
      case OrderStatus.orderAccepted:
        log('Order Accepted');
        return 1;
      case OrderStatus.orderPickUpInProgress:
        log('Pick Up In Progress');
        return 2;
      case OrderStatus.orderOnTheWayToCustomer:
        log('On the Way to Customer');
        return 3;
      case OrderStatus.orderArrived:
        log('Order Arrived');
        return 4;
      case OrderStatus.orderDelivered:
        log('Order Delivered');
        return 5;
      default:
        log('Unknown Order Status');
        return 0;
    }
  }

  // curl -X POST https://realtime.ably.io/channels/order-status/messages -u "oiDOrA.HnDEIw:_vcQQwIA8iy1HEPQVKTenBUnaC6LUY7VvueQ7993uZs" -H "Content-Type: application/json"  --data '{ "name": "xpendingnnnn" }'
}
