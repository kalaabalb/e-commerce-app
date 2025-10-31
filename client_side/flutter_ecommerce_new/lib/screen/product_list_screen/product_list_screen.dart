import 'dart:io';
import 'package:e_commerce_flutter/core/data/data_provider.dart';
import 'package:e_commerce_flutter/screen/home_screen.dart';
import 'package:e_commerce_flutter/screen/profile_screen/provider/profile_provider.dart';
import 'package:e_commerce_flutter/utility/extensions.dart';
import 'package:e_commerce_flutter/utility/snack_bar_helper.dart';
import 'package:e_commerce_flutter/widget/fixed_search_bar.dart';
import 'package:e_commerce_flutter/widget/universal_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widget/app_bar_action_button.dart';
import '../../../widget/custom_search_bar.dart';
import '../../../widget/product_grid_view.dart';
import 'components/category_selector.dart';
import 'components/poster_section.dart';
import '../../utility/app_color.dart';
import '../profile_screen/profile_screen.dart';
import '../my_order_screen/my_order_screen.dart';
import '../my_address_screen/my_address_screen.dart';
import '../product_favorite_screen/favorite_screen.dart';
import '../product_cart_screen/cart_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'provider/product_list_provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.safeDataProvider.refreshAllData();
            context.productListProvider.refreshData(
              context.safeDataProvider.allProducts,
            );
          },
          child: Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              // Show loading skeleton while data is loading
              if (dataProvider.isLoading) {
                return _buildLoadingSkeleton();
              }

              final welcomeText = dataProvider.safeTranslate(
                'welcome',
                fallback: 'Hello',
              );
              final userName =
                  context.userProvider.getLoginUsr()?.name ??
                  dataProvider.safeTranslate('user', fallback: 'User');

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      Text(
                        "$welcomeText $userName",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        dataProvider.safeTranslate(
                          'get_something',
                          fallback: 'Let\'s get something!',
                        ),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),

                      // Posters section with loading state
                      dataProvider.isPostersLoading
                          ? _buildPostersLoadingSkeleton()
                          : const PosterSection(),

                      const SizedBox(height: 20),

                      // Categories section
                      Text(
                        dataProvider.safeTranslate(
                          'top_categories',
                          fallback: 'Top Categories',
                        ),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),

                      // Categories with loading state
                      dataProvider.isCategoriesLoading
                          ? _buildCategoriesLoadingSkeleton()
                          : Consumer<DataProvider>(
                              builder: (context, dataProvider, child) {
                                return CategorySelector(
                                  categories: dataProvider.categories,
                                );
                              },
                            ),

                      const SizedBox(height: 20),

                      // Products section
                      Text(
                        'Products',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),

                      // Products with loading state
                      dataProvider.isProductsLoading
                          ? _buildProductsLoadingSkeleton()
                          : Consumer<DataProvider>(
                              builder: (context, dataProvider, child) {
                                return ProductGridView(
                                  items:
                                      context
                                          .productListProvider
                                          .searchQuery
                                          .isEmpty
                                      ? dataProvider.allProducts
                                      : context
                                            .productListProvider
                                            .filteredProducts,
                                );
                              },
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // YouTube-like loading skeleton for main content
  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome skeleton
          Container(
            width: 200,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 150,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),

          // Posters skeleton
          _buildPostersLoadingSkeleton(),
          const SizedBox(height: 20),

          // Categories skeleton
          Container(
            width: 120,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 10),
          _buildCategoriesLoadingSkeleton(),
          const SizedBox(height: 20),

          // Products skeleton
          Container(
            width: 80,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 10),
          _buildProductsLoadingSkeleton(),
        ],
      ),
    );
  }

  // Loading skeleton for posters
  Widget _buildPostersLoadingSkeleton() {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 300,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
          );
        },
      ),
    );
  }

  // Loading skeleton for categories
  Widget _buildCategoriesLoadingSkeleton() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }

  // Loading skeleton for products
  Widget _buildProductsLoadingSkeleton() {
    return GridView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 10 / 16,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColor.darkOrange),
            child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => profileProvider.pickProfileImage(),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            profileProvider.profileImagePath != null
                            ? FileImage(File(profileProvider.profileImagePath!))
                            : null,
                        child: profileProvider.profileImagePath == null
                            ? Text(
                                context.userProvider
                                        .getLoginUsr()
                                        ?.name
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    context.safeDataProvider
                                        .safeTranslate('user', fallback: 'U')
                                        .substring(0, 1),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.darkOrange,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.userProvider.getLoginUsr()?.name ??
                          context.safeDataProvider.safeTranslate(
                            'user',
                            fallback: 'User',
                          ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      context.safeDataProvider.safeTranslate(
                        'welcome_back',
                        fallback: 'Welcome back!',
                      ),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          _buildDrawerItem(
            icon: Icons.person,
            title: context.safeDataProvider.safeTranslate(
              'my_profile',
              fallback: 'My Profile',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.shopping_bag,
            title: context.safeDataProvider.safeTranslate(
              'my_orders',
              fallback: 'My Orders',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyOrderScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.location_on,
            title: context.safeDataProvider.safeTranslate(
              'my_address',
              fallback: 'My Address',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyAddressPage()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.favorite,
            title: context.safeDataProvider.safeTranslate(
              'my_favorites',
              fallback: 'My Favorites',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.shopping_cart,
            title: context.safeDataProvider.safeTranslate(
              'my_cart',
              fallback: 'My Cart',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              context.safeDataProvider.safeTranslate(
                'settings',
                fallback: 'SETTINGS',
              ),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          Consumer<DataProvider>(
            builder: (context, dataProvider, child) {
              return SwitchListTile(
                secondary: const Icon(
                  Icons.dark_mode,
                  color: AppColor.darkOrange,
                ),
                title: Text(
                  context.safeDataProvider.safeTranslate(
                    'dark_mode',
                    fallback: 'Dark Mode',
                  ),
                ),
                value: dataProvider.isDarkMode,
                onChanged: (value) {
                  dataProvider.toggleDarkMode();
                },
              );
            },
          ),

          _buildDrawerItem(
            icon: Icons.language,
            title: context.safeDataProvider.safeTranslate(
              'language',
              fallback: 'Language',
            ),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),

          _buildDrawerItem(
            icon: Icons.help,
            title: context.safeDataProvider.safeTranslate(
              'help_support',
              fallback: 'Help & Support',
            ),
            onTap: () {
              _showHelpSupportDialog(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            icon: Icons.logout,
            title: context.safeDataProvider.safeTranslate(
              'logout',
              fallback: 'Logout',
            ),
            onTap: () {
              context.userProvider.logOutUser();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColor.darkOrange),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Add StatefulBuilder for immediate updates
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                context.safeDataProvider.safeTranslate(
                  'select_language',
                  fallback: 'Select Language',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLanguageTile(context, 'English', 'en'),
                  _buildLanguageTile(context, 'Amharic', 'am'),
                  _buildLanguageTile(context, 'Spanish', 'es'),
                  _buildLanguageTile(context, 'French', 'fr'),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String languageName,
    String languageCode,
  ) {
    return ListTile(
      title: Text(languageName),
      leading: const Icon(Icons.language),
      trailing: context.dataProvider.currentLanguage == languageCode
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        _changeLanguage(context, languageCode);
      },
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    final dataProvider = context.safeDataProvider;

    // Change language
    dataProvider.changeLanguage(languageCode);

    // Close dialog
    Navigator.pop(context);

    // Force rebuild of the entire app by going back to HomeScreen
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.safeDataProvider.safeTranslate(
              'help_support',
              fallback: 'Help & Support',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.email, color: AppColor.darkOrange),
                title: Text(
                  context.safeDataProvider.safeTranslate(
                    'email_support',
                    fallback: 'Email Support',
                  ),
                ),
                subtitle: const Text('support@yourapp.com'),
                onTap: () {
                  _launchEmail(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone, color: AppColor.darkOrange),
                title: Text(
                  context.safeDataProvider.safeTranslate(
                    'call_support',
                    fallback: 'Call Support',
                  ),
                ),
                subtitle: const Text('+1-234-567-8900'),
                onTap: () {
                  _launchPhoneCall(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: AppColor.darkOrange),
                title: Text(
                  context.safeDataProvider.safeTranslate(
                    'live_chat',
                    fallback: 'Live Chat',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  SnackBarHelper.showSuccessSnackBar(
                    context.safeDataProvider.currentLanguage == 'am'
                        ? 'ቀጥታ ውይይት በቅርብ ጊዜ ይመጣል!'
                        : 'Live chat coming soon!',
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.safeDataProvider.safeTranslate(
                  'close',
                  fallback: 'Close',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _launchEmail(BuildContext context) async {
    final isAmharic = context.safeDataProvider.currentLanguage == 'am';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@yourapp.com',
      query: _encodeQueryParameters(<String, String>{
        'subject': 'App Support Request',
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      SnackBarHelper.showErrorSnackBar(
        isAmharic ? 'ኢሜይል መተግበሪያ ማስጀመር አልተቻለም' : 'Could not launch email app',
      );
    }
  }

  void _launchPhoneCall(BuildContext context) async {
    final isAmharic = context.safeDataProvider.currentLanguage == 'am';

    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: '+12345678900');

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      SnackBarHelper.showErrorSnackBar(
        isAmharic ? 'የስልክ መተግበሪያ ማስጀመር አልተቻለም' : 'Could not launch phone app',
      );
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBarActionButton(
              icon: Icons.menu,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            // Replace the search bar in CustomAppBar
            Expanded(
              child: Consumer<ProductListProvider>(
                builder: (context, productListProvider, child) {
                  return UniversalSearchBar(
                    // Use UniversalSearchBar
                    controller: TextEditingController(
                      text: productListProvider.searchQuery,
                    ),
                    onChanged: (val) {
                      context.productListProvider.searchProducts(
                        val,
                        context.safeDataProvider.allProducts,
                      );
                    },
                    hintText: context.safeDataProvider.safeTranslate(
                      'search_hint',
                      fallback: 'Search...',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}