import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:groceryapp/core/styles/app_text_style.dart';
import 'package:groceryapp/features/onboarding/model/onboarding_model.dart';

class OnboardingViewBody extends StatelessWidget {
  const OnboardingViewBody({super.key, required this.onboardingModel});
  final OnboardingModel onboardingModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            SvgPicture.asset(onboardingModel.image, height: 384, width: 384),
            Text(onboardingModel.title, style: AppStyles.textBold25),
            Text(onboardingModel.description, style: AppStyles.textMedium12),
          ],
        ),
      ),
    );
  }
}
