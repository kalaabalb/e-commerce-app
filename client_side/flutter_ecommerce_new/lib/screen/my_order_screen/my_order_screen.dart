import 'package:e_commerce_flutter/core/data/data_provider.dart';
import 'package:e_commerce_flutter/models/order.dart';
import 'package:e_commerce_flutter/screen/order_details_screen/order_details_screen.dart';
import 'package:e_commerce_flutter/utility/app_color.dart';
import 'package:e_commerce_flutter/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh orders when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.dataProvider.getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.dataProvider.translate('my_orders'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          final orders = dataProvider.orders;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Orders Yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your orders will appear here',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await dataProvider.getAllOrders();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(context, order);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    String categoryName = _getCategoryName(context, order);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(order: order),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Category Name and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoryName.isNotEmpty ? categoryName : 'General Order',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _formatDate(order.orderDate),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Order Items Preview
              _buildOrderItemsPreview(order),
              const SizedBox(height: 12),

              // Footer with Status and Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.orderStatus),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatStatus(order.orderStatus),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '\birr ${order.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColor.darkOrange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryName(BuildContext context, Order order) {
    if (order.items?.isNotEmpty == true) {
      final firstItemId = order.items!.first.productID;
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      try {
        final product = dataProvider.allProducts.firstWhere(
          (p) => p.sId == firstItemId,
        );
        return product.proCategoryId?.name ?? '';
      } catch (e) {
        return 'General Order';
      }
    }
    return 'General Order';
  }

  Widget _buildOrderItemsPreview(Order order) {
    final firstItem = order.items?.isNotEmpty == true
        ? order.items!.first
        : null;
    final itemCount = order.items?.length ?? 0;

    return Row(
      children: [
        // Product preview image
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: firstItem != null
              ? Icon(Icons.shopping_bag, color: Colors.grey[400])
              : Icon(Icons.shopping_bag, color: Colors.grey[400]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstItem?.productName ?? 'Order Items',
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                itemCount == 1 ? '1 item' : '$itemCount items',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String? status) {
    if (status == null) return 'Unknown';
    return status[0].toUpperCase() + status.substring(1);
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}