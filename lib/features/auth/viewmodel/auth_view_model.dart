import 'package:flutter/material.dart';
import 'package:groceryapp/core/utils/error/failure.dart';
import 'package:groceryapp/core/repos/auth/authrepo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus { authenticated, unauthenticated, initial }

class AuthViewModel extends ChangeNotifier {
  final AuthRepo authRepo;
  AuthViewModel({required this.authRepo}) {
    checkCurrentSession();
  }

  bool isLoading = false;

  bool _isHidden = true;
  bool get isHidden => _isHidden;

  void togglePasswordVisiablity() {
    _isHidden = !_isHidden;
    notifyListeners();
  }

  String error = '';
  AuthStatus authStatus = AuthStatus.initial;
  void checkCurrentSession() {
    final session = authRepo.authService.currentSession;
    if (session != null) {
      authStatus = AuthStatus.authenticated;
      notifyListeners();
    } else {
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  User? getCurrentUser() => authRepo.authService.currentUser;
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      await authRepo.login(email: email, password: password);
      authStatus = AuthStatus.authenticated;
      _setSuccess();
      return true;
    } on Failure catch (f) {
      _setError(f.errorMessage);
    } catch (_) {
      _setError("Unexpected error occurred.");
    }
    return false;
  }

  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    try {
      await authRepo.loginWithGoogle();
      authStatus = AuthStatus.authenticated;
      _setSuccess();
      return true;
    } on Failure catch (f) {
      _setError(f.errorMessage);
    } catch (_) {
      _setError("Unexpected error occurred.");
    }
    return false;
  }

  Future<bool> register({
    required String email,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await authRepo.register(email: email, phone: phone, password: password);
      _setSuccess();
      authStatus = AuthStatus.authenticated;
      return true;
    } on Failure catch (f) {
      _setError(f.errorMessage);
    } catch (_) {
      _setError("Unexpected error occurred.");
    }
    return false;
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await authRepo.logout();
      authStatus = AuthStatus.unauthenticated;
      _setSuccess();
    } on Failure catch (f) {
      _setError(f.errorMessage);
    } catch (_) {
      _setError("Unexpected error occurred.");
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setSuccess() {
    isLoading = false;
    error = '';
    notifyListeners();
  }

  void _setError(String message) {
    isLoading = false;
    error = message;
    notifyListeners();
  }
}
