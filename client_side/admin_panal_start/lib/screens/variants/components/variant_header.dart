// lib/screens/variants/components/variant_header.dart
import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:flutter/material.dart';
import '../../../utility/constants.dart';
import '../../../widgets/responsive_header.dart';

class VariantsHeader extends StatelessWidget {
  const VariantsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHeader(
      title: "Variants",
      onSearch: (val) {
        context.dataProvider.filterVariants(val);
      },
      actionButton: null,
    );
  }
}
