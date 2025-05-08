import 'package:apartment_rentals/renter_dash_bord.dart';
import 'package:get/get.dart';

import '../../views/add_appartment/add_apartment_view.dart';
import '../../views/home/home_view.dart';
import '../../views/login/login_view.dart';
import '../../views/profile/update_profile_view.dart';
import '../../views/register/sigup_view.dart';
import '../../views/splash/splash_view.dart';
import 'routes_name.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.splashScreen,
          page: () => SplashScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        // GetPage(
        //   name: RouteName.landlordDashBord,
        //   page: () => LandlordDashBord(),
        //   transitionDuration: const Duration(milliseconds: 250),
        //   transition: Transition.leftToRightWithFade,
        // ),
        GetPage(
          name: RouteName.dashBord,
          page: () => RenterDashBord(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.sigUpScreen,
          page: () => SigUpScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.loginScreen,
          page: () => LoginInScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.homeScreen,
          page: () => HomeScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.updateProfileScreen,
          page: () => UpdateProfileScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: RouteName.addAppartmentScreen,
          page: () => AddAppartmentScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
      ];
}
