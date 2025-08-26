import 'package:flutter/material.dart';
import 'package:groceryapp/core/routes/app_router.dart';
import 'package:groceryapp/core/utils/dependancy_injection.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:groceryapp/features/onboarding/viewModel/onboarding_view_model_model.dart';
import 'package:groceryapp/features/profile/viewmodel/profile_view_model.dart';
import 'package:provider/provider.dart';

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => locator<AuthViewModel>()),
        ChangeNotifierProvider(
          create: (context) => locator<OnboardingViewModel>(),
        ),
        ChangeNotifierProvider(create: (context) => locator<HomeViewModel>()),
        ChangeNotifierProvider(
          create: (context) => locator<ProfileViewModel>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
