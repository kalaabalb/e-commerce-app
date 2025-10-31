import 'package:e_commerce_flutter/utility/extensions.dart';
import 'provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widget/product_grid_view.dart';
import '../../utility/app_color.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.dataProvider.translate('my_favorites'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final favoriteProvider = context.favoriteProvider;
          final dataProvider = context.dataProvider;
          await dataProvider.refreshAllData();
          favoriteProvider.loadFavoriteItems(dataProvider.allProducts);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              final dataProvider = context.dataProvider;
              favoriteProvider.loadFavoriteItems(dataProvider.allProducts);

              if (favoriteProvider.favoriteProduct.isEmpty) {
                return Center(
                  child: Text(
                    context.dataProvider.translate('no_favorite_items'),
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ProductGridView(items: favoriteProvider.favoriteProduct);
            },
          ),
        ),
      ),
    );
  }
}