import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groceryapp/core/routes/app_router.dart';
import 'package:groceryapp/core/styles/app_color_styles.dart';
import 'package:groceryapp/core/styles/app_text_style.dart';
import 'package:groceryapp/core/widgets/toast/flutter_toast.dart';
import 'package:groceryapp/features/auth/view/widget/custom_card_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome", style: AppStyles.textBold25),
          Text(
            "Please sign in to continue using our service",
            style: AppStyles.textMedium12,
          ),
          const SizedBox(height: 20),

          CustomCardAuth(
            onTap: () async {
              final result = await context
                  .read<AuthViewModel>()
                  .loginWithGoogle();
              if (result) {
                GoRouter.of(context).push(AppRouteName.home);
              } else {
                ShowToast.showError(context.read<AuthViewModel>().error);
              }
            },
            title: "Continue with Google",
            icon: FontAwesomeIcons.google,
            color: AppColors.background,
          ),
          CustomCardAuth(
            onTap: () => GoRouter.of(context).push(AppRouteName.signUp),
            title: "Create an account",
            icon: FontAwesomeIcons.user,
            color: AppColors.primary,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account ?", style: AppStyles.textMedium15),
              TextButton(
                onPressed: () => GoRouter.of(context).push(AppRouteName.signIn),
                child: Text(
                  "Sign In",
                  style: AppStyles.textMedium15.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
