import 'package:admin_panal_start/services/admin_auth_service.dart';
import 'package:admin_panal_start/utility/constants.dart';
import 'package:get/get.dart';
import '../../../utility/extensions.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final VoidCallback onItemSelected;
  final bool compact;

  const SideMenu({
    Key? key,
    required this.onItemSelected,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminAuthService adminAuthService = Get.find<AdminAuthService>();

    return Container(
      width: compact ? 80 : null,
      color: secondaryColor,
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          if (compact)
            Container(
              padding: EdgeInsets.all(defaultPadding / 2),
              child: Image.asset("assets/images/logo.png", height: 40),
            )
          else
            Container(
              padding: EdgeInsets.all(defaultPadding - 4),
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 45,
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),
          _buildMenuItems(context),
          DrawerListTile(
            title: "Logout",
            icon: Icons.logout,
            compact: compact,
            press: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final authService = Get.find<AdminAuthService>();
    final menuItems = [
      {"title": "Dashboard", "icon": Icons.dashboard, "screen": "Dashboard"},
      {"title": "Category", "icon": Icons.category, "screen": "Category"},
      {
        "title": "Sub Category",
        "icon": Icons.subdirectory_arrow_right,
        "screen": "SubCategory"
      },
      {"title": "Brands", "icon": Icons.branding_watermark, "screen": "Brands"},
      {
        "title": "Variant Type",
        "icon": Icons.type_specimen,
        "screen": "VariantType"
      },
      {"title": "Variants", "icon": Icons.widgets, "screen": "Variants"},
      {"title": "Orders", "icon": Icons.shopping_cart, "screen": "Order"},
      {
        "title": "Payment Verification",
        "icon": Icons.verified,
        "screen": "PaymentVerification"
      },
      {"title": "Coupons", "icon": Icons.discount, "screen": "Coupon"},
      {"title": "Posters", "icon": Icons.photo, "screen": "Poster"},
      {"title": "Ratings & Reviews", "icon": Icons.star, "screen": "Ratings"},
      {
        "title": "Notifications",
        "icon": Icons.notifications,
        "screen": "Notifications"
      },
    ];

    if (authService.canManageUsers()) {
      menuItems.add({
        "title": "User Management",
        "icon": Icons.people,
        "screen": "Users"
      });
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: menuItems
          .map((item) => DrawerListTile(
                title: item["title"] as String,
                icon: item["icon"] as IconData,
                compact: compact,
                press: () {
                  context.mainScreenProvider
                      .navigateToScreen(item["screen"] as String);
                  onItemSelected();
                },
              ))
          .toList(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final adminAuthService = Get.find<AdminAuthService>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryColor,
        title: Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await adminAuthService.logout();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.press,
    this.compact = false,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final bool compact;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: press,
      horizontalTitleGap: compact ? 0.0 : 16.0,
      leading: Icon(icon, color: Colors.white54, size: 16),
      title: compact
          ? null
          : Text(
              title,
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
    );
  }
}
