import 'dart:io';
import 'package:e_commerce_flutter/core/data/data_provider.dart';
import 'package:e_commerce_flutter/screen/home_screen.dart';
import 'package:e_commerce_flutter/screen/product_favorite_screen/favorite_screen.dart';
import 'package:e_commerce_flutter/screen/product_list_screen/product_list_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../login_screen/login_screen.dart';
import '../my_address_screen/my_address_screen.dart';
import '../../utility/animation/open_container_wrapper.dart';
import '../../utility/extensions.dart';
import '../../widget/navigation_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/app_color.dart';
import '../my_order_screen/my_order_screen.dart';
import '../../widget/custom_text_field.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = context.userProvider.getLoginUsr();
    _nameController.text = user?.name ?? '';
    _profileImage = context.profileProvider.profileImagePath != null
        ? File(context.profileProvider.profileImagePath!)
        : null;
  }

  Future<void> _pickImage() async {
    await context.profileProvider.pickProfileImage();
    setState(() {
      _profileImage = context.profileProvider.profileImagePath != null
          ? File(context.profileProvider.profileImagePath!)
          : null;
    });
  }

  void _saveProfile() {
    setState(() {
      _isEditing = false;
    });
    Get.snackbar(
      context.dataProvider.translate('success'),
      context.dataProvider.currentLanguage == 'am'
          ? 'የተጠቃሚ ስም ተሻሽሏል'
          : 'Username updated successfully',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.userProvider.getLoginUsr();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.dataProvider.translate('my_account'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.darkOrange,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadUserData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/images/profile_pic.png')
                                as ImageProvider,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.darkOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_isEditing) ...[
                CustomTextField(
                  controller: _nameController,
                  labelText: context.dataProvider.translate('username'),
                  onSave: (value) {},
                  validator: (value) => value!.isEmpty
                      ? context.dataProvider.translate('enter_username')
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  context.dataProvider.currentLanguage == 'am'
                      ? 'ማሳሰቢያ፡ የተጠቃሚ ስም ለመቀየር እንደገና መግባት ያስፈልግዎታል'
                      : 'Note: Changing username will require you to login again',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                Text(
                  user?.name ?? context.dataProvider.translate('username'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${context.dataProvider.translate('member_since')} ${_formatDate(user?.createdAt)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],

              const SizedBox(height: 40),

              OpenContainerWrapper(
                nextScreen: const MyOrderScreen(),
                child: NavigationTile(
                  icon: Icons.shopping_bag,
                  title: context.dataProvider.translate('my_orders'),
                ),
              ),
              const SizedBox(height: 15),
              OpenContainerWrapper(
                nextScreen: const MyAddressPage(),
                child: NavigationTile(
                  icon: Icons.location_on,
                  title: context.dataProvider.translate('my_address'),
                ),
              ),
              const SizedBox(height: 15),
              OpenContainerWrapper(
                nextScreen: const FavoriteScreen(),
                child: NavigationTile(
                  icon: Icons.favorite,
                  title: context.dataProvider.translate('my_favorites'),
                ),
              ),
              const SizedBox(height: 15),
              _buildSettingsSection(),
              const SizedBox(height: 15),
              _buildHelpSection(),
              const SizedBox(height: 30),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            context.dataProvider.translate('settings'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.6),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  return SwitchListTile(
                    secondary: Icon(
                      Icons.dark_mode,
                      color: AppColor.darkOrange,
                    ),
                    title: Text(
                      context.dataProvider.translate('dark_mode'),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    value: dataProvider.isDarkMode,
                    onChanged: (value) {
                      dataProvider.toggleDarkMode();
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.language, color: AppColor.darkOrange),
                title: Text(
                  context.dataProvider.translate('language'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showLanguageDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications, color: AppColor.darkOrange),
                title: Text(
                  context.dataProvider.translate('notifications'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.snackbar(
                    context.dataProvider.translate('notifications'),
                    context.dataProvider.currentLanguage == 'am'
                        ? 'የማሳወቂያ ቅንብሮች በቅርብ ጊዜ ይመጣሉ!'
                        : 'Notification settings coming soon!',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            context.dataProvider.translate('help'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.6),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.help, color: AppColor.darkOrange),
                title: Text(
                  context.dataProvider.translate('help_support'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                onTap: () {
                  _showHelpSupportDialog();
                },
              ),
              ListTile(
                leading: Icon(Icons.security, color: AppColor.darkOrange),
                title: Text(
                  context.dataProvider.translate('privacy_security'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                onTap: () {
                  Get.snackbar(
                    context.dataProvider.translate('privacy_security'),
                    context.dataProvider.currentLanguage == 'am'
                        ? 'የግላዊነት ቅንብሮች በቅርብ ጊዜ ይመጣሉ!'
                        : 'Privacy settings coming soon!',
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: AppColor.darkOrange),
                title: Text(
                  context.dataProvider.translate('about_app'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                onTap: () {
                  _showAboutDialog();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          _showLogoutConfirmation();
        },
        child: Text(
          context.dataProvider.translate('logout'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
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
    final dataProvider = context.dataProvider;

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

  void _showHelpSupportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.dataProvider.translate('help_support')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.email, color: AppColor.darkOrange),
                title: Text(context.dataProvider.translate('email_support')),
                subtitle: const Text('support@yourapp.com'),
                onTap: () {
                  Navigator.pop(context);
                  Get.snackbar(
                    context.dataProvider.translate('email_support'),
                    context.dataProvider.currentLanguage == 'am'
                        ? 'ኢሜይል ተልኳል: support@yourapp.com'
                        : 'Email sent to: support@yourapp.com',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone, color: AppColor.darkOrange),
                title: Text(context.dataProvider.translate('call_support')),
                subtitle: const Text('+1-234-567-8900'),
                onTap: () {
                  Navigator.pop(context);
                  Get.snackbar(
                    context.dataProvider.translate('call_support'),
                    context.dataProvider.currentLanguage == 'am'
                        ? 'የስልክ መጥሪያ: +1-234-567-8900'
                        : 'Call support: +1-234-567-8900',
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.dataProvider.translate('close')),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.dataProvider.translate('about_app')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.dataProvider.currentLanguage == 'am'
                    ? 'ይህ አስደሳች የመስመር ላይ ሻጭ መተግበሪያ ነው።'
                    : 'This is an amazing e-commerce app.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Version: 1.0.0',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.dataProvider.translate('close')),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.dataProvider.translate('logout') + '?'),
          content: Text(
            context.dataProvider.currentLanguage == 'am'
                ? 'ከመተግበሪያው መውጣት እፈልጋለሁ?'
                : 'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.dataProvider.currentLanguage == 'am' ? 'ተው' : 'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.userProvider.logOutUser();
                Get.offAll(() => const LoginScreen());
              },
              child: Text(
                context.dataProvider.translate('logout'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '2024';
    try {
      if (dateString.contains('T')) {
        DateTime date = DateTime.parse(dateString);
        return '${date.year}';
      } else {
        return dateString;
      }
    } catch (e) {
      return '2024';
    }
  }
}