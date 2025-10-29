// lib/screens/brands/components/brand_header.dart
import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:flutter/material.dart';
import '../../../utility/constants.dart';
import '../../../widgets/responsive_header.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHeader(
      title: "Brands",
      onSearch: (val) {
        context.dataProvider.filteredBrands(val);
      },
      actionButton: null,
    );
  }
}
