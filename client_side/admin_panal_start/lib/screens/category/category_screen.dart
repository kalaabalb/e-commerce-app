// lib/screens/category/category_screen.dart
import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'components/add_category_form.dart';
import 'components/category_header.dart';
import 'components/category_list_section.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
        child: Column(
          children: [
            CategoryHeader(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "My Categories",
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
                              showAddCategoryForm(context, null);
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add New"),
                          ),
                          Gap(ResponsiveUtils.isMobile(context) ? 8 : 20),
                          IconButton(
                            onPressed: () {
                              context.dataProvider
                                  .getAllCategory(showSnack: true);
                            },
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      Gap(defaultPadding),
                      CategoryListSection(),
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
