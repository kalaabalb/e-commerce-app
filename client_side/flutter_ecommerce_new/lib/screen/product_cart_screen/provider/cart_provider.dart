import 'dart:developer';
import 'package:e_commerce_flutter/utility/extensions.dart';
import 'package:e_commerce_flutter/utility/utility_extention.dart';
import 'package:provider/provider.dart';
import '../../../models/coupon.dart';
import '../../login_screen/provider/user_provider.dart';
import '../../../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/api_response.dart';
import '../../../utility/constants.dart';
import '../../../utility/snack_bar_helper.dart';

class CartProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final box = GetStorage();
  var flutterCart = FlutterCart();
  List<CartModel> myCartItems = [];

  final GlobalKey<FormState> buyNowFormKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  bool isExpanded = false;

  Coupon? couponApplied;
  double couponCodeDiscount = 0;
  String selectedPaymentOption = 'prepaid';

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProcessingPayment = false;
  bool get isProcessingPayment => _isProcessingPayment;

  CartProvider() {
    getCartItems();
    retrieveSavedAddress();
  }

  // Get cart items
  getCartItems() {
    try {
      myCartItems = List<CartModel>.from(flutterCart.cartItemsList);
      print('🟡 Cart items loaded: ${myCartItems.length} items');
      notifyListeners();
    } catch (e) {
      print('🔴 Error getting cart items: $e');
      myCartItems = [];
      notifyListeners();
    }
  }

  // Add item to cart - FIXED CartModel parameters
  void addToCart({
    required String productId,
    required String productName,
    required double price,
    required List<String> productImages,
    List<ProductVariant>? variants,
    int quantity = 1,
  }) {
    print('🟡 Adding to cart: $productName, quantity: $quantity');

    try {
      // Create variants with the price if not provided
      final cartVariants =
          variants ?? [ProductVariant(price: price, color: null, size: null)];

      // Check if item already exists in cart
      bool itemExists = myCartItems.any(
        (item) =>
            item.productId == productId &&
            _areVariantsEqual(item.variants, cartVariants),
      );

      if (itemExists) {
        // Update existing item
        var existingItem = myCartItems.firstWhere(
          (item) =>
              item.productId == productId &&
              _areVariantsEqual(item.variants, cartVariants),
        );

        flutterCart.updateQuantity(
          productId,
          cartVariants,
          existingItem.quantity + 1,
        );
      } else {
        // Add new item
        CartModel newItem = CartModel(
          productId: productId,
          productName: productName,
          productDetails: productName,
          productImages: productImages,
          variants: cartVariants,
          quantity: quantity,
        );

        flutterCart.addToCart(cartModel: newItem);
      }

      // Refresh cart and show success message
      getCartItems();
      SnackBarHelper.showSuccessSnackBar('Item added to cart');

      print('🟢 Cart updated. Total items: ${myCartItems.length}');
    } catch (e) {
      print('🔴 Error adding to cart: $e');
      SnackBarHelper.showErrorSnackBar('Failed to add item to cart');
    }
  }

  // Update cart quantity
  void updateCart(CartModel cartItem, int quantity) {
    print('🟡 Updating cart: ${cartItem.productName}, quantity: $quantity');

    try {
      int newQuantity = cartItem.quantity + quantity;

      if (newQuantity <= 0) {
        // Remove item from cart
        flutterCart.removeItem(cartItem.productId, cartItem.variants);
        SnackBarHelper.showSuccessSnackBar('Item removed from cart');
      } else {
        // Update quantity
        flutterCart.updateQuantity(
          cartItem.productId,
          cartItem.variants,
          newQuantity,
        );
        print('🟢 Updated quantity: ${cartItem.productName} to $newQuantity');
      }

      getCartItems();
    } catch (e) {
      print('🔴 Error updating cart: $e');
      SnackBarHelper.showErrorSnackBar('Failed to update cart');
    }
  }

  bool _areVariantsEqual(List<ProductVariant>? v1, List<ProductVariant>? v2) {
    if (v1 == null && v2 == null) return true;
    if (v1 == null || v2 == null) return false;
    if (v1.length != v2.length) return false;

    for (int i = 0; i < v1.length; i++) {
      if (v1[i].color != v2[i].color || v1[i].price != v2[i].price) {
        return false;
      }
    }
    return true;
  }

  double getCartSubTotal() {
    double subtotal = flutterCart.subtotal;
    print('🟡 Cart subtotal: \birr $subtotal');
    return subtotal;
  }

  void clearCartItems() {
    flutterCart.clearCart();
    getCartItems();
    SnackBarHelper.showSuccessSnackBar('Cart cleared');
    print('🟡 Cart cleared');
  }

  double getGrandTotal() {
    double grandTotal = getCartSubTotal() - couponCodeDiscount;
    print(
      '🟡 Grand total: \birr $grandTotal (discount: \birr $couponCodeDiscount)',
    );
    return grandTotal > 0 ? grandTotal : 0;
  }

  checkCoupon() async {
    try {
      if (couponController.text.isEmpty) {
        SnackBarHelper.showErrorSnackBar('Enter a coupon code');
        return;
      }

      _isLoading = true;
      notifyListeners();

      List<String> productIds = myCartItems
          .map((cartItem) => cartItem.productId)
          .toList();

      Map<String, dynamic> couponData = {
        'couponCode': couponController.text,
        'purchaseAmount': getCartSubTotal(),
        'productIds': productIds,
      };

      final response = await service.addItem(
        endpointUrl: 'couponCodes/check-coupon',
        itemData: couponData,
      );

      if (response.isOk) {
        final ApiResponse<Coupon> apiResponse = ApiResponse.fromJson(
          response.body,
          (json) => Coupon.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.success == true) {
          Coupon? coupon = apiResponse.data;
          if (coupon != null) {
            couponApplied = coupon;
            couponCodeDiscount = getCouponDiscountAmount(coupon);
            SnackBarHelper.showSuccessSnackBar('Coupon applied successfully!');
          } else {
            SnackBarHelper.showErrorSnackBar('Invalid coupon');
          }
        } else {
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Failed to validate coupon');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('Error validating coupon: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double getCouponDiscountAmount(Coupon coupon) {
    double discountAmount = 0;
    String discountType = coupon.discountType ?? 'fixed';

    if (discountType == 'fixed') {
      discountAmount = coupon.discountAmount ?? 0;
    } else {
      double discountPercentage = coupon.discountAmount ?? 0;
      discountAmount = getCartSubTotal() * (discountPercentage / 100);
    }

    return discountAmount > getCartSubTotal()
        ? getCartSubTotal()
        : discountAmount;
  }

  addOrder(BuildContext context) async {
    try {
      _isProcessingPayment = true;
      notifyListeners();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      Map<String, dynamic> order = {
        'userID': userProvider.getLoginUsr()?.sId ?? '',
        'orderStatus': "pending",
        'items': cartItemToOrderItem(myCartItems),
        'totalPrice': getGrandTotal(),
        'shippingAddress': {
          'phone': phoneController.text,
          'street': streetController.text,
          'city': cityController.text,
          'state': stateController.text,
          'postalCode': postalCodeController.text,
          'country': countryController.text,
        },
        'paymentMethod': selectedPaymentOption,
        'couponCode': couponApplied?.sId,
        'orderTotal': {
          "subtotal": getCartSubTotal(),
          "discount": couponCodeDiscount,
          "total": getGrandTotal(),
        },
      };

      final response = await service.addItem(
        endpointUrl: 'orders',
        itemData: order,
      );

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Order created successfully!');
          saveAddress();
          clearCartItems();

          if (context.mounted) {
            Navigator.of(context).pop();
          }

          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed('/');
          });
        } else {
          SnackBarHelper.showErrorSnackBar(
            'Failed to create order: ${apiResponse.message}',
          );
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Failed to create order: ${response.statusText}',
        );
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error creating order: $e');
    } finally {
      _isProcessingPayment = false;
      notifyListeners();
    }
  }

  submitOrder(BuildContext context) async {
    if (!buyNowFormKey.currentState!.validate()) {
      SnackBarHelper.showErrorSnackBar('Please fill all required fields');
      return;
    }

    buyNowFormKey.currentState!.save();

    if (isExpanded) {
      if (phoneController.text.isEmpty ||
          streetController.text.isEmpty ||
          cityController.text.isEmpty ||
          stateController.text.isEmpty ||
          postalCodeController.text.isEmpty ||
          countryController.text.isEmpty) {
        SnackBarHelper.showErrorSnackBar('Please fill all address fields');
        return;
      }
    }

    if (selectedPaymentOption == 'cod') {
      await addOrder(context);
    } else {
      await stripePayment(
        context: context,
        operation: () {
          addOrder(context);
        },
      );
    }
  }

  List<Map<String, dynamic>> cartItemToOrderItem(List<CartModel> cartItems) {
    return cartItems.map((cartItem) {
      // Get price from the first variant
      double itemPrice = 0;
      if (cartItem.variants?.isNotEmpty ?? false) {
        itemPrice = cartItem.variants!.first.price;
      }

      return {
        "productID": cartItem.productId,
        "productName": cartItem.productName,
        "quantity": cartItem.quantity,
        "price": itemPrice,
        "variant":
            (cartItem.variants?.isNotEmpty ?? false) &&
                cartItem.variants!.first.color != null
            ? cartItem.variants!.first.color!
            : '',
      };
    }).toList();
  }

  clearCouponDiscount() {
    couponApplied = null;
    couponCodeDiscount = 0;
    couponController.text = '';
    notifyListeners();
  }

  void retrieveSavedAddress() {
    phoneController.text = box.read(PHONE_KEY) ?? '';
    streetController.text = box.read(STREET_KEY) ?? '';
    cityController.text = box.read(CITY_KEY) ?? '';
    stateController.text = box.read(STATE_KEY) ?? '';
    postalCodeController.text = box.read(POSTAL_CODE_KEY) ?? '';
    countryController.text = box.read(COUNTRY_KEY) ?? '';
  }

  Future<void> stripePayment({
    required BuildContext context,
    required void Function() operation,
  }) async {
    try {
      _isProcessingPayment = true;
      notifyListeners();

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Validate address first
      if (phoneController.text.isEmpty ||
          streetController.text.isEmpty ||
          cityController.text.isEmpty ||
          stateController.text.isEmpty ||
          postalCodeController.text.isEmpty ||
          countryController.text.isEmpty) {
        SnackBarHelper.showErrorSnackBar('Please fill all address fields');
        _isProcessingPayment = false;
        notifyListeners();
        return;
      }

      // Prepare payment data with timeout
      Map<String, dynamic> paymentData = {
        "email": userProvider.getLoginUsr()?.name ?? 'customer@example.com',
        "name": userProvider.getLoginUsr()?.name ?? 'Customer',
        "address": {
          "line1": streetController.text,
          "city": cityController.text,
          "state": stateController.text,
          "postal_code": postalCodeController.text,
          "country": countryController.text,
        },
        "amount": (getGrandTotal() * 100).round(),
        "currency": "usd",
        "description": "Order payment for ${userProvider.getLoginUsr()?.name}",
      };

      // Add timeout to the payment request
      Response response = await service
          .addItem(endpointUrl: 'payment/stripe', itemData: paymentData)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              return Response(
                statusCode: 408,
                statusText: 'Payment request timeout',
              );
            },
          );

      if (response.isOk && response.body != null) {
        final data = response.body;
        final paymentIntent = data['paymentIntent'];

        if (paymentIntent == null) {
          SnackBarHelper.showErrorSnackBar(
            'Payment setup failed - no payment intent',
          );
          _isProcessingPayment = false;
          notifyListeners();
          return;
        }

        // Initialize Stripe with proper error handling
        try {
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              customFlow: false,
              merchantDisplayName: 'MOBIZATE',
              paymentIntentClientSecret: paymentIntent,
              customerEphemeralKeySecret: data['ephemeralKey'],
              customerId: data['customer'],
              style: ThemeMode.light,
              billingDetails: BillingDetails(
                email:
                    userProvider.getLoginUsr()?.name ?? 'customer@example.com',
                phone: phoneController.text.isNotEmpty
                    ? phoneController.text
                    : '+1234567890',
                name: userProvider.getLoginUsr()?.name ?? 'Customer',
                address: Address(
                  country: countryController.text.isNotEmpty
                      ? countryController.text
                      : 'US',
                  city: cityController.text,
                  line1: streetController.text,
                  line2: '', // Added required line2 parameter
                  postalCode: postalCodeController.text,
                  state: stateController.text,
                ),
              ),
            ),
          );

          // Present payment sheet with timeout
          await Stripe.instance.presentPaymentSheet().timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              throw Exception('Payment process timeout');
            },
          );

          SnackBarHelper.showSuccessSnackBar('Payment successful!');
          operation();
        } on StripeException catch (e) {
          SnackBarHelper.showErrorSnackBar(
            'Payment failed: ${e.error.localizedMessage ?? 'Unknown error'}',
          );
        } catch (e) {
          SnackBarHelper.showErrorSnackBar('Payment failed: $e');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
          'Payment setup failed: ${response.statusText ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Payment failed: $e');
    } finally {
      _isProcessingPayment = false;
      notifyListeners();
    }
  }

  void updateUI() {
    notifyListeners();
  }

  void saveAddress() {
    box.write(PHONE_KEY, phoneController.text);
    box.write(STREET_KEY, streetController.text);
    box.write(CITY_KEY, cityController.text);
    box.write(STATE_KEY, stateController.text);
    box.write(POSTAL_CODE_KEY, postalCodeController.text);
    box.write(COUNTRY_KEY, countryController.text);
    SnackBarHelper.showSuccessSnackBar('Address saved successfully');
  }

  void refreshCart() {
    getCartItems();
  }
}