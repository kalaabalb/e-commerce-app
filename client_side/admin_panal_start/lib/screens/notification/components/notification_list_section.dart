// lib/screens/notification/components/notification_list_section.dart
import '../../../core/data/data_provider.dart';
import '../../../models/my_notification.dart';
import 'view_notification_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:admin_panal_start/widgets/responsive_data_table.dart';

class NotificationListSection extends StatelessWidget {
  const NotificationListSection({
    Key? key,
  }) : super(key: key);

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
            "All Notification",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return ResponsiveDataTable(
                  columns: [
                    DataColumn(label: Text("Title")),
                    DataColumn(label: Text("Description")),
                    DataColumn(label: Text("Send Date")),
                    DataColumn(label: Text("View")),
                    DataColumn(label: Text("Delete")),
                  ],
                  rows: List.generate(
                    dataProvider.notifications.length,
                    (index) => notificationDataRow(
                        dataProvider.notifications[index], index + 1, edit: () {
                      viewNotificationStatics(
                          context, dataProvider.notifications[index]);
                    }, delete: () {
                      // TODO: should complete call deleteNotification
                    }),
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

DataRow notificationDataRow(MyNotification notificationInfo, int index,
    {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Text(index.toString(), textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                notificationInfo.title!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(
        notificationInfo.description ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      )),
      DataCell(Text(
        notificationInfo.createdAt ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      )),
      DataCell(IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: Icon(
            Icons.remove_red_eye_sharp,
            color: Colors.white,
          ))),
      DataCell(IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ))),
    ],
  );
}
