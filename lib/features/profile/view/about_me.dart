import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:groceryapp/core/styles/app_text_style.dart';
import 'package:groceryapp/core/validation/auth/auth_validation.dart';
import 'package:groceryapp/core/widgets/textformfield/custom_textformfield.dart';
import 'package:groceryapp/core/widgets/toast/flutter_toast.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/profile/viewmodel/profile_view_model.dart';
import 'package:provider/provider.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  void initState() {
    super.initState();
    final vm = context.read<ProfileViewModel>();
    _nameController.text = vm.user?.name ?? '';
    _emailController.text = vm.user?.email ?? '';
    _phoneController.text = vm.user?.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("About me"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => GoRouter.of(context).pop(),
            ),
          ),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async => vm.getProfile(userId: vm.user!.id),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      autovalidateMode: autovalidateMode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Personal Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomTextFormField(
                            controller: _nameController,
                            readOnly: !vm.isEditable,
                            textInputType: TextInputType.name,
                            hintText: "Name",
                            prefixIcon: const Icon(Icons.person),
                            validator: (value) =>
                                AuthValidation.validateName(value),
                          ),
                          const SizedBox(height: 12),
                          CustomTextFormField(
                            controller: _emailController,
                            readOnly: !vm.isEditable,
                            textInputType: TextInputType.emailAddress,
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: (value) =>
                                AuthValidation.validateEmail(value),
                          ),
                          const SizedBox(height: 12),
                          CustomTextFormField(
                            controller: _phoneController,
                            readOnly: !vm.isEditable,
                            textInputType: TextInputType.phone,
                            hintText: "Phone",
                            prefixIcon: const Icon(Icons.phone),
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                final phoneRegex = RegExp(r'^\d{11}$');
                                if (!phoneRegex.hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }

                                return null;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: vm.isEditable
                                ? ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        final provider = context
                                            .read<AuthViewModel>()
                                            .getCurrentUser()!
                                            .appMetadata["provider"];
                                        bool hasChanges = false;

                                        if (vm.user!.name !=
                                            _nameController.text) {
                                          if (provider == "email") {
                                            hasChanges = true;
                                            final result = await vm
                                                .updateProfile(
                                                  userId: vm.user!.id,
                                                  name: _nameController.text,
                                                );
                                            if (!result) {
                                              ShowToast.showError(vm.error);
                                              return;
                                            } else {
                                              ShowToast.showSuccess(
                                                "name updated successfully",
                                              );
                                            }
                                          } else {
                                            ShowToast.showError(
                                              "You are using $provider login, you can't change your name",
                                            );
                                          }
                                        }

                                        if (_emailController.text.isNotEmpty &&
                                            vm.user!.email !=
                                                _emailController.text) {
                                          if (provider == "email") {
                                            hasChanges = true;
                                            final result = await vm.updateEmail(
                                              email: _emailController.text,
                                            );

                                            if (!result) {
                                              ShowToast.showError(vm.error);
                                              return;
                                            } else {
                                              ShowToast.showSuccess(
                                                "Verification email sent successfully",
                                              );
                                            }
                                          } else {
                                            ShowToast.showError(
                                              "You are using $provider login, you can't change your email",
                                            );
                                          }
                                        }

                                        if (vm.user!.phone !=
                                            _phoneController.text) {
                                          hasChanges = true;
                                          final result = await vm.updateProfile(
                                            userId: vm.user!.id,
                                            phone: _phoneController.text,
                                          );
                                          if (!result) {
                                            ShowToast.showError(vm.error);
                                            return;
                                          } else {
                                            ShowToast.showSuccess(
                                              "phone updated successfully",
                                            );
                                          }
                                        }

                                        if (hasChanges) {
                                          await vm.getProfile(
                                            userId: vm.user!.id,
                                          );
                                          _emailController.text =
                                              vm.user!.email;
                                          vm.toggleEditable();
                                        } else {
                                          vm.toggleEditable();
                                        }
                                      } else {
                                        setState(() {
                                          autovalidateMode =
                                              AutovalidateMode.always;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightGreen,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: vm.isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Text(
                                            "Update",
                                            style: AppStyles.textBold15
                                                .copyWith(color: Colors.white),
                                          ),
                                  )
                                : ElevatedButton(
                                    onPressed: () => vm.toggleEditable(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: vm.isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Text(
                                            "Edit profile",
                                            style: AppStyles.textBold15
                                                .copyWith(color: Colors.white),
                                          ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
