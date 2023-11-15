import 'package:eden_test/features/auth/models/order_status_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool loading;
  final LoginState loginState;
  final UserCredential? user;
  final OrderStatus orderStatus;
  final DateTime? timestamp;

  AuthState({
    this.loading = false,
    this.loginState = LoginState.loggedOut,
    this.user,
    this.orderStatus = OrderStatus.orderPlaced,
    this.timestamp,
  });

  AuthState copyWith({
    bool? loading,
    LoginState? loginState,
    UserCredential? user,
    OrderStatus? orderStatus,
    DateTime? timestamp,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      loginState: loginState ?? this.loginState,
      user: user ?? this.user,
      orderStatus: orderStatus ?? this.orderStatus,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

enum LoginState {
  loggedOut,
  loggingIn,
  loggedIn,
  loginError,
}
