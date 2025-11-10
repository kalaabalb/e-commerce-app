import 'package:admin_panal_start/core/data/data_provider.dart';
import 'package:admin_panal_start/services/admin_auth_service.dart';
import 'package:admin_panal_start/utility/constants.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'components/side_menu.dart';
import 'provider/main_screen_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _dataInitialized = false;
  final AdminAuthService _authService = Get.find<AdminAuthService>();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_authService.isLoggedIn.value) {
        print('🔐 User not authenticated, redirecting to login');
        Get.offAllNamed('/login');
        return;
      }
      _initializeData();
    });
  }

  void _initializeData() {
    if (!_dataInitialized) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      print('🚀 Initializing app data from MainScreen...');
      dataProvider.testConnection();
      dataProvider.initializeAppData();
      _dataInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check authentication status
    if (!_authService.isLoggedIn.value) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
