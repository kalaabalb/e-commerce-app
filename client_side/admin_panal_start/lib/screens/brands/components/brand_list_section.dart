import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:admin_panal_start/widgets/responsive_data_table.dart';
import '../../../core/data/data_provider.dart';
import 'add_brand_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import '../../../models/brand.dart';

class BrandListSection extends StatelessWidget {
  const BrandListSection({Key? key}) : super(key: key);

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
          Text("All Brands", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: defaultPadding),
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              return ResponsiveDataTable(
                columns: [
                  DataColumn(label: Text("Brand")),
                  DataColumn(label: Text("Sub Category")),
                  DataColumn(label: Text("Added Date")),
                  DataColumn(label: Text("Edit")),
                  DataColumn(label: Text("Delete")),
                ],
                rows: List.generate(
                  dataProvider.brands.length,
                  (index) => brandDataRow(
                    dataProvider.brands[index],
                    index + 1,
                    edit: () {
                      showBrandForm(context, dataProvider.brands[index]);
                    },
                    delete: () {
                      context.brandProvider
                          .deleteBrand(dataProvider.brands[index]);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

DataRow brandDataRow(Brand brandInfo, int index,
    {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    brandInfo.name ?? 'No Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              brandInfo.subcategoryId?.name ?? 'N/A',
              style: TextStyle(color: Colors.white70),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(brandInfo.createdAt),
              style: TextStyle(color: Colors.white70),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: Icon(Icons.edit, color: Colors.blue, size: 20),
          tooltip: 'Edit Brand',
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(Icons.delete, color: Colors.red, size: 20),
          tooltip: 'Delete Brand',
        ),
      ),
    ],
  );
}

String _formatDate(String? dateString) {
  if (dateString == null) return 'N/A';
  try {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  } catch (e) {
    return dateString;
  }
}
