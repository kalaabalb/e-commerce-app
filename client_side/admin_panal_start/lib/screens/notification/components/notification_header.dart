// lib/screens/notification/components/notification_header.dart
import 'package:flutter/material.dart';
import '../../../utility/constants.dart';
import '../../../widgets/responsive_header.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHeader(
      title: "Notification",
      onSearch: (val) {
        // TODO: should complete call filterNotifications
      },
      actionButton: null,
    );
  }
}
