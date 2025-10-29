// lib/screens/order/order_screen.dart
import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'components/order_header.dart';
import 'components/order_list_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import '../../widgets/custom_dropdown.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
        child: Column(
          children: [
            OrderHeader(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildOrderHeader(context),
                      Gap(defaultPadding),
                      OrderListSection(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "My Orders",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          Gap(8),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(context),
              ),
              Gap(8),
              IconButton(
                onPressed: () {
                  context.dataProvider.getAllOrders(showSnack: true);
                },
                icon: Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              "My Orders",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Gap(20),
          SizedBox(
            width: 280,
            child: _buildFilterDropdown(context),
          ),
          Gap(40),
          IconButton(
            onPressed: () {
              context.dataProvider.getAllOrders(showSnack: true);
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      );
    }
  }

  Widget _buildFilterDropdown(BuildContext context) {
    return CustomDropdown(
      hintText: 'Filter Order By status',
      initialValue: 'All order',
      items: [
        'All order',
        'pending',
        'processing',
        'shipped',
        'delivered',
        'cancelled',
      ],
      displayItem: (val) => val,
      onChanged: (newValue) {
        if (newValue?.toLowerCase() == 'all order') {
          context.dataProvider.filterOrders('');
        } else {
          context.dataProvider.filterOrders(newValue?.toLowerCase() ?? '');
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Please select status';
        }
        return null;
      },
    );
  }
}
