import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryapp/core/constants/images.dart';
import 'package:groceryapp/core/styles/app_color_styles.dart';
import 'package:groceryapp/features/auth/view/widget/sgin_up_section.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              AppImages.auth,
              fit: BoxFit.cover,
            ),
            SginUpSection(),
          ],
        ),
      ),
    );
  }
}
