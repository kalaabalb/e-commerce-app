// lib/screens/coupon_code/coupon_code_screen.dart
import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'components/coupon_code_header.dart';
import 'components/coupon_list_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'components/add_coupon_form.dart';

class CouponCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
        child: Column(
          children: [
            CouponCodeHeader(),
            Gap(defaultPadding),
            Row(
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
                              "My Coupons",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUtils.isMobile(context)
                                    ? defaultPadding
                                    : defaultPadding * 1.5,
                                vertical: ResponsiveUtils.isMobile(context)
                                    ? defaultPadding / 2
                                    : defaultPadding,
                              ),
                            ),
                            onPressed: () {
                              showAddCouponForm(context, null);
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add New"),
                          ),
                          Gap(ResponsiveUtils.isMobile(context) ? 8 : 20),
                          IconButton(
                            onPressed: () {
                              context.dataProvider
                                  .getAllCoupons(showSnack: true);
                            },
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      Gap(defaultPadding),
                      CouponListSection(),
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
}
