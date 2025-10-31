import 'package:e_commerce_flutter/screen/product_list_screen/provider/product_list_provider.dart';
import 'package:e_commerce_flutter/utility/extensions.dart';
import 'package:e_commerce_flutter/widget/universal_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widget/app_bar_action_button.dart';
import '../../../widget/custom_search_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBarActionButton(
              icon: Icons.menu,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            Expanded(
              child: Consumer<ProductListProvider>(
                builder: (context, productListProvider, child) {
                  return UniversalSearchBar(
                    controller: TextEditingController(
                      text: productListProvider.searchQuery,
                    ),
                    onChanged: (val) {
                      // This will now work correctly without reverse typing
                      context.productListProvider.searchProducts(
                        val,
                        context.safeDataProvider.allProducts,
                      );
                    },
                    hintText: context.safeDataProvider.safeTranslate(
                      'search_hint',
                      fallback: 'Search...',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}