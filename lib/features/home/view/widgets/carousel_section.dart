import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:groceryapp/core/utils/constants/images.dart';
import 'package:groceryapp/core/utils/constants/styles/app_color_styles.dart';
import 'package:groceryapp/core/utils/constants/styles/app_text_style.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class CarouselSection extends StatelessWidget {
  CarouselSection({super.key});
  final CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<HomeViewModel>(
          builder: (context, viewModel, _) => CarouselSlider(
            items: List.generate(5, (index) => Image.asset(AppImages.auth)),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height / 3.5,
              initialPage: 0,
              viewportFraction: 1,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 60,
          child: Text(
            "20% off on your \n first purchase",
            style: AppStyles.textBold20,
          ),
        ),
        Positioned(
          left: 8,
          bottom: 16,
          child: Row(
            spacing: 5,
            children: List.generate(
              6,
              (index) => AnimatedContainer(
                duration: Duration(seconds: 1),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
