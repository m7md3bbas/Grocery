import 'dart:io';

import 'package:groceryapp/core/service/profile/profile_service.dart';
import 'package:groceryapp/features/profile/model/user_model.dart';

class ProfileRepo {
  final ProfileService profileService;
  ProfileRepo({required this.profileService});

  Future<UserProfile> getProfile({required String userId}) async {
    return profileService.getProfile(userId: userId);
  }

  Future<void> updateProfile({
    required UserProfile userProfile,
    String? name,
    String? phone,
    String? email,
  }) async {
    return profileService.updateProfile(
      oldUser: userProfile,
      name: name,
      phone: phone,
      email: email,
    );
  }

  Future<void> uploadProfileImg({
    required String userId,
    required File img,
  }) async {
    return profileService.uploadProfileImg(userId: userId, img: img);
  }

  Future<void> updateEmail({required String email}) async {
    return profileService.updateEmail(email: email);
  }
}
