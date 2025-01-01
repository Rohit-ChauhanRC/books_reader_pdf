import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> permisions() async {
  await Permission.storage.request();
  await Permission.camera.request();
  await Permission.mediaLibrary.request();
  await Permission.microphone.request();
  await Permission.photos.request();
  await Permission.notification.request();
  await Permission.manageExternalStorage.request();
  await Permission.location.request();
  await Permission.locationWhenInUse.request();
  await Permission.locationAlways.request();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await permisions();

  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Book Readers",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
