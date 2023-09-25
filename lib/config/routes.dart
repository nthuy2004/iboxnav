import 'package:get/get.dart';
import 'package:iboxnav/controllers/home/home_binding.dart';
import 'package:iboxnav/controllers/vehicle_inspect_detail/inspect_detail_binding.dart';
import 'package:iboxnav/controllers/vehicle_detail/vehicle_detail_binding.dart';
import 'package:iboxnav/controllers/vehicle_report/vehicle_report_binding.dart';
import 'package:iboxnav/presentation/pages/auth/login_page.dart';
import 'package:iboxnav/presentation/pages/contact/contact_page.dart';
import 'package:iboxnav/presentation/pages/home/home_page.dart';
import 'package:iboxnav/presentation/pages/vehicle_inspect_detail/inspect_detail_page.dart';
import 'package:iboxnav/presentation/pages/splash/splash_page.dart';
import 'package:iboxnav/presentation/pages/vehicle_detail/vehicle_detail_page.dart';
import 'package:iboxnav/presentation/pages/vehicle_list/vehicle_search.dart';
import 'package:iboxnav/presentation/pages/vehicle_report/vehicle_report_detail_page.dart';

class Routes {
  static const initialRoute = "/splash";
  static getAll() {
    return <GetPage>[
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(
        name: "/login",
        page: () => const LoginPage(),
        transition: Transition.fade,
      ),
      GetPage(
        name: "/homepage",
        page: () => HomePage(),
        binding: HomeBinding(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: "/vehiclesearch",
        page: () => const VehicleSearchPage(),
        transition: Transition.cupertino,
      ),
      GetPage(
        name: "/vehicledetail/:id",
        page: () => const VehicleDetailPage(),
        binding: VehicleDetailBinding(),
        transition: Transition.cupertino,
      ),
      GetPage(
          name: "/inspectdetail",
          page: () => const InspectDetailPage(),
          transition: Transition.cupertino,
          binding: InspectDetailBinding()),
      GetPage(
          name: "/contact",
          page: () => const ContactPage(),
          transition: Transition.cupertino),
      GetPage(
        name: "/reportdetail/:report",
        page: () => VehicleReportDetailPage(),
        binding: VehicleReportBinding(),
        transition: Transition.cupertino,
      )
    ];
  }
}
