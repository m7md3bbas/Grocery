import 'package:flutter/material.dart';
import 'package:groceryapp/core/utils/constants/styles/app_color_styles.dart';
import 'package:groceryapp/core/utils/constants/styles/app_text_style.dart';

class CustomRememberMe extends StatelessWidget {
  const CustomRememberMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: false,
              onChanged: (value) {},
              activeThumbColor: AppColors.primary,
            ),
            Text("Remember me", style: AppStyles.textMedium15),
          ],
        ),

        TextButton(onPressed: () {}, child: Text("Forgot Password?")),
      ],
    );
  }
}
