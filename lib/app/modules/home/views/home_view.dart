import 'package:books_reader/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Downloaded Files'),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.pdfFiles.isEmpty
              ? const Center(child: Text("No PDF files found in the directory"))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Base Path: ${controller.folderPath}"),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.pdfFiles.length,
                        itemBuilder: (context, index) {
                          final pdf = controller.pdfFiles[index];
                          return ListTile(
                            leading: const Icon(Icons.picture_as_pdf,
                                color: Colors.red),
                            title: Text(pdf['name'] ?? 'Unknown'),
                            onTap: () {
                              Get.toNamed(Routes.SHOW_PDF,
                                  arguments:
                                      "${controller.baseFold}/${pdf['name']!}");
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ));
  }
}
