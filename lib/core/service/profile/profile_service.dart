import 'dart:io';

import 'package:groceryapp/core/service/dio/base_class.dart';
import 'package:groceryapp/core/error/failure.dart';
import 'package:groceryapp/features/profile/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final DioBaseClient dio;
  final SupabaseClient supabaseClient;

  ProfileService({required this.dio, required this.supabaseClient});

  Future<UserProfile> getProfile({required String userId}) async {
    try {
      final response = await dio.get(
        url: 'users_profile',
        data: {'id': 'eq.$userId', 'select': '*'},
      );

      if (response.data != null &&
          response.data is List &&
          (response.data as List).isNotEmpty) {
        return UserProfile.fromMap(response.data[0]);
      } else {
        throw Failure('User not found');
      }
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Future<void> updateProfile({
    required UserProfile oldUser,
    String? name,
    String? phone,
    String? email,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (name != null && name.isNotEmpty && name != oldUser.name) {
        data['name'] = name;
      }
      if (phone != null && phone.isNotEmpty && phone != oldUser.phone) {
        data['phone'] = phone;
      }
      if (email != null && email.isNotEmpty && email != oldUser.email) {
        data['email'] = email;
      }

      if (data.isEmpty) return;
      await dio.patch(
        url: 'users_profile',
        data: data,
        queryParameters: {'id': 'eq.${oldUser.id}'},
      );
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Future<void> uploadProfileImg({
    required String userId,
    required File img,
  }) async {
    try {
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      await supabaseClient.storage
          .from('profile_images')
          .upload(
            '$userId/$fileName',
            img,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final imageUrl = supabaseClient.storage
          .from('profile_images')
          .getPublicUrl('$userId/$fileName');
      await supabaseClient
          .from('users_profile')
          .update({'profile_url': imageUrl})
          .eq('id', userId);
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Future<void> updateEmail({required String email}) async {
    try {
      await supabaseClient.auth.updateUser(UserAttributes(email: email));
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
