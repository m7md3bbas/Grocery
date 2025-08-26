import 'package:groceryapp/core/service/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepo {
  final AuthService authService;
  AuthRepo({required this.authService});

  Future<void> login({required String email, required String password}) =>
      authService.login(email: email, password: password);
  Future<void> loginWithGoogle() => authService.loginWithGoogle();
  Future<void> register({
    required String email,
    required String phone,
    required String password,
  }) => authService.register(email: email, phone: phone, password: password);

  Future<void> logout() => authService.logout();
  User? get currentUser => authService.currentUser;
  Session? get currentSession => authService.currentSession;
}
