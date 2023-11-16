import 'package:eden_test/features/orders/models/order_status_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool loading;
  final LoginState loginState;
  final UserCredential? user;

  AuthState({
    this.loading = false,
    this.loginState = LoginState.loggedOut,
    this.user,
  });

  AuthState copyWith({
    bool? loading,
    LoginState? loginState,
    UserCredential? user,
    OrderStatusEnum? orderStatus,
    DateTime? timestamp,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      loginState: loginState ?? this.loginState,
      user: user ?? this.user,
    );
  }
}

enum LoginState {
  loggedOut,
  loggingIn,
  loggedIn,
  loginError,
}
