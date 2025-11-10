import 'package:flutter/material.dart';
import '../utility/responsive_utils.dart';

class ResponsiveDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? dataRowMinHeight;
  final double? dataRowMaxHeight;

  const ResponsiveDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.dataRowMinHeight,
    this.dataRowMaxHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return _buildMobileView(context);
    } else {
      return _buildDesktopView(context);
    }
  }

  Widget _buildDesktopView(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: DataTable(
          columnSpacing: 12,
          horizontalMargin: 12,
          headingRowHeight: 40,
          dataRowMinHeight: dataRowMinHeight ?? 60, // Increased min height
          dataRowMaxHeight: dataRowMaxHeight ?? 80, // Increased max height
          columns: columns,
          rows: rows,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          dataTextStyle: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
          headingTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: rows.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: Colors.grey[900],
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < columns.length; i++)
                  if (_shouldShowColumnInMobile(i))
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              _getColumnLabel(columns[i]),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: _getMinHeightForColumn(i),
                              ),
                              child: _buildMobileCellContent(
                                  rows[index].cells[i], i),
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _shouldShowColumnInMobile(int columnIndex) {
    // Show all columns in mobile, but you can customize this
    return true;
  }

  String _getColumnLabel(DataColumn column) {
    if (column.label is Text) {
      return (column.label as Text).data ?? '';
    }
    return '';
  }

  double _getMinHeightForColumn(int columnIndex) {
    // Return larger height for image columns to ensure full visibility
    final columnLabel = _getColumnLabel(columns[columnIndex]).toLowerCase();
    if (columnLabel.contains('image') || columnLabel.contains('photo')) {
      return 60; // More height for images
    }
    return 40; // Default height for other columns
  }

  Widget _buildMobileCellContent(DataCell cell, int columnIndex) {
    final columnLabel = _getColumnLabel(columns[columnIndex]).toLowerCase();

    // Special handling for image columns
    if (columnLabel.contains('image') || columnLabel.contains('photo')) {
      return Container(
        child: cell.child,
        constraints: BoxConstraints(
          maxWidth: 80, // Limit width for images in mobile
        ),
      );
    }

    // For other columns, use the original cell content
    return cell.child;
  }
}
