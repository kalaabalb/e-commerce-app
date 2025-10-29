import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:admin_panal_start/widgets/responsive_data_table.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/data/data_provider.dart';
import 'add_poster_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/poster.dart';
import '../../../utility/constants.dart';

class PosterListSection extends StatelessWidget {
  const PosterListSection({Key? key}) : super(key: key);

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
          Text("All Posters", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                if (dataProvider.posters.isEmpty) {
                  return Center(
                    child: Text(
                      "No posters found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ResponsiveDataTable(
                  dataRowMinHeight: 70, // Increased for better image display
                  dataRowMaxHeight: 90,
                  columns: [
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "Image",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          "Poster Name",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataColumn(label: Text("Edit")),
                    DataColumn(label: Text("Delete")),
                  ],
                  rows: List.generate(
                    dataProvider.posters.length,
                    (index) => posterDataRow(
                      dataProvider.posters[index],
                      delete: () {
                        context.posterProvider
                            .deletePoster(dataProvider.posters[index]);
                      },
                      edit: () {
                        showAddPosterForm(context, dataProvider.posters[index]);
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

DataRow posterDataRow(Poster poster, {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Container(
          constraints: BoxConstraints(minHeight: 60),
          child: Center(
            child: _buildPosterImage(poster.imageUrl),
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
                poster.posterName ?? 'No Name',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
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
            child: IconButton(
              onPressed: () {
                if (edit != null) edit();
              },
              icon: Icon(Icons.edit, color: Colors.blue, size: 20),
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
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildPosterImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty || imageUrl == 'no_url') {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, color: Colors.grey[400], size: 16),
          SizedBox(height: 2),
          Text(
            'No Image',
            style: TextStyle(color: Colors.grey[400], fontSize: 8),
          ),
        ],
      ),
    );
  }

  return Container(
    width: 60,
    height: 40,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 60,
        height: 40,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.red),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 16),
              SizedBox(height: 2),
              Text(
                'Error',
                style: TextStyle(color: Colors.red, fontSize: 8),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
