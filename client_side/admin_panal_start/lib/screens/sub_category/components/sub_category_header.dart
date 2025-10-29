// lib/screens/sub_category/components/sub_category_header.dart
import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:flutter/material.dart';
import '../../../utility/constants.dart';
import '../../../widgets/responsive_header.dart';

class SubCategoryHeader extends StatelessWidget {
  const SubCategoryHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHeader(
      title: "Sub Category",
      onSearch: (val) {
        context.dataProvider.filteredSubCategories(val);
      },
      actionButton: null,
    );
  }
}
