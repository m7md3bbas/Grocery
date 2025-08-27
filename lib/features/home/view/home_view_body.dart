import 'package:flutter/material.dart';
import 'package:groceryapp/core/utils/constants/styles/app_text_style.dart';
import 'package:groceryapp/features/home/view/widgets/caregory_section.dart';
import 'package:groceryapp/features/home/view/widgets/carousel_section.dart';
import 'package:groceryapp/features/home/view/widgets/product_section.dart';
import 'package:groceryapp/features/home/view/widgets/search_section.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final viewModel = context.read<HomeViewModel>();
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !viewModel.isLoading) {
      viewModel.getProduct(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: () async {
          final viewModel = context.read<HomeViewModel>();
          viewModel.getProduct(loadMore: false);
        },
        child: SafeArea(
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(child: SearchSection()),
              SliverToBoxAdapter(child: CarouselSection()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Text("Categories", style: AppStyles.textBold20),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: CaregorySection()),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text(
                        "Featured Products",
                        style: AppStyles.textBold20,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
              ProductSection(),
            ],
          ),
        ),
      ),
    );
  }
}
