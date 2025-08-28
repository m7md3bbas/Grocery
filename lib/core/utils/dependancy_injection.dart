import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:groceryapp/core/repos/auth/authrepo.dart';
import 'package:groceryapp/core/repos/cart/cart_repo.dart';
import 'package:groceryapp/core/repos/category/category_repo.dart';
import 'package:groceryapp/core/repos/product/product_repos.dart';
import 'package:groceryapp/core/repos/profile/profile_repo.dart';
import 'package:groceryapp/core/service/auth/auth_service.dart';
import 'package:groceryapp/core/service/cart/cart_service.dart';
import 'package:groceryapp/core/service/category/category_service.dart';
import 'package:groceryapp/core/service/dio/base_class.dart';
import 'package:groceryapp/core/service/product/product_service.dart';
import 'package:groceryapp/core/service/profile/profile_service.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/cart/viewmodel/cart_view_model.dart';
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
  locator.registerFactory<ProductService>(
    () => ProductService(dio: locator<DioBaseClient>()),
  );
  locator.registerFactory<ProfileRepo>(
    () => ProfileRepo(profileService: locator<ProfileService>()),
  );
  locator.registerFactory<ProductRepos>(
    () => ProductRepos(productService: locator<ProductService>()),
  );
  locator.registerFactory<AuthRepo>(
    () => AuthRepo(authService: locator<AuthService>()),
  );
  locator.registerFactory<AuthViewModel>(
    () => AuthViewModel(authRepo: locator<AuthRepo>()),
  );
  locator.registerFactory<CategoryService>(
    () => CategoryService(dio: locator<DioBaseClient>()),
  );
  locator.registerFactory<CartService>(
    () => CartService(dioClient: locator<DioBaseClient>()),
  );
  locator.registerFactory<CartRepo>(() => CartRepo(locator<CartService>()));
  locator.registerFactory<CartViewModel>(
    () => CartViewModel(locator<CartRepo>()),
  );
  locator.registerFactory<CategoryRepo>(
    () => CategoryRepo(categoryService: locator<CategoryService>()),
  );
  locator.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      productRepos: locator<ProductRepos>(),
      categoryRepos: locator<CategoryRepo>(),
    ),
  );
  locator.registerFactory<OnboardingViewModel>(() => OnboardingViewModel());
  locator.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(profileRepo: locator<ProfileRepo>()),
  );
}
