import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:admin_panal_start/widgets/responsive_data_table.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';
import 'add_product_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';

class ProductListSection extends StatelessWidget {
  const ProductListSection({Key? key}) : super(key: key);

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
          Text("All Products", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: defaultPadding),
          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              return ResponsiveDataTable(
                dataRowMinHeight: 70, // Increased for better image display
                dataRowMaxHeight: 90,
                columns: [
                  DataColumn(label: Text("Product")),
                  DataColumn(label: Text("Category")),
                  DataColumn(label: Text("Sub Category")),
                  DataColumn(label: Text("Price")),
                  DataColumn(label: Text("Edit")),
                  DataColumn(label: Text("Delete")),
                ],
                rows: List.generate(
                  dataProvider.products.length,
                  (index) => productDataRow(
                    dataProvider.products[index],
                    index + 1,
                    edit: () {
                      showAddProductForm(context, dataProvider.products[index]);
                    },
                    delete: () {
                      context.dashBoardProvider
                          .deleteProduct(dataProvider.products[index]);
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

DataRow productDataRow(Product productInfo, int index,
    {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Container(
          constraints: BoxConstraints(minHeight: 60),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[800],
                ),
                child: _buildProductImage(productInfo),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productInfo.name ?? 'No Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2, // Allow 2 lines for longer names
                    ),
                    if (productInfo.description != null &&
                        productInfo.description!.isNotEmpty)
                      Text(
                        productInfo.description!,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
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
      ),
      DataCell(
        Container(
          constraints: BoxConstraints(minHeight: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productInfo.proCategoryId?.name ?? 'N/A',
                style: TextStyle(color: Colors.white70),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Allow 2 lines
              ),
            ],
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
                productInfo.proSubCategoryId?.name ?? 'N/A',
                style: TextStyle(color: Colors.white70),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Allow 2 lines
              ),
            ],
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
                '\$${productInfo.price?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (productInfo.offerPrice != null && productInfo.offerPrice! > 0)
                Text(
                  '\$${productInfo.offerPrice?.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
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
              tooltip: 'Edit Product',
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
              tooltip: 'Delete Product',
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildProductImage(Product product) {
  final hasImages = product.images != null &&
      product.images!.isNotEmpty &&
      product.images![0].url != null &&
      product.images![0].url!.isNotEmpty;

  if (!hasImages) {
    return Icon(Icons.image, color: Colors.grey[400], size: 20);
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: CachedNetworkImage(
      imageUrl: product.images![0].url!,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        color: Colors.red,
        size: 20,
      ),
    ),
  );
}
