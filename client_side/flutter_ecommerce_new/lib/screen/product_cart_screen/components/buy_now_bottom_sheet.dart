import 'dart:ui';
import 'package:e_commerce_flutter/utility/snack_bar_helper.dart';
import '../provider/cart_provider.dart';
import '../../../utility/extensions.dart';
import '../../../widget/compleate_order_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widget/applay_coupon_btn.dart';
import '../../../widget/custom_dropdown.dart';
import '../../../widget/custom_text_field.dart';

void showCustomBottomSheet(BuildContext context) {
  final cartProvider = context.cartProvider;
  cartProvider.clearCouponDiscount();
  cartProvider.retrieveSavedAddress();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: cartProvider.buyNowFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.dataProvider.safeTranslate(
                              'complete_order',
                              fallback: 'Complete Order',
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Toggle Address Fields
                      Card(
                        child: ListTile(
                          title: Text(
                            context.dataProvider.safeTranslate(
                              'enter_address',
                              fallback: 'Enter Shipping Address',
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              return IconButton(
                                icon: Icon(
                                  cartProvider.isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                                onPressed: () {
                                  cartProvider.isExpanded =
                                      !cartProvider.isExpanded;
                                  cartProvider.updateUI();
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: cartProvider.isExpanded ? null : 0,
                            child: Visibility(
                              visible: cartProvider.isExpanded,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      height: 65,
                                      labelText: context.dataProvider
                                          .safeTranslate(
                                            'phone',
                                            fallback: 'Phone Number',
                                          ),
                                      onSave: (value) {},
                                      inputType: TextInputType.phone,
                                      controller: cartProvider.phoneController,
                                      validator: (value) => value!.isEmpty
                                          ? context.dataProvider.safeTranslate(
                                              'please_enter_phone',
                                              fallback:
                                                  'Please enter phone number',
                                            )
                                          : null,
                                    ),
                                    CustomTextField(
                                      height: 65,
                                      labelText: context.dataProvider
                                          .safeTranslate(
                                            'street',
                                            fallback: 'Street Address',
                                          ),
                                      onSave: (val) {},
                                      controller: cartProvider.streetController,
                                      validator: (value) => value!.isEmpty
                                          ? context.dataProvider.safeTranslate(
                                              'please_enter_street',
                                              fallback:
                                                  'Please enter street address',
                                            )
                                          : null,
                                    ),
                                    CustomTextField(
                                      height: 65,
                                      labelText: context.dataProvider
                                          .safeTranslate(
                                            'city',
                                            fallback: 'City',
                                          ),
                                      onSave: (value) {},
                                      controller: cartProvider.cityController,
                                      validator: (value) => value!.isEmpty
                                          ? context.dataProvider.safeTranslate(
                                              'please_enter_city',
                                              fallback: 'Please enter city',
                                            )
                                          : null,
                                    ),
                                    CustomTextField(
                                      height: 65,
                                      labelText: context.dataProvider
                                          .safeTranslate(
                                            'state',
                                            fallback: 'State/Region',
                                          ),
                                      onSave: (value) {},
                                      controller: cartProvider.stateController,
                                      validator: (value) => value!.isEmpty
                                          ? context.dataProvider.safeTranslate(
                                              'please_enter_state',
                                              fallback: 'Please enter state',
                                            )
                                          : null,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            height: 65,
                                            labelText: context.dataProvider
                                                .safeTranslate(
                                                  'postal_code',
                                                  fallback: 'Postal Code',
                                                ),
                                            onSave: (value) {},
                                            inputType: TextInputType.number,
                                            controller: cartProvider
                                                .postalCodeController,
                                            validator: (value) => value!.isEmpty
                                                ? context.dataProvider
                                                      .safeTranslate(
                                                        'please_enter_code',
                                                        fallback:
                                                            'Please enter postal code',
                                                      )
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: CustomTextField(
                                            height: 65,
                                            labelText: context.dataProvider
                                                .safeTranslate(
                                                  'country',
                                                  fallback: 'Country',
                                                ),
                                            onSave: (value) {},
                                            controller:
                                                cartProvider.countryController,
                                            validator: (value) => value!.isEmpty
                                                ? context.dataProvider
                                                      .safeTranslate(
                                                        'please_enter_country',
                                                        fallback:
                                                            'Please enter country',
                                                      )
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Payment Options
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.dataProvider.safeTranslate(
                                  'payment_method',
                                  fallback: 'Payment Method',
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Consumer<CartProvider>(
                                builder: (context, cartProvider, child) {
                                  return CustomDropdown<String>(
                                    bgColor: Theme.of(context).cardColor,
                                    hintText: context.dataProvider
                                        .safeTranslate(
                                          'payment_method',
                                          fallback: 'Select Payment Method',
                                        ),
                                    items: const ['cod', 'prepaid'],
                                    onChanged: (val) {
                                      cartProvider.selectedPaymentOption =
                                          val ?? 'prepaid';
                                      cartProvider.updateUI();
                                    },
                                    displayItem: (val) {
                                      if (val == 'cod') {
                                        return 'Cash on Delivery';
                                      } else {
                                        return 'Credit/Debit Card';
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Coupon Code Field
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.dataProvider.safeTranslate(
                                  'enter_coupon_code',
                                  fallback: 'Coupon Code',
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      height: 60,
                                      labelText: context.dataProvider
                                          .safeTranslate(
                                            'enter_coupon_code',
                                            fallback: 'Enter coupon code',
                                          ),
                                      onSave: (value) {},
                                      controller: cartProvider.couponController,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ApplyCouponButton(
                                    onPressed: () {
                                      cartProvider.checkCoupon();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Total Amount Display
                      Card(
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context.dataProvider.safeTranslate(
                                          'total_amount',
                                          fallback: 'Subtotal:',
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "\birr ${cartProvider.getCartSubTotal().toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context.dataProvider.safeTranslate(
                                          'discount',
                                          fallback: 'Discount:',
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "-\birr ${cartProvider.couponCodeDiscount.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context.dataProvider.safeTranslate(
                                          'grand_total',
                                          fallback: 'Grand Total:',
                                        ),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "\birr ${cartProvider.getGrandTotal().toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const Divider(),

                      // Pay Button with loading state
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return CompleteOrderButton(
                            labelText:
                                '${context.dataProvider.safeTranslate('complete_order', fallback: 'Complete Order')} - \birr ${cartProvider.getGrandTotal().toStringAsFixed(2)}',
                            onPressed: cartProvider.isProcessingPayment
                                ? null
                                : () {
                                    if (!cartProvider.isExpanded) {
                                      cartProvider.isExpanded = true;
                                      cartProvider.updateUI();
                                      return;
                                    }

                                    if (cartProvider.buyNowFormKey.currentState!
                                        .validate()) {
                                      cartProvider.buyNowFormKey.currentState!
                                          .save();
                                      cartProvider.submitOrder(context);
                                    } else {
                                      SnackBarHelper.showErrorSnackBar(
                                        context.dataProvider.safeTranslate(
                                          'please_fill_all_fields',
                                          fallback:
                                              'Please fill all required fields',
                                        ),
                                      );
                                    }
                                  },
                          );
                        },
                      ),

                      // Loading indicator for payment processing
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return cartProvider.isProcessingPayment
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 10),
                                      Text('Processing your order...'),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}