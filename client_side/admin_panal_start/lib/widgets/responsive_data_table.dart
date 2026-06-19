import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../utility/responsive_utils.dart';
import '../utility/constants.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: DataTable(
            columnSpacing: 14,
            horizontalMargin: 16,
            headingRowHeight: 46,
            dataRowMinHeight: dataRowMinHeight ?? 64,
            dataRowMaxHeight: dataRowMaxHeight ?? 86,
            dividerThickness: 0.6,
            showBottomBorder: false,
            columns: columns,
            rows: rows,
            dataTextStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileView(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                surfaceColor,
                surfaceAltColor.withOpacity(0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMobileTitle(context, rows[index]),
              const Gap(12),
              for (int i = 1; i < columns.length; i++)
                if (_shouldShowColumnInMobile(i))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 94,
                          child: Text(
                            _getColumnLabel(columns[i]),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.68),
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child:
                              _buildMobileCellContent(rows[index].cells[i], i),
                        ),
                      ],
                    ),
                  ),
            ],
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

  Widget _buildMobileCellContent(DataCell cell, int columnIndex) {
    final columnLabel = _getColumnLabel(columns[columnIndex]).toLowerCase();

    if (columnLabel.contains('image') || columnLabel.contains('photo')) {
      return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 96),
          child: cell.child,
        ),
      );
    }

    return DefaultTextStyle.merge(
      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.35),
      child: cell.child,
    );
  }

  Widget _buildMobileTitle(BuildContext context, DataRow row) {
    if (row.cells.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        child: row.cells.first.child,
      ),
    );
  }
}
