import 'package:admin_panal_start/utility/constants.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import '../../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Container(
      width: compact ? 80 : null,
      color: secondaryColor,
      child: ListView(
        children: [
          if (compact)
            Container(
              padding: EdgeInsets.all(defaultPadding / 2),
              child: Image.asset("assets/images/logo.png", height: 40),
            )
          else
            DrawerHeader(
              child: Image.asset("assets/images/logo.png"),
            ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('Dashboard');
              onItemSelected();
            },
          ),
          DrawerListTile(
            title: "Category",
            svgSrc: "assets/icons/menu_tran.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('Category');
              onItemSelected();
            },
          ),
          DrawerListTile(
            title: "Sub Category",
            svgSrc: "assets/icons/menu_task.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('SubCategory');
              onItemSelected();
            },
          ),
          DrawerListTile(
            title: "Brands",
            svgSrc: "assets/icons/menu_doc.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('Brands');
              onItemSelected();
            },
          ),
          DrawerListTile(
            title: "Variant Type",
            svgSrc: "assets/icons/menu_store.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('VariantType');
              onItemSelected();
            },
          ),
          DrawerListTile(
            title: "Variants",
            svgSrc: "assets/icons/menu_notification.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('Variants');
              onItemSelected();
            },
          ),
          DrawerListTile(
            title: "Orders",
            svgSrc: "assets/icons/menu_profile.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('Order');
              onItemSelected();
            },
          ),
          DrawerListTile(
            title: "Coupons",
            svgSrc: "assets/icons/menu_setting.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('Coupon');
              onItemSelected();
            },
          ),
          DrawerListTile(
            title: "Posters",
            svgSrc: "assets/icons/menu_doc.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('Poster');
              onItemSelected();
            },
          ),
          DrawerListTile(
            title: "Notifications",
            svgSrc: "assets/icons/menu_notification.svg",
            compact: compact,
            press: () {
              context.mainScreenProvider.navigateToScreen('Notifications');
              onItemSelected();
            },
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
    required this.svgSrc,
    required this.press,
    this.compact = false,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: compact ? 0.0 : 16.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: compact
          ? null
          : Text(
              title,
              style: TextStyle(color: Colors.white54),
            ),
    );
  }
}
