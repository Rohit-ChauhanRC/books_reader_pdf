import 'package:books_reader/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LandingController extends GetxController {
  //

  @override
  void onInit() async {
    await goToHome();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> goToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(Routes.HOME);
  }
}
