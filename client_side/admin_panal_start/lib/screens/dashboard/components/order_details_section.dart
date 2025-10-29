import '../../../core/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';
import 'chart.dart';
import 'order_info_card.dart';

class OrderDetailsSection extends StatelessWidget {
  const OrderDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        int totalOrder = dataProvider.calculateOrdersWithStatus(null);
        int pendingOrder = dataProvider.calculateOrdersWithStatus('pending');
        int processingOrder = dataProvider.calculateOrdersWithStatus(
          'processing',
        );
        int cancelledOrder = dataProvider.calculateOrdersWithStatus(
          'cancelled',
        );
        int shippedOrder = dataProvider.calculateOrdersWithStatus('shipped');
        int deliveredOrder = dataProvider.calculateOrdersWithStatus(
          'delivered',
        );
        return Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Orders Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: defaultPadding),
              Chart(),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery1.svg",
                title: "All Orders",
                totalOrder: totalOrder,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery5.svg",
                title: "Pending Orders",
                totalOrder: pendingOrder,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery6.svg",
                title: "Processed Orders",
                totalOrder: processingOrder,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery2.svg",
                title: "Cancelled Orders",
                totalOrder: cancelledOrder,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery4.svg",
                title: "Shipped Orders",
                totalOrder: shippedOrder,
              ),
              OrderInfoCard(
                svgSrc: "assets/icons/delivery3.svg",
                title: "Delivered Orders",
                totalOrder: deliveredOrder,
              ),
            ],
          ),
        );
      },
    );
  }
}
