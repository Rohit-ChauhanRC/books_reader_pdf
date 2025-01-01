import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';

import '../controllers/show_pdf_controller.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowPdfView extends GetView<ShowPdfController> {
  const ShowPdfView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.pageCount ?? "Page changed:")),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              controller.pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      // body: PDFView(
      //   filePath: controller.pdfPath,
      //   enableSwipe: true,
      //   swipeHorizontal: true,
      //   autoSpacing: true,
      //   pageFling: true,
      //   onRender: (pages) {
      //     print("PDF Rendered with $pages pages.");
      //     controller.pageCount = "Pages: 0/$pages";
      //   },
      //   onError: (error) {
      //     print("Error while loading PDF: $error");
      //   },
      //   onPageError: (page, error) {
      //     print("Error on page $page: $error");
      //   },
      //   onViewCreated: (controller) {
      //     print("PDF View created.");
      //   },
      //   onPageChanged: (page, total) {
      //     controller.pageCount = "Page changed: $page/$total";
      //   },
      // ),
      body: SfPdfViewer.file(
        File(controller.pdfPath),
        key: controller.pdfViewerKey,
        enableTextSelection: true,
      ),
    );
  }
}
