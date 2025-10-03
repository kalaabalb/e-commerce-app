import 'package:admin_panal_start/utility/constants.dart';
import 'package:admin_panal_start/utility/responsive.dart';

import 'provider/main_screen_provider.dart';
import '../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/side_menu.dart';

// Update MainScreen to be responsive
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              title: Text('Admin Panel'),
              backgroundColor: secondaryColor,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            )
          : null,
      drawer: Responsive.isMobile(context) ? SideMenu() : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Side menu for desktop
            if (!Responsive.isMobile(context)) Expanded(child: SideMenu()),
            // Main content area
            Expanded(
              flex: 5,
              child: Consumer<MainScreenProvider>(
                builder: (context, provider, child) {
                  return provider.selectedScreen;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
