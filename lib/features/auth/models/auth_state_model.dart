import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool loading;
  final String? value;
  final LoginState loginState;
  final UserCredential? user;
  final OrderStatus? orderStatus;

  AuthState({
    this.value,
    this.loading = false,
    this.loginState = LoginState.loggedOut,
    this.user,
    this.orderStatus,
  });

  AuthState copyWith({
    bool? loading,
    LoginState? loginState,
    UserCredential? user,
    OrderStatus? orderStatus,
    String? value,
  }) {
    return AuthState(
      value: value ?? this.value,
      loading: loading ?? this.loading,
      loginState: loginState ?? this.loginState,
      user: user ?? this.user,
      orderStatus: orderStatus ?? this.orderStatus,
    );
  }
}

enum LoginState {
  loggedOut,
  loggingIn,
  loggedIn,
  loginError,
}

enum OrderStatus {
  orderPlaced,
  orderAccepted,
  orderPickUpInProgress,
  orderOnTheWayToCustomer,
  orderArrived,
  orderDelivered,
}
