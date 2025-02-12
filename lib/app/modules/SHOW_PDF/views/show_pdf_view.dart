import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';

import '../controllers/show_pdf_controller.dart';
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
          // IconButton(
          //   icon: const Icon(Icons.save),
          //   onPressed: controller.savePdfWithAnnotations,
          // ),
          // Obx(() => IconButton(
          //       icon: Icon(controller.isHighlighting.value
          //           ? Icons.highlight
          //           : Icons.highlight_outlined),
          //       onPressed: controller.toggleHighlight,
          //     )),
          // Obx(() => IconButton(
          //       icon: Icon(controller.isDrawing.value
          //           ? Icons.edit
          //           : Icons.edit_outlined),
          //       onPressed: controller.toggleDrawing,
          //     )),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.file(
            File(controller.pdfPath),
            key: controller.pdfViewerKey,
            enableTextSelection: true,
            controller: controller.pdfViewerController,
            onDocumentLoaded: (details) {
              controller.onDocumentLoaded(details);

              final List<Annotation> annotations =
                  controller.pdfViewerController.getAnnotations();
              if (annotations.isNotEmpty) {
                final Annotation annotation = annotations.first;
                if (annotation is HighlightAnnotation) {
                  final Color color = annotation.color;
                  final double opacity = annotation.opacity;
                }
              }
            },
            onTextSelectionChanged: controller.onTextSelectionChanged,
            canShowTextSelectionMenu: false,
            pageLayoutMode: PdfPageLayoutMode.single,
            interactionMode: PdfInteractionMode.selection,
          ),

          // if (controller.overlayEntry.value != null)
          //   controller.overlayEntry.value!.builder(context),
          if (controller.overlayEntry.value != null)
            Overlay(
              initialEntries: [controller.overlayEntry.value!],
            ),
        ],
      ),
      // floatingActionButton: IconButton(
      //     icon: const Icon(
      //       Icons.add_circle_sharp,
      //       color: Colors.lightGreen,
      //       size: 40,
      //     ),
      //     onPressed: () {
      //       controller.sele();
      //     }),
    );
  }

  Widget _buildDrawingCanvas() {
    return GestureDetector(
      onPanUpdate: (details) {
        // Future implementation for drawing
      },
      child: Container(color: Colors.yellow),
    );
  }
}
