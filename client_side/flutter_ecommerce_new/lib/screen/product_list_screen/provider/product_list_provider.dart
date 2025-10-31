import 'package:flutter/cupertino.dart';
import '../../../models/product.dart';

class ProductListProvider extends ChangeNotifier {
  List<Product> _filteredProducts = [];
  String _searchQuery = '';

  List<Product> get filteredProducts => _filteredProducts;
  String get searchQuery => _searchQuery;

  void updateProducts(List<Product> allProducts) {
    _filteredProducts = allProducts;
    notifyListeners();
  }

  void searchProducts(String query, List<Product> allProducts) {
    _searchQuery =
        query; // Just store the query, don't manipulate the controller
    if (query.isEmpty) {
      _filteredProducts = allProducts;
    } else {
      final lowercaseQuery = query.toLowerCase();
      _filteredProducts = allProducts.where((product) {
        return (product.name ?? '').toLowerCase().contains(lowercaseQuery) ||
            (product.description ?? '').toLowerCase().contains(
              lowercaseQuery,
            ) ||
            (product.proCategoryId?.name ?? '').toLowerCase().contains(
              lowercaseQuery,
            ) ||
            (product.proBrandId?.name ?? '').toLowerCase().contains(
              lowercaseQuery,
            );
      }).toList();
    }
    notifyListeners();
  }

  void clearSearch(List<Product> allProducts) {
    _searchQuery = '';
    _filteredProducts = allProducts;
    notifyListeners();
  }

  void refreshData(List<Product> allProducts) {
    _filteredProducts = allProducts;
    _searchQuery = '';
    notifyListeners();
  }
}