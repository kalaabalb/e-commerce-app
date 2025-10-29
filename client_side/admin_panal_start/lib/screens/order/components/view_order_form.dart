// lib/screens/order/components/view_order_form.dart
import '../../../models/order.dart';
import '../../../utility/constants.dart';
import '../../../utility/extensions.dart';
import '../../../utility/responsive_utils.dart';
import '../../../widgets/compact_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../provider/order_provider.dart';

class OrderSubmitForm extends StatelessWidget {
  final Order? order;

  const OrderSubmitForm({Key? key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.orderProvider.trackingUrlCtrl.text = order?.trackingUrl ?? '';
    context.orderProvider.orderForUpdate = order;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
        child: Form(
          key: Provider.of<OrderProvider>(context, listen: false).orderFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBasicInfo(context),
              _buildItemsSection(context),
              _buildAddressSection(context),
              Gap(10),
              _buildPaymentDetailsSection(context),
              _buildStatusSection(context),
              _buildTrackingSection(context),
              Gap(ResponsiveUtils.getPadding(context) * 2),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow('Name:', order?.userID?.name ?? 'N/A'),
        _buildInfoRow('Order Id:', order?.sId ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 8),
          _buildItemsList(),
          SizedBox(height: 8),
          _buildInfoRow('Total Price:',
              '\$${order?.totalPrice?.toStringAsFixed(2) ?? 'N/A'}'),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    if (order?.items == null || order!.items!.isEmpty) {
      return Text('No items', style: TextStyle(fontSize: 14));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: order!.items!.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            '${item.productName}: ${item.quantity} x \$${item.price?.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 8),
          _buildInfoRow('Phone:', order?.shippingAddress?.phone ?? 'N/A'),
          _buildInfoRow('Street:', order?.shippingAddress?.street ?? 'N/A'),
          _buildInfoRow('City:', order?.shippingAddress?.city ?? 'N/A'),
          _buildInfoRow(
              'Postal Code:', order?.shippingAddress?.postalCode ?? 'N/A'),
          _buildInfoRow('Country:', order?.shippingAddress?.country ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 8),
          _buildInfoRow('Payment Method:', order?.paymentMethod ?? 'N/A'),
          _buildInfoRow('Coupon Code:', order?.couponCode?.couponCode ?? 'N/A'),
          _buildInfoRow('Sub Total:',
              '\$${order?.orderTotal?.subtotal?.toStringAsFixed(2) ?? 'N/A'}'),
          _buildInfoRow('Discount:',
              '\$${order?.orderTotal?.discount?.toStringAsFixed(2) ?? 'N/A'}'),
          _buildInfoRow('Grand Total:',
              '\$${order?.orderTotal?.total?.toStringAsFixed(2) ?? 'N/A'}'),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 4),
          Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              return CustomDropdown(
                hintText: 'Status',
                initialValue: orderProvider.selectedOrderStatus,
                items: [
                  'pending',
                  'processing',
                  'shipped',
                  'delivered',
                  'cancelled',
                ],
                displayItem: (val) => val,
                onChanged: (newValue) {
                  orderProvider.selectedOrderStatus = newValue ?? 'pending';
                  orderProvider.updateUI();
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select status';
                  }
                  return null;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tracking URL:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 4),
          CustomTextField(
            labelText: 'Tracking Url',
            onSave: (val) {},
            controller: context.orderProvider.trackingUrlCtrl,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        Gap(ResponsiveUtils.getPadding(context)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
          onPressed: () {
            if (Provider.of<OrderProvider>(context, listen: false)
                .orderFormKey
                .currentState!
                .validate()) {
              Provider.of<OrderProvider>(context, listen: false)
                  .orderFormKey
                  .currentState!
                  .save();
              context.orderProvider.updateOrder();
              Navigator.of(context).pop();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

void showOrderForm(BuildContext context, Order? order) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CompactFormDialog(
        title: 'Order Details',
        maxWidth: ResponsiveUtils.isMobile(context) ? double.infinity : 600,
        child: OrderSubmitForm(order: order),
      );
    },
  );
}
