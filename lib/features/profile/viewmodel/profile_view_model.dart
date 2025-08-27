import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groceryapp/core/utils/error/failure.dart';
import 'package:groceryapp/core/repos/profile/profile_repo.dart';
import 'package:groceryapp/core/service/auth/auth_service.dart';
import 'package:groceryapp/core/utils/dependancy_injection.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepo profileRepo;

  ProfileViewModel({required this.profileRepo}) {
    getProfile(userId: locator<AuthService>().currentUser!.id);
  }

  bool isLoading = false;
  bool _isProfileLoading = false;
  bool get isProfileLoading => _isProfileLoading;
  String error = '';
  bool _isEditable = false;
  bool get isEditable => _isEditable;
  UserProfile? user;

  void toggleEditable() {
    _isEditable = !_isEditable;
    notifyListeners();
  }

  File? image;

  Future<bool> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return false;

      image = File(pickedFile.path);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateEmail({required String email}) async {
    _setLoading(true);
    try {
      await profileRepo.updateEmail(email: email);
      _setSuccess();
      return true;
    } on Failure catch (e) {
      _setError(e.errorMessage);
      return false;
    }
  }

  Future<bool> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? email,
  }) async {
    _setLoading(true);
    try {
      await profileRepo.updateProfile(
        userProfile: user!,
        name: name,
        phone: phone,
        email: email,
      );

      _setSuccess();
      return true;
    } on Failure catch (e) {
      _setError(e.errorMessage);
      return false;
    }
  }

  Future<bool> uploadProfileImg({required String userId}) async {
    if (image == null) {
      _setError("No image selected");
      return false;
    }
    _isProfileLoading = true;
    try {
      await profileRepo.uploadProfileImg(userId: userId, img: image!);
      _isProfileLoading = false;
      _setSuccess();
      notifyListeners();
      return true;
    } on Failure catch (e) {
      _setError(e.errorMessage);
      return false;
    }
  }

  Future<void> getProfile({required String userId}) async {
    try {
      user = await profileRepo.getProfile(userId: userId);
      print(user?.image);
      _setSuccess();
    } on Failure catch (e) {
      _setError(e.errorMessage);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setSuccess() {
    isLoading = false;
    error = '';
    notifyListeners();
  }

  void _setError(String message) {
    isLoading = false;
    error = message;
    notifyListeners();
  }
}
