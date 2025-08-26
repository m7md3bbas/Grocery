import 'package:flutter/material.dart';
import 'package:groceryapp/core/utils/dependancy_injection.dart';
import 'package:groceryapp/features/auth/view/auth_welcome.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/home/view/home_view.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class WrapperAuth extends StatelessWidget {
  const WrapperAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.authStatus == AuthStatus.authenticated) {
          return ChangeNotifierProvider(
            create: (context) => locator<HomeViewModel>(),
            child: HomeView(),
          );
        }

        if (viewModel.authStatus == AuthStatus.unauthenticated) {
          {
            return const AuthWelcome();
          }
        }
        return const AuthWelcome();
      },
    );
  }
}
