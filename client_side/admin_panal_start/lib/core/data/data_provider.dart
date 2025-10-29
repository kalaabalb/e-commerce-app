import 'dart:convert';
import '../../models/api_response.dart';
import '../../models/coupon.dart';
import '../../models/my_notification.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/variant_type.dart';
import '../../services/http_services.dart';
import '../../utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import '../../../models/category.dart';
import '../../models/brand.dart';
import '../../models/sub_category.dart';
import '../../models/variant.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];
  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  List<Brand> get brands => _filteredBrands;

  List<VariantType> _allVariantTypes = [];
  List<VariantType> _filteredVariantTypes = [];
  List<VariantType> get variantTypes => _filteredVariantTypes;

  List<Variant> _allVariants = [];
  List<Variant> _filteredVariants = [];
  List<Variant> get variants => _filteredVariants;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;

  List<Coupon> _allCoupons = [];
  List<Coupon> _filteredCoupons = [];
  List<Coupon> get coupons => _filteredCoupons;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  List<MyNotification> _allNotifications = [];
  List<MyNotification> _filteredNotifications = [];
  List<MyNotification> get notifications => _filteredNotifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DataProvider() {
    _initializeData();
  }

  void _initializeData() async {
    try {
      _isLoading = true;
      notifyListeners();

      await Future.wait([
        getAllProduct(),
        getAllVariant(),
        getAllCategory(),
        getAllSubCategory(),
        getAllBrands(),
        getAllVariantType(),
        getAllPosters(),
        getAllCoupons(),
        getAllOrders(),
      ], eagerError: false);
    } catch (e) {
      print('Error initializing DataProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'categories');

      if (response.body == null) {
        if (showSnack) {
          SnackBarHelper.showErrorSnackBar('No response from server');
        }
        return _filteredCategories;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack) {
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          }
          return _filteredCategories;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack) {
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        }
        return _filteredCategories;
      }

      ApiResponse<List<Category>> apiResponse = ApiResponse.fromJson(
        responseBody,
        (json) =>
            (json as List).map((item) => Category.fromJson(item)).toList(),
      );

      _allCategories = apiResponse.data ?? [];
      _filteredCategories = List.from(_allCategories);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllCategory: $e');
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar('Failed to load categories: $e');
      }
    }
    return _filteredCategories;
  }

  void filterCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      final lowcase = keyword.toLowerCase();
      _filteredCategories = _allCategories.where((category) {
        return (category.name ?? '').toLowerCase().contains(lowcase);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<SubCategory>> getAllSubCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'subCategories');

      if (response.body == null) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('No response from server');
        return _filteredSubCategories;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack)
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          return _filteredSubCategories;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        return _filteredSubCategories;
      }

      ApiResponse<List<SubCategory>> apiResponse = ApiResponse.fromJson(
        responseBody,
        (json) =>
            (json as List).map((item) => SubCategory.fromJson(item)).toList(),
      );

      _allSubCategories = apiResponse.data ?? [];
      _filteredSubCategories = List.from(_allSubCategories);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllSubCategory: $e');
      if (showSnack)
        SnackBarHelper.showErrorSnackBar('Failed to load subcategories: $e');
    }
    return _filteredSubCategories;
  }

  void filteredSubCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredSubCategories = List.from(_allSubCategories);
    } else {
      final lowcase = keyword.toLowerCase();
      _filteredSubCategories = _allSubCategories.where((SubCategory) {
        return (SubCategory.name ?? '').toLowerCase().contains(lowcase);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Brand>> getAllBrands({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'brands');

      if (response.body == null) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('No response from server');
        return _filteredBrands;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack)
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          return _filteredBrands;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        return _filteredBrands;
      }

      ApiResponse<List<Brand>> apiResponse = ApiResponse.fromJson(
        responseBody,
        (json) => (json as List).map((item) => Brand.fromJson(item)).toList(),
      );

      _allBrands = apiResponse.data ?? [];
      _filteredBrands = List.from(_allBrands);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllBrands: $e');
      if (showSnack)
        SnackBarHelper.showErrorSnackBar('Failed to load brands: $e');
    }
    return _filteredBrands;
  }

  void filteredBrands(String keyword) {
    if (keyword.isEmpty) {
      _filteredBrands = List.from(_allBrands);
    } else {
      final lowcase = keyword.toLowerCase();
      _filteredBrands = _allBrands.where((Brand) {
        return (Brand.name ?? '').toLowerCase().contains(lowcase);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<VariantType>> getAllVariantType({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'variantTypes');

      if (response.body == null) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('No response from server');
        return _filteredVariantTypes;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack)
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          return _filteredVariantTypes;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        return _filteredVariantTypes;
      }

      ApiResponse<List<VariantType>> apiResponse = ApiResponse.fromJson(
        responseBody,
        (json) =>
            (json as List).map((item) => VariantType.fromJson(item)).toList(),
      );

      _allVariantTypes = apiResponse.data ?? [];
      _filteredVariantTypes = List.from(_allVariantTypes);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllVariantType: $e');
      if (showSnack)
        SnackBarHelper.showErrorSnackBar('Failed to load variant types: $e');
    }
    return _filteredVariantTypes;
  }

  void filterVariantTypes(String keyword) {
    if (keyword.isEmpty) {
      _filteredVariantTypes = List.from(_allVariantTypes);
    } else {
      final lowcase = keyword.toLowerCase();
      _filteredVariantTypes = _allVariantTypes.where((VariantType) {
        return (VariantType.name ?? '').toLowerCase().contains(lowcase);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Variant>> getAllVariant({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'variants');

      if (response.body == null) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('No response from server');
        return _filteredVariants;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack)
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          return _filteredVariants;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        return _filteredVariants;
      }

      ApiResponse<List<Variant>> apiResponse = ApiResponse.fromJson(
        responseBody,
        (json) => (json as List).map((item) => Variant.fromJson(item)).toList(),
      );

      _allVariants = apiResponse.data ?? [];
      _filteredVariants = List.from(_allVariants);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllVariant: $e');
      if (showSnack)
        SnackBarHelper.showErrorSnackBar('Failed to load variants: $e');
    }
    return _filteredVariants;
  }

  void filterVariants(String keyword) {
    if (keyword.isEmpty) {
      _filteredVariants = List.from(_allVariants);
    } else {
      final lowcase = keyword.toLowerCase();
      _filteredVariants = _allVariants.where((Variant) {
        return (Variant.name ?? '').toLowerCase().contains(lowcase);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Product>> getAllProduct({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'products');

      if (response.body == null) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('No response from server');
        return _filteredProducts;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack)
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          return _filteredProducts;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        return _filteredProducts;
      }

      ApiResponse<List<Product>> apiResponse = ApiResponse.fromJson(
        responseBody,
        (json) => (json as List).map((item) => Product.fromJson(item)).toList(),
      );

      _allProducts = apiResponse.data ?? [];
      _filteredProducts = List.from(_allProducts);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllProduct: $e');
      if (showSnack)
        SnackBarHelper.showErrorSnackBar('Failed to load products: $e');
    }
    return _filteredProducts;
  }

  void filterProducts(String keyword) {
    if (keyword.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final lowcase = keyword.toLowerCase();

      _filteredProducts = _allProducts.where((product) {
        final ProductNameContainsKeyword =
            (product.name ?? '').toLowerCase().contains(lowcase);
        final categoryNameContainsKeyword =
            product.proCategoryId?.name?.toLowerCase().contains(lowcase) ??
                false;
        final subCategoryNameContainsKeyword =
            product.proSubCategoryId?.name?.toLowerCase().contains(lowcase) ??
                false;
        final brandNameContainsKeyword =
            product.proBrandId?.name?.toLowerCase().contains(lowcase) ?? false;

        return ProductNameContainsKeyword ||
            categoryNameContainsKeyword ||
            subCategoryNameContainsKeyword ||
            brandNameContainsKeyword;
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Coupon>> getAllCoupons({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'couponCodes');

      if (response.body == null) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('No response from server');
        return _filteredCoupons;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack)
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          return _filteredCoupons;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        return _filteredCoupons;
      }

      ApiResponse<List<Coupon>> apiResponse = ApiResponse.fromJson(
        responseBody,
        (json) => (json as List).map((item) => Coupon.fromJson(item)).toList(),
      );

      _allCoupons = apiResponse.data ?? [];
      _filteredCoupons = List.from(_allCoupons);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllCoupons: $e');
      if (showSnack)
        SnackBarHelper.showErrorSnackBar('Failed to load coupons: $e');
    }
    return _filteredCoupons;
  }

  void filterCoupons(String keyword) {
    if (keyword.isEmpty) {
      _filteredCoupons = List.from(_allCoupons);
    } else {
      final lowcase = keyword.toLowerCase();
      _filteredCoupons = _allCoupons.where((coupon) {
        return (coupon.couponCode ?? '').toLowerCase().contains(lowcase);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'posters');

      if (response.body == null) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('No response from server');
        return _filteredPosters;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack)
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          return _filteredPosters;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        return _filteredPosters;
      }

      ApiResponse<List<Poster>> apiResponse = ApiResponse.fromJson(
        responseBody,
        (json) => (json as List).map((item) => Poster.fromJson(item)).toList(),
      );

      _allPosters = apiResponse.data ?? [];
      _filteredPosters = List.from(_allPosters);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllPosters: $e');
      if (showSnack)
        SnackBarHelper.showErrorSnackBar('Failed to load posters: $e');
    }
    return _filteredPosters;
  }

  void filterPosters(String keyword) {
    if (keyword.isEmpty) {
      _filteredPosters = List.from(_allPosters);
    } else {
      final lowcase = keyword.toLowerCase();
      _filteredPosters = _allPosters.where((poster) {
        return (poster.posterName ?? '').toLowerCase().contains(lowcase);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<MyNotification>> getAllNotifications(
      {bool showSnack = false}) async {
    try {
      Response response =
          await service.getItems(endpointUrl: 'notification/all-notification');

      if (response.body == null) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('No response from server');
        return _filteredNotifications;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack)
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          return _filteredNotifications;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        return _filteredNotifications;
      }

      ApiResponse<List<MyNotification>> apiResponse = ApiResponse.fromJson(
        responseBody,
        (json) => (json as List)
            .map((item) => MyNotification.fromJson(item))
            .toList(),
      );

      _allNotifications = apiResponse.data ?? [];
      _filteredNotifications = List.from(_allNotifications);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllNotifications: $e');
      if (showSnack)
        SnackBarHelper.showErrorSnackBar('Failed to load notifications: $e');
    }
    return _filteredNotifications;
  }

  void filterNotifications(String keyword) {
    if (keyword.isEmpty) {
      _filteredNotifications = List.from(_allNotifications);
    } else {
      final lowcase = keyword.toLowerCase();
      _filteredNotifications = _allNotifications.where((notification) {
        return (notification.title ?? '').toLowerCase().contains(lowcase) ||
            (notification.description ?? '').toLowerCase().contains(lowcase);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Order>> getAllOrders({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'orders');

      if (response.body == null) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('No response from server');
        return _filteredOrders;
      }

      dynamic responseBody = response.body;
      if (responseBody is String) {
        try {
          responseBody = json.decode(responseBody);
        } catch (e) {
          if (showSnack)
            SnackBarHelper.showErrorSnackBar('Invalid response format');
          return _filteredOrders;
        }
      }

      if (responseBody is! Map<String, dynamic>) {
        if (showSnack)
          SnackBarHelper.showErrorSnackBar('Invalid response format');
        return _filteredOrders;
      }

      ApiResponse<List<Order>> apiResponse = ApiResponse<List<Order>>.fromJson(
        responseBody,
        (json) => (json as List).map((item) => Order.fromJson(item)).toList(),
      );

      _allOrders = apiResponse.data ?? [];
      _filteredOrders = List.from(_allOrders);
      notifyListeners();

      if (showSnack && apiResponse.message.isNotEmpty) {
        SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      print('Error in getAllOrders: $e');
      if (showSnack)
        SnackBarHelper.showErrorSnackBar('Failed to load orders: $e');
    }
    return _filteredOrders;
  }

  void filterOrders(String keyword) {
    if (keyword.isEmpty) {
      _filteredOrders = List.from(_allOrders);
    } else {
      final lowcase = keyword.toLowerCase();
      _filteredOrders = _allOrders.where((order) {
        bool nameMatches =
            (order.userID?.name ?? '').toLowerCase().contains(lowcase);
        bool statusMatches =
            (order.orderStatus ?? '').toLowerCase().contains(lowcase);
        return nameMatches || statusMatches;
      }).toList();
    }
    notifyListeners();
  }

  int calculateOrdersWithStatus(String? status) {
    int totalPrdt = 0;

    if (status == null) {
      totalPrdt = _allOrders.length;
    } else {
      for (Order order in _allOrders) {
        if (order.orderStatus == status) {
          totalPrdt += 1;
        }
      }
    }

    return totalPrdt;
  }

  void filterProductsByQuantity(String productQfilter) {
    if (productQfilter == 'All Product') {
      _filteredProducts = List.from(_allProducts);
    } else if (productQfilter == 'Out Of Stack') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null && product.quantity == 0;
      }).toList();
    } else if (productQfilter == 'Limited Stack') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null && product.quantity == 1;
      }).toList();
    } else if (productQfilter == 'Other Stack') {
      _filteredProducts = _allProducts.where((product) {
        return product.quantity != null &&
            product.quantity != 1 &&
            product.quantity != 0;
      }).toList();
    } else {
      _filteredProducts = List.from(_allProducts);
    }
    notifyListeners();
  }

  int calculateProductWithQuantity(int? quantity) {
    int totalPrdt = 0;

    if (quantity == null) {
      totalPrdt = _allProducts.length;
    } else {
      for (Product product in _allProducts) {
        if (product.quantity != null && product.quantity == quantity) {
          totalPrdt += 1;
        }
      }
    }

    return totalPrdt;
  }
}
