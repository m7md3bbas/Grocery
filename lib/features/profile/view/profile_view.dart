import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groceryapp/core/routes/app_router.dart';
import 'package:groceryapp/core/styles/app_color_styles.dart';
import 'package:groceryapp/core/widgets/toast/flutter_toast.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/profile/viewmodel/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    context.read<ProfileViewModel>().getProfile(
      userId: context.read<AuthViewModel>().getCurrentUser()!.id,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) => SafeArea(
          child: RefreshIndicator(
            color: Colors.green,
            onRefresh: () async => context.read<ProfileViewModel>().getProfile(
              userId: context.read<AuthViewModel>().getCurrentUser()!.id,
            ),
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (viewModel.user?.image != null &&
                                        viewModel.user!.image.isNotEmpty) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => Scaffold(
                                            backgroundColor: Colors.black,
                                            body: PhotoView(
                                              filterQuality: FilterQuality.high,
                                              minScale: PhotoViewComputedScale
                                                  .contained,
                                              maxScale: PhotoViewComputedScale
                                                  .contained,
                                              imageProvider:
                                                  CachedNetworkImageProvider(
                                                    viewModel.user!.image,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      final picked = await viewModel
                                          .pickImage();
                                      if (picked) {
                                        final result = await viewModel
                                            .uploadProfileImg(
                                              userId: context
                                                  .read<AuthViewModel>()
                                                  .getCurrentUser()!
                                                  .id,
                                            );
                                        if (result) {
                                          ShowToast.showSuccess(
                                            "Image uploaded successfully",
                                          );
                                        } else {
                                          ShowToast.showError(
                                            "Failed to upload image",
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: viewModel.isProfileLoading
                                      ? CircularProgressIndicator(
                                          color: AppColors.primaryDark,
                                        )
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.grey.shade300,
                                          backgroundImage:
                                              viewModel.user?.image != null &&
                                                  viewModel
                                                      .user!
                                                      .image
                                                      .isNotEmpty
                                              ? NetworkImage(
                                                  viewModel.user!.image,
                                                )
                                              : null,
                                          child:
                                              (viewModel.user?.image == null ||
                                                  viewModel.user!.image.isEmpty)
                                              ? const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 40,
                                                )
                                              : null,
                                        ),
                                ),

                                GestureDetector(
                                  onTap: () async {
                                    final picked = await viewModel.pickImage();
                                    if (picked) {
                                      final result = await viewModel
                                          .uploadProfileImg(
                                            userId: context
                                                .read<AuthViewModel>()
                                                .getCurrentUser()!
                                                .id,
                                          );
                                      if (result) {
                                        viewModel.getProfile(
                                          userId: context
                                              .read<AuthViewModel>()
                                              .getCurrentUser()!
                                              .id,
                                        );
                                        ShowToast.showSuccess(
                                          "Image uploaded successfully",
                                        );
                                      } else {
                                        print(viewModel.error);
                                        ShowToast.showError(
                                          "Failed to upload image",
                                        );
                                      }
                                    }
                                  },

                                  child: viewModel.isProfileLoading
                                      ? SizedBox.shrink()
                                      : CircleAvatar(
                                          radius: 16,
                                          backgroundColor:
                                              AppColors.primaryDark,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              viewModel.user?.name ?? "",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              viewModel.user?.email ?? "",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            _buildMenuItem(
                              Icons.person_outline,
                              "About me",
                              () => GoRouter.of(
                                context,
                              ).push(AppRouteName.aboutMe),
                            ),
                            _buildMenuItem(
                              Icons.shopping_bag_outlined,
                              "My Orders",
                              () {},
                            ),
                            _buildMenuItem(
                              Icons.favorite_border,
                              "My Favorites",
                              () {},
                            ),
                            _buildMenuItem(
                              Icons.location_on_outlined,
                              "My Address",
                              () {},
                            ),
                            _buildMenuItem(
                              Icons.credit_card,
                              "Credit Cards",
                              () {},
                            ),
                            _buildMenuItem(
                              Icons.swap_horiz,
                              "Transactions",
                              () {},
                            ),
                            _buildMenuItem(
                              Icons.notifications_outlined,
                              "Notifications",
                              () {},
                            ),
                            Consumer<AuthViewModel>(
                              builder: (context, viewModel, _) =>
                                  _buildMenuItem(
                                    Icons.logout,
                                    "Sign out",
                                    () async {
                                      final currentUser = context
                                          .read<AuthViewModel>()
                                          .getCurrentUser();

                                      if (currentUser
                                              ?.appMetadata['provider'] ==
                                          'google') {
                                        await GoogleSignIn().signOut();
                                      }

                                      await viewModel.logout();
                                      GoRouter.of(
                                        context,
                                      ).go(AppRouteName.initial);
                                    },
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.primary,
      ),
      onTap: onTap,
    );
  }
}
