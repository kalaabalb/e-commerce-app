import 'package:admin_panal_start/services/admin_auth_service.dart';
import 'package:admin_panal_start/utility/constants.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class ResponsiveHeader extends StatelessWidget {
  final String title;
  final Function(String)? onSearch;
  final VoidCallback? actionButton;
  final String? actionButtonText;

  const ResponsiveHeader({
    Key? key,
    required this.title,
    this.onSearch,
    this.actionButton,
    this.actionButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminAuthService authService = Get.find<AdminAuthService>();

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        if (onSearch != null) ...[
          Expanded(
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: "Search",
                fillColor: secondaryColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
              ),
            ),
          ),
          const Gap(defaultPadding),
        ],
        if (actionButton != null && actionButtonText != null) ...[
          ElevatedButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.isMobile(context)
                    ? defaultPadding
                    : defaultPadding * 1.5,
                vertical: ResponsiveUtils.isMobile(context)
                    ? defaultPadding / 2
                    : defaultPadding,
              ),
            ),
            onPressed: actionButton,
            icon: const Icon(Icons.add),
            label: Text(actionButtonText!),
          ),
          Gap(ResponsiveUtils.isMobile(context) ? 8 : 20),
        ],
        // User info section
        Obx(() {
          final currentAdmin = authService.currentAdmin; // This should work now
          return Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor,
                child: Text(
                  currentAdmin?.name?.substring(0, 1).toUpperCase() ?? 'A',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (!ResponsiveUtils.isMobile(context)) ...[
                const Gap(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentAdmin?.name ?? 'Admin',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      currentAdmin?.clearanceLevel?.replaceAll('_', ' ') ??
                          'Admin',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        }),
      ],
    );
  }
}
