import 'package:flutter/material.dart';
import 'package:groceryapp/core/styles/app_text_style.dart';

class CustomCardAuth extends StatelessWidget {
  const CustomCardAuth({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon),
            Text(title, style: AppStyles.textMedium15),
          ],
        ),
      ),
    );
  }
}
