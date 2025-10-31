import 'package:e_commerce_flutter/models/product.dart';
import 'package:e_commerce_flutter/screen/product_cart_screen/provider/cart_provider.dart';
import 'package:e_commerce_flutter/utility/snack_bar_helper.dart';
import 'package:e_commerce_flutter/utility/utility_extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:provider/provider.dart';

class ProductDetailProvider extends ChangeNotifier {
  String? selectedVariant;

  void addToCart(Product product, BuildContext context) {
    print('🟡 Adding to cart: ${product.name}, variant: $selectedVariant');

    if (product.proVariantId!.isNotEmpty && selectedVariant == null) {
      SnackBarHelper.showErrorSnackBar('Please select a variant');
      return;
    }

    double? price = product.offerPrice != product.price
        ? product.offerPrice
        : product.price;

    try {
      // Use CartProvider instead of local flutterCart
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      // Use the CartProvider's addToCart method
      cartProvider.addToCart(
        productId: product.sId!,
        productName: product.name!,
        price: price?.toDouble() ?? 0.0,
        productImages:
            product.images?.map((img) => img.url ?? '').toList() ?? [],
        variants: [
          ProductVariant(
            price: price?.toDouble() ?? 0.0,
            color: selectedVariant,
          ),
        ],
        quantity: 1,
      );

      selectedVariant = null;
      SnackBarHelper.showSuccessSnackBar('Item added to cart');

      // Print cart contents for debugging
      print('🟡 Cart contents after add:');
      for (var item in cartProvider.myCartItems) {
        print('  - ${item.productName} (${item.quantity})');
      }

      notifyListeners();
    } catch (e) {
      print('🔴 Error adding to cart: $e');
      SnackBarHelper.showErrorSnackBar('Failed to add item to cart: $e');
    }
  }

  void updateUI() {
    notifyListeners();
  }
}