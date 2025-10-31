import 'package:e_commerce_flutter/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/product.dart';

class FavoriteProvider extends ChangeNotifier {
  final box = GetStorage();
  List<Product> favoriteProduct = [];

  FavoriteProvider();

  void updateToFavoriteList(String productId) {
    List<dynamic> favoriteList = box.read(FAVORITE_PRODUCT_BOX) ?? [];
    if (favoriteList.contains(productId)) {
      favoriteList.remove(productId);
    } else {
      favoriteList.add(productId);
    }
    box.write(FAVORITE_PRODUCT_BOX, favoriteList);
    notifyListeners(); // This will update the UI immediately
  }

  bool checkIsItemFavorite(String productId) {
    List<dynamic> favoriteList = box.read(FAVORITE_PRODUCT_BOX) ?? [];
    bool isExist = favoriteList.contains(productId);
    return isExist;
  }

  void loadFavoriteItems(List<Product> allProducts) {
    List<dynamic> favoriteListIds = box.read(FAVORITE_PRODUCT_BOX) ?? [];
    favoriteProduct = allProducts.where((product) {
      return favoriteListIds.contains(product.sId);
    }).toList();
    Future.microtask(() => notifyListeners());
  }

  void clearFavoriteList() {
    box.remove(FAVORITE_PRODUCT_BOX);
    favoriteProduct.clear();
    notifyListeners();
  }
}
