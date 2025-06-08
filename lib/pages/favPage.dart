import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var fav = appState.favorites;

    return Center(
      child: Column(
        children: [
          const HeadingFav(),
          for (var item in fav) favItems(item: item),
        ],
      ),
    );
  }
}

class favItems extends StatelessWidget {
  const favItems({super.key, required this.item});

  final String item;

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: const Icon(Icons.star), title: Text(item));
  }
}

class HeadingFav extends StatelessWidget {
  const HeadingFav({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Fav Items", style: TextStyle(fontSize: 50)),
    );
  }
}
