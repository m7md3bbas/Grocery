import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryapp/core/constants/images.dart';
import 'package:groceryapp/core/styles/app_color_styles.dart';
import 'package:groceryapp/core/widgets/dismissKeyboard.dart';
import 'package:groceryapp/features/auth/view/widget/sgin_in_section.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
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
              SginInSection(),
            ],
          ),
        ),
      ),
    );
  }
}
