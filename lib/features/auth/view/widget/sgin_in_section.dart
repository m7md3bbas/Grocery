import 'package:flutter/material.dart';
import 'package:groceryapp/core/routes/app_router.dart';
import 'package:groceryapp/core/utils/constants/styles/app_color_styles.dart';
import 'package:groceryapp/core/utils/constants/styles/app_text_style.dart';
import 'package:groceryapp/core/utils/validation/auth/auth_validation.dart';
import 'package:groceryapp/core/widgets/textformfield/custom_textformfield.dart';
import 'package:groceryapp/core/widgets/toast/flutter_toast.dart';
import 'package:groceryapp/features/auth/view/widget/custom_remember_me.dart';
import 'package:go_router/go_router.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

class SginInSection extends StatefulWidget {
  const SginInSection({super.key});

  @override
  State<SginInSection> createState() => _SginInSectionState();
}

class _SginInSectionState extends State<SginInSection> {
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          autovalidateMode: autovalidateMode,
          key: formKey,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome back !",
                style: AppStyles.textBold25.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "Sign in to your account",
                style: AppStyles.textMedium15.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                validator: (value) => AuthValidation.validateEmail(value),
                textInputType: TextInputType.emailAddress,
                controller: email,
                hintText: "Email",
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.primary,
                ),
              ),

              CustomTextFormField(
                validator: (value) => AuthValidation.validatePassword(value),
                textInputType: TextInputType.visiblePassword,
                prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                controller: password,
                hintText: "Password",
                isObsecure: viewModel.isHidden,
                suffixIcon: IconButton(
                  onPressed: () => viewModel.togglePasswordVisiablity(),
                  icon: Icon(
                    viewModel.isHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility,
                    color: AppColors.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: AppStyles.textMedium15.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final result = await viewModel.login(
                      email: email.text,
                      password: password.text,
                    );
                    if (result) {
                      GoRouter.of(context).go(AppRouteName.home);
                    } else {
                      ShowToast.showError(viewModel.error);
                    }
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(
                        color: AppColors.background,
                      )
                    : Text(
                        "Sign up",
                        style: AppStyles.textMedium15.copyWith(
                          color: AppColors.background,
                        ),
                      ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ?",
                    style: AppStyles.textMedium15.copyWith(
                      color: AppColors.textlight,
                    ),
                  ),
                  TextButton(
                    onPressed: () => GoRouter.of(
                      context,
                    ).pushReplacement(AppRouteName.signUp),
                    child: Text(
                      "Sign Up",
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
