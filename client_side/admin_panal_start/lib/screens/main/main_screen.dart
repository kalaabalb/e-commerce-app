import 'package:admin_panal_start/utility/constants.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'provider/main_screen_provider.dart';
import '../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      appBar: ResponsiveUtils.isMobile(context)
          ? AppBar(
              title: Text('Admin Panel'),
              backgroundColor: secondaryColor,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            )
          : null,
      drawer: ResponsiveUtils.isMobile(context)
          ? _buildMobileDrawer(context)
          : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!ResponsiveUtils.isMobile(context))
              _buildDesktopSidebar(context),
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

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      width: MediaQuery.of(context).size.width * 0.8,
      child: SideMenu(
        onItemSelected: () {
          if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Widget _buildDesktopSidebar(BuildContext context) {
    return Container(
      width: ResponsiveUtils.isTablet(context) ? 80 : 250,
      child: SideMenu(
        onItemSelected: () {},
        compact: ResponsiveUtils.isTablet(context),
      ),
    );
  }
}
