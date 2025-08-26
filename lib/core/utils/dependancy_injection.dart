import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:groceryapp/core/repos/auth/authrepo.dart';
import 'package:groceryapp/core/repos/profile/profile_repo.dart';
import 'package:groceryapp/core/service/auth/auth_service.dart';
import 'package:groceryapp/core/service/dio/base_class.dart';
import 'package:groceryapp/core/service/profile/profile_service.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:groceryapp/features/onboarding/viewModel/onboarding_view_model_model.dart';
import 'package:groceryapp/features/profile/viewmodel/profile_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerFactory<SupabaseClient>(() => Supabase.instance.client);
  locator.registerFactory<DioBaseClient>(() => DioBaseClient(dio: Dio()));
  locator.registerFactory<AuthService>(
    () => AuthServiceImp(supabaseClient: locator<SupabaseClient>()),
  );
  locator.registerFactory<ProfileService>(
    () => ProfileService(
      dio: locator<DioBaseClient>(),
      supabaseClient: locator<SupabaseClient>(),
    ),
  );
  locator.registerFactory<ProfileRepo>(
    () => ProfileRepo(profileService: locator<ProfileService>()),
  );
  locator.registerFactory<AuthRepo>(
    () => AuthRepo(authService: locator<AuthService>()),
  );
  locator.registerFactory<AuthViewModel>(
    () => AuthViewModel(authRepo: locator<AuthRepo>()),
  );
  locator.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
  locator.registerLazySingleton<OnboardingViewModel>(
    () => OnboardingViewModel(),
  );
  locator.registerLazySingleton<ProfileViewModel>(
    () => ProfileViewModel(profileRepo: locator<ProfileRepo>()),
  );
}
