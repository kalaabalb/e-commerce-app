import 'package:flutter/cupertino.dart';
import '../../../models/brand.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/sub_category.dart';

class ProductByCategoryProvider extends ChangeNotifier {
  Category? mySelectedCategory;
  SubCategory? mySelectedSubCategory;
  List<SubCategory> subCategories = [];
  List<Brand> brands = [];
  List<Brand> selectedBrands = [];
  List<Product> filteredProduct = [];

  filterInitialProductAndSubCategory(
    Category selectedCategory,
    List<Product> allProducts,
    List<SubCategory> allSubCategories,
    List<Brand> allBrands,
  ) {
    mySelectedSubCategory = SubCategory(name: 'All');
    mySelectedCategory = selectedCategory;
    subCategories = allSubCategories
        .where((element) => element.categoryId?.sId == selectedCategory.sId)
        .toList();
    subCategories.insert(0, SubCategory(name: 'All'));
    filteredProduct = allProducts
        .where(
          (element) => element.proCategoryId?.name == selectedCategory.name,
        )
        .toList();

    brands = allBrands
        .where(
          (element) => element.subcategoryId?.name == selectedCategory.name,
        )
        .toList();

    notifyListeners();
  }

  filterProductBySubCategory(
    SubCategory subCategory,
    List<Product> allProducts,
    List<Brand> allBrands,
  ) {
    mySelectedSubCategory = subCategory;
    if (subCategory.name?.toLowerCase() == 'all') {
      filteredProduct = allProducts
          .where(
            (element) =>
                element.proCategoryId?.name == mySelectedCategory?.name,
          )
          .toList();
      brands = [];
    } else {
      filteredProduct = allProducts
          .where(
            (element) => element.proSubCategoryId?.name == subCategory.name,
          )
          .toList();
      brands = allBrands
          .where((element) => element.subcategoryId?.name == subCategory.name)
          .toList();
    }

    notifyListeners();
  }

  void filterProductByBrand(List<Product> allProducts) {
    if (selectedBrands.isEmpty) {
      filteredProduct = allProducts
          .where(
            (product) =>
                product.proSubCategoryId?.name == mySelectedSubCategory?.name,
          )
          .toList();
    } else {
      filteredProduct = allProducts
          .where(
            (product) =>
                product.proSubCategoryId?.name == mySelectedSubCategory?.name &&
                selectedBrands.any(
                  (brand) => product.proBrandId?.sId == brand.sId,
                ),
          )
          .toList();
    }

    notifyListeners();
  }

  void sortProducts({required bool ascending}) {
    filteredProduct.sort((a, b) {
      if (ascending) {
        return a.price!.compareTo(b.price ?? 0);
      } else {
        return b.price!.compareTo(b.price ?? 0);
      }
    });
    notifyListeners();
  }

  void updateUI() {
    notifyListeners();
  }
}