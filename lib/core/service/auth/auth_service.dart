import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groceryapp/core/utils/sharedpreference.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../error/failure.dart';

abstract class AuthService {
  Future<void> login({required String email, required String password});
  Future<void> loginWithGoogle();
  Future<void> register({
    required String email,
    required String phone,
    required String password,
  });
  Future<void> logout();
  User? get currentUser;
  Session? get currentSession;
}

class AuthServiceImp implements AuthService {
  final SupabaseClient supabaseClient;

  AuthServiceImp({required this.supabaseClient});

  @override
  User? get currentUser => supabaseClient.auth.currentUser;
  @override
  Session? get currentSession => supabaseClient.auth.currentSession;
  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final session = supabaseClient.auth.currentSession;
      await SharedpreferenceHelper().setString("token", session!.accessToken);
      if (response.user == null) {
        throw Failure("Invalid email or password");
      }
    } on AuthException catch (e) {
      throw Failure(e.message);
    } catch (_) {
      throw Failure("Unexpected login error. Please try again.");
    }
  }

  @override
  Future<void> register({
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'phone': phone},
      );

      if (response.user == null) {
        throw Failure("Registration failed. Try again.");
      }
    } on AuthException catch (e) {
      throw Failure(e.message);
    } catch (e) {
      throw Failure("Unexpected registration error.");
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (_) {
      throw Failure("Failed to logout. Try again.");
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    GoogleSignInAccount? googleUser;

    final webClientId = dotenv.env['GoogleClintID']!;

    const iosClientId = 'my-ios.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Google Sign In was cancelled';
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    try {
      await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on AuthException catch (e) {
      throw Failure(e.message);
    }
  }
}
