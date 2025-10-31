import 'package:e_commerce_flutter/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/app_color.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/page_wrapper.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;

  void _submit() async {
    if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar(
        context.dataProvider.translate('error'),
        context.dataProvider.translate('please_fill_all_fields'),
      );
      return;
    }

    if (!_isLogin &&
        _passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        context.dataProvider.translate('error'),
        context.dataProvider.translate('passwords_dont_match'),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await context.userProvider.loginUser(
          _nameController.text,
          _passwordController.text,
        );
      } else {
        await context.userProvider.registerUser(
          _nameController.text,
          _passwordController.text,
        );
      }

      Get.offAll(const HomeScreen());
    } catch (e) {
      Get.snackbar(context.dataProvider.translate('error'), e.toString());
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: PageWrapper(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.vertical,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/images/logo.png', height: 100),
                  const SizedBox(height: 40),
                  Text(
                    _isLogin
                        ? context.dataProvider.translate('login')
                        : context.dataProvider.translate('register'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColor.darkOrange,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _nameController,
                    labelText: context.dataProvider.translate('username'),
                    onSave: (value) {},
                    validator: (value) => value!.isEmpty
                        ? context.dataProvider.translate('enter_username')
                        : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: context.dataProvider.translate('password'),
                    onSave: (value) {},
                    validator: (value) => value!.isEmpty
                        ? context.dataProvider.translate('enter_password')
                        : null,
                    obscureText: true,
                  ),
                  if (!_isLogin) ...[
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: context.dataProvider.translate(
                        'confirm_password',
                      ),
                      onSave: (value) {},
                      validator: (value) => value!.isEmpty
                          ? context.dataProvider.translate('confirm_password')
                          : null,
                      obscureText: true,
                    ),
                  ],
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              _isLogin
                                  ? context.dataProvider.translate('login')
                                  : context.dataProvider.translate('register'),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? context.dataProvider.translate('dont_have_account')
                          : context.dataProvider.translate(
                              'already_have_account',
                            ),
                      style: const TextStyle(color: AppColor.darkOrange),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 100
                        : 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}