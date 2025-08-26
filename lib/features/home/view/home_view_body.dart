import 'package:flutter/material.dart';
import 'package:groceryapp/features/home/view/widgets/caregory_section.dart';
import 'package:groceryapp/features/home/view/widgets/carousel_section.dart';
import 'package:groceryapp/features/home/view/widgets/product_section.dart';
import 'package:groceryapp/features/home/view/widgets/search_section.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: () async {},
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SearchSection()),
              SliverToBoxAdapter(child: CarouselSection()),
              SliverToBoxAdapter(child: CaregorySection()),
              SliverToBoxAdapter(child: ProductSection()),
            ],
          ),
        ),
      ),
    );
  }
}
