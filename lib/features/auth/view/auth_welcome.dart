import 'package:flutter/material.dart';
import 'package:groceryapp/core/constants/images.dart';
import 'package:groceryapp/core/styles/app_color_styles.dart';
import 'package:groceryapp/features/auth/view/widget/welcome_section.dart';

class AuthWelcome extends StatelessWidget {
  const AuthWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          Image.asset(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            AppImages.auth,
            fit: BoxFit.cover,
          ),
          WelcomeSection(),
        ],
      ),
    );
  }
}
