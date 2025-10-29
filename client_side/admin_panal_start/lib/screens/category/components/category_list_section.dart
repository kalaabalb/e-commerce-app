import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:admin_panal_start/widgets/responsive_data_table.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';
import '../../../models/category.dart';
import 'add_category_form.dart';

class CategoryListSection extends StatelessWidget {
  const CategoryListSection({Key? key}) : super(key: key);

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
            "All Categories",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: defaultPadding),
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              return ResponsiveDataTable(
                dataRowMinHeight: 70, // Increased for better image display
                dataRowMaxHeight: 90,
                columns: [
                  DataColumn(label: Text("Category")),
                  DataColumn(label: Text("Image")),
                  DataColumn(label: Text("Added Date")),
                  DataColumn(label: Text("Edit")),
                  DataColumn(label: Text("Delete")),
                ],
                rows: List.generate(
                  dataProvider.categories.length,
                  (index) => categoryDataRow(
                    dataProvider.categories[index],
                    edit: () {
                      showAddCategoryForm(
                          context, dataProvider.categories[index]);
                    },
                    delete: () {
                      context.categoryProvider
                          .deleteCategory(dataProvider.categories[index]);
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

DataRow categoryDataRow(Category catInfo, {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Container(
          constraints: BoxConstraints(minHeight: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                catInfo.name ?? 'No Name',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Allow 2 lines for longer names
              ),
            ],
          ),
        ),
      ),
      DataCell(
        Container(
          constraints: BoxConstraints(minHeight: 60),
          child: Center(
            child: _buildCategoryImage(catInfo.image),
          ),
        ),
      ),
      DataCell(
        Container(
          constraints: BoxConstraints(minHeight: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(catInfo.createdAt),
                style: TextStyle(color: Colors.white70),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      DataCell(
        Container(
          constraints: BoxConstraints(minHeight: 60),
          child: Center(
            child: IconButton(
              onPressed: () {
                if (edit != null) edit();
              },
              icon: Icon(Icons.edit, color: Colors.blue, size: 20),
              tooltip: 'Edit Category',
            ),
          ),
        ),
      ),
      DataCell(
        Container(
          constraints: BoxConstraints(minHeight: 60),
          child: Center(
            child: IconButton(
              onPressed: () {
                if (delete != null) delete();
              },
              icon: Icon(Icons.delete, color: Colors.red, size: 20),
              tooltip: 'Delete Category',
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildCategoryImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'no_url') {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Icon(Icons.category, color: Colors.grey[400], size: 24),
    );
  }

  return Container(
    width: 50,
    height: 50,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red),
          ),
          child: Icon(Icons.error, color: Colors.red, size: 20),
        ),
      ),
    ),
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
