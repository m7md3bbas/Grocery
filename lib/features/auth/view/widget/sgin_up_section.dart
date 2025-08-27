import 'package:flutter/material.dart';
import 'package:groceryapp/core/routes/app_router.dart';
import 'package:groceryapp/core/styles/app_color_styles.dart';
import 'package:groceryapp/core/styles/app_text_style.dart';
import 'package:groceryapp/core/validation/auth/auth_validation.dart';
import 'package:groceryapp/core/widgets/textformfield/custom_textformfield.dart';
import 'package:go_router/go_router.dart';
import 'package:groceryapp/core/widgets/toast/flutter_toast.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

class SginUpSection extends StatefulWidget {
  const SginUpSection({super.key});

  @override
  State<SginUpSection> createState() => _SginUpSectionState();
}

class _SginUpSectionState extends State<SginUpSection> {
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
                "Create your account",
                style: AppStyles.textBold25.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "Easy and Fast",
                style: AppStyles.textMedium15.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                textInputType: TextInputType.emailAddress,
                controller: email,
                hintText: "Email",
                validator: (value) => AuthValidation.validateEmail(value),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.primary,
                ),
              ),
              CustomTextFormField(
                validator: (value) => AuthValidation.validatePhone(value),
                textInputType: TextInputType.phone,
                controller: phone,
                hintText: "phone",
                prefixIcon: Icon(Icons.phone, color: AppColors.primary),
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
                  icon: viewModel.isHidden
                      ? Icon(Icons.visibility_off_outlined)
                      : Icon(Icons.visibility),
                  color: AppColors.primary,
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
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final result = viewModel.register(
                      email: email.text,
                      phone: phone.text,
                      password: password.text,
                    );
                    result.then((value) {
                      if (value) {
                        GoRouter.of(context).go(AppRouteName.home);
                      } else {
                        ShowToast.showError(viewModel.error);
                      }
                    });
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                child: viewModel.isLoading
                    ? CircularProgressIndicator(color: AppColors.background)
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
                    style: AppStyles.textMedium15,
                  ),
                  TextButton(
                    onPressed: () => GoRouter.of(
                      context,
                    ).pushReplacement(AppRouteName.signIn),
                    child: Text(
                      "Sign in",
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
