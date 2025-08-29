import 'package:groceryapp/features/auth/view/auth_login.dart';
import 'package:groceryapp/features/auth/view/auth_register.dart';
import 'package:groceryapp/features/auth/view/auth_welcome.dart';
import 'package:groceryapp/features/auth/view/wrapper_auth.dart';
import 'package:groceryapp/features/home/view/home_view.dart';
import 'package:groceryapp/features/home/view/product_details.dart';
import 'package:groceryapp/features/onboarding/views/onboarding_view.dart';
import 'package:groceryapp/features/profile/view/profile_view.dart';
import 'package:go_router/go_router.dart';
import 'package:groceryapp/features/profile/view/about_me.dart';

class AppRouteName {
  static const initial = '/';
  static const onBoarding = '/onboarding';
  static const auth = '/auth';
  static const signUp = '/signUp';
  static const signIn = '/signIn';
  static const home = '/home';
  static const cart = '/cart';
  static const profile = '/profile';
  static const search = '/search';
  static const favorite = '/favorite';
  static const aboutMe = '/aboutMe';
  static const productDetails = '/productDetails';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRouteName.initial,
    routes: [
      GoRoute(
        path: AppRouteName.productDetails,
        builder: (context, state) => ProductDetailScreen(),
      ),
      GoRoute(
        path: AppRouteName.aboutMe,
        builder: (context, state) => const AboutMeScreen(),
      ),
      GoRoute(
        path: AppRouteName.initial,
        builder: (context, state) => const WrapperAuth(),
      ),
      GoRoute(
        path: AppRouteName.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(path: AppRouteName.home, builder: (context, state) => HomeView()),
      GoRoute(
        path: AppRouteName.signIn,
        builder: (context, state) => const SignIn(),
      ),
      GoRoute(
        path: AppRouteName.signUp,
        builder: (context, state) => const SignUp(),
      ),
      GoRoute(
        path: AppRouteName.onBoarding,
        builder: (context, state) => OnboardingView(),
      ),

      GoRoute(
        path: AppRouteName.auth,
        builder: (context, state) => const AuthWelcome(),
      ),
    ],
  );
}
