import 'package:flutter/material.dart';
import 'package:groceryapp/core/routes/app_router.dart';
import 'package:groceryapp/core/utils/constants/styles/app_color_styles.dart';
import 'package:groceryapp/core/utils/constants/styles/app_text_style.dart';
import 'package:groceryapp/features/onboarding/viewModel/onboarding_view_model_model.dart';
import 'package:groceryapp/features/onboarding/views/onboarding_first_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingViewModel>(
      builder: (context, ref, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (page) => ref.setCurrentPage(page: page),
                  controller: controller,
                  itemCount: ref.onboardingModel.length,
                  itemBuilder: (context, index) {
                    return OnboardingViewBody(
                      onboardingModel: ref.onboardingModel[index],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).go(AppRouteName.auth),
                    child: Text(
                      "Skip",
                      style: AppStyles.textMedium15.copyWith(
                        color: AppColors.textlight,
                      ),
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      ref.onboardingModel.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: ref.currentPage == index
                                ? AppColors.primary
                                : AppColors.textGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: ref.currentPage == index ? 20 : 10,
                          height: 10,
                        ),
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      if (ref.currentPage == ref.onboardingModel.length - 1) {
                        GoRouter.of(context).go(AppRouteName.auth);
                      } else {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      ref.currentPage == ref.onboardingModel.length - 1
                          ? "Done"
                          : "Next",
                      style: AppStyles.textMedium15.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
