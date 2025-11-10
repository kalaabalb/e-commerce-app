import 'package:admin_panal_start/services/http_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../../services/admin_auth_service.dart';
import '../../../utility/constants.dart';
import '../../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool _isLoading = false.obs;
  final RxBool _obscurePassword = true.obs;

  @override
  void initState() {
    super.initState();

    // Test connection on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _testConnection();
    });

    // Auto-fill for development
    if (kDebugMode) {
      _usernameCtrl.text = 'superadmin';
      _passwordCtrl.text = 'admin123';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding * 2),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(defaultPadding * 2),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo and Title Section
                _buildHeaderSection(),
                const SizedBox(height: defaultPadding * 2),

                // Login Form
                _buildLoginForm(),

                // Development Helper
                if (kDebugMode) _buildDevelopmentHelper(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _testConnection() async {
    try {
      final response =
          await Get.find<HttpService>().getItems(endpointUrl: 'health');
      print('🔗 Connection test response: ${response.statusCode}');
      print('🔗 Response body: ${response.body}');
    } catch (e) {
      print('🔗 Connection test failed: $e');
    }
  }

  void _clearCachedData() {
    final storage = GetStorage();
    storage.remove('auth_token');
    storage.remove('user_data');
    Get.find<AdminAuthService>().logout();
    print('🧹 Cleared cached auth data');
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.admin_panel_settings,
              color: Colors.white, size: 40),
        ),
        const SizedBox(height: defaultPadding * 1.5),

        // Title
        Text(
          'Admin Panel',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: defaultPadding / 2),
        Text(
          'Sign in to continue',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _usernameCtrl,
            labelText: 'Username',
            prefixIcon: const Icon(Icons.person, color: Colors.white70),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter username';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          Obx(() => CustomTextField(
                controller: _passwordCtrl,
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                obscureText: _obscurePassword.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
                  ),
                  onPressed: () => _obscurePassword.toggle(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              )),
          const SizedBox(height: defaultPadding * 2),

          // Login Button
          Obx(() => _buildLoginButton()),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading.value ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 5,
      ),
      child: _isLoading.value
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Sign In',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }

  Widget _buildDevelopmentHelper() {
    return Column(
      children: [
        const SizedBox(height: defaultPadding * 2),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.developer_mode, color: Colors.orange, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Development Helper',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Default credentials: superadmin / admin123',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final adminAuthService = Get.find<AdminAuthService>();

    // Close keyboard
    FocusScope.of(context).unfocus();

    _isLoading.value = true;

    try {
      final result = await adminAuthService.login(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text,
      );

      if (result.success) {
        Get.offAllNamed('/main');
        Get.snackbar(
          'Success',
          'Login successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Login Failed',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}
