import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'components/dash_board_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'components/add_product_form.dart';
import 'components/order_details_section.dart';
import 'components/product_list_section.dart';
import 'components/product_summery_section.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
        child: Column(
          children: [
            DashBoardHeader(),
            Gap(defaultPadding),
            ResponsiveUtils.isMobile(context)
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "My Products",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: defaultPadding / 2,
                ),
              ),
              onPressed: () {
                showAddProductForm(context, null);
              },
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
            Gap(8),
            IconButton(
              onPressed: () {
                context.dataProvider.getAllProduct(showSnack: true);
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        Gap(defaultPadding),
        ProductSummerySection(),
        Gap(defaultPadding),
        ProductListSection(),
        Gap(defaultPadding),
        OrderDetailsSection(),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "My Products",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding,
                      ),
                    ),
                    onPressed: () {
                      showAddProductForm(context, null);
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add New"),
                  ),
                  Gap(20),
                  IconButton(
                    onPressed: () {
                      context.dataProvider.getAllProduct(showSnack: true);
                    },
                    icon: Icon(Icons.refresh),
                  ),
                ],
              ),
              Gap(defaultPadding),
              ProductSummerySection(),
              Gap(defaultPadding),
              ProductListSection(),
            ],
          ),
        ),
        if (!ResponsiveUtils.isMobile(context)) ...[
          SizedBox(width: defaultPadding),
          Expanded(flex: 2, child: OrderDetailsSection()),
        ],
      ],
    );
  }
}
