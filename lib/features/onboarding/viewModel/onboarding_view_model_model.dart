import 'package:flutter/material.dart';
import 'package:groceryapp/core/constants/images.dart';
import 'package:groceryapp/features/onboarding/model/onboarding_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  void setCurrentPage({required int page}) {
    _currentPage = page;
    notifyListeners();
  }

  List<OnboardingModel> onboardingModel = [
    OnboardingModel(
      image: AppImages.onBoardingImage1,
      title: "Buy Grocery",
      description:
          "Browse and shop fresh groceries anytime with just a few taps.",
    ),
    OnboardingModel(
      image: AppImages.onBoardingImage2,
      title: "Fast Delivery",
      description: "Get your orders delivered quickly right to your doorstep.",
    ),
    OnboardingModel(
      image: AppImages.onBoardingImage3,
      title: "Enjoy Quality Food",
      description:
          "Relax and enjoy fresh, high-quality meals prepared for you.",
    ),
  ];
}
