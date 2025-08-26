import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        color: Colors.green,

        onRefresh: () async {},
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: 10,
                itemBuilder: (context, index) => _buildCartItem(
                  "Avocado",
                  "1.50 lbs",
                  "assets/images/home/aocado-2 1.png",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(String title, String subtitle, String imagePath) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {},
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      child: ListTile(
        leading: Image.asset(imagePath, width: 50, height: 50),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.heart),
        ),
      ),
    );
  }
}
