// lib/screens/variants_type/components/variant_type_header.dart
import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:flutter/material.dart';
import '../../../utility/constants.dart';
import '../../../widgets/responsive_header.dart';

class VariantsTypeHeader extends StatelessWidget {
  const VariantsTypeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHeader(
      title: "Variants Type",
      onSearch: (val) {
        context.dataProvider.filterVariantTypes(val);
      },
      actionButton: null,
    );
  }
}
