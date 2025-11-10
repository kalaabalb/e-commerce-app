import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/data/data_provider.dart';
import 'core/routes/app_pages.dart';
import 'services/admin_auth_service.dart';
import 'services/http_services.dart';
import 'screens/auth/login_screen.dart';
import 'screens/brands/provider/brand_provider.dart';
import 'screens/category/provider/category_provider.dart';
import 'screens/coupon_code/provider/coupon_code_provider.dart';
import 'screens/dashboard/provider/dash_board_provider.dart';
import 'screens/main/main_screen.dart';
import 'screens/main/provider/main_screen_provider.dart';
import 'screens/notification/provider/notification_provider.dart';
import 'screens/order/provider/order_provider.dart';
import 'screens/posters/provider/poster_provider.dart';
import 'screens/sub_category/provider/sub_category_provider.dart';
import 'screens/variants/provider/variant_provider.dart';
import 'screens/variants_type/provider/variant_type_provider.dart';
import 'screens/ratings/provider/rating_provider.dart';
import 'utility/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for local storage
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(create: (context) => MainScreenProvider()),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SubCategoryProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => BrandProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => VariantTypeProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => VariantProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DashBoardProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CouponCodeProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PosterProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (context) => RatingProvider()),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(
            Provider.of<DataProvider>(context, listen: false),
          ),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Admin Panel',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ).apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        initialRoute: AppPages.LOGIN,
        unknownRoute: GetPage(name: '/notFound', page: () => LoginScreen()),
        defaultTransition: Transition.cupertino,
        getPages: AppPages.routes,
        initialBinding: BindingsBuilder(() {
          Get.lazyPut(() => HttpService(), fenix: true);
          Get.lazyPut(() => AdminAuthService(), fenix: true);
        }),
      ),
    );
  }
}
