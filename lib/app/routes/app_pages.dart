import 'package:get/get.dart';

import '../modules/SHOW_PDF/bindings/show_pdf_binding.dart';
import '../modules/SHOW_PDF/views/show_pdf_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/landing/bindings/landing_binding.dart';
import '../modules/landing/views/landing_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_PDF,
      page: () => const ShowPdfView(),
      binding: ShowPdfBinding(),
    ),
    GetPage(
      name: _Paths.LANDING,
      page: () => const LandingView(),
      binding: LandingBinding(),
    ),
  ];
}
