// lib/screens/coupon_code/components/coupon_code_header.dart
import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:flutter/material.dart';
import '../../../utility/constants.dart';
import '../../../widgets/responsive_header.dart';

class CouponCodeHeader extends StatelessWidget {
  const CouponCodeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHeader(
      title: "Coupon Codes",
      onSearch: (val) {
        context.dataProvider.filterCoupons(val);
      },
      actionButton: null,
    );
  }
}
