import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:admin_panal_start/widgets/responsive_data_table.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/sub_category.dart';
import 'add_sub_category_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';

class SubCategoryListSection extends StatelessWidget {
  const SubCategoryListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All SubCategory",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return ResponsiveDataTable(
                  columns: [
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "SubCategory Name",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "Category",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "Added Date",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(label: Text("Edit")),
                    DataColumn(label: Text("Delete")),
                  ],
                  rows: List.generate(
                    dataProvider.subCategories.length,
                    (index) => subCategoryDataRow(
                      dataProvider.subCategories[index],
                      index + 1,
                      edit: () {
                        showAddSubCategoryForm(
                            context, dataProvider.subCategories[index]);
                      },
                      delete: () {
                        context.subCategoryProvider.deleteSubCategory(
                            dataProvider.subCategories[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

DataRow subCategoryDataRow(SubCategory subCatInfo, int index,
    {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Container(
          constraints: BoxConstraints(maxWidth: 150),
          child: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    index.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  subCatInfo.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
      DataCell(
        Container(
          constraints: BoxConstraints(maxWidth: 120),
          child: Text(
            subCatInfo.categoryId?.name ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
      DataCell(
        Container(
          constraints: BoxConstraints(maxWidth: 120),
          child: Text(
            subCatInfo.createdAt ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: Icon(Icons.edit, color: Colors.white, size: 20),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(Icons.delete, color: Colors.red, size: 20),
        ),
      ),
    ],
  );
}
