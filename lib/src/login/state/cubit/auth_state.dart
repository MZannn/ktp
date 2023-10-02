part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoginSuccess extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLoginFailed extends AuthState {}

final class AuthLogoutSuccess extends AuthState {}
