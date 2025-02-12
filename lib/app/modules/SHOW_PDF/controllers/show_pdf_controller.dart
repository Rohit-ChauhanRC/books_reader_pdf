import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:printing/printing.dart';

class ShowPdfController extends GetxController {
  final RxString _pdfPath = "".obs;
  String get pdfPath => _pdfPath.value;
  set pdfPath(String str) => _pdfPath.value = str;

  final RxString _pdfName = "".obs;
  String get pdfName => _pdfName.value;
  set pdfName(String str) => _pdfName.value = str;

  final RxString _pageCount = "".obs;
  String get pageCount => _pageCount.value;
  set pageCount(String str) => _pageCount.value = str;

  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

  RxBool isHighlighting = false.obs;
  RxBool isDrawing = false.obs;
  Rx<PdfDocument?> pdfDocument = Rx<PdfDocument?>(null);

  var pdfViewerController = PdfViewerController();

  Rx<OverlayEntry?> overlayEntry = Rx<OverlayEntry?>(null);

  final RxList<Uint8List> pageImages = <Uint8List>[].obs; // Store page images

  RxList<File> imageFiles = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    pdfPath = Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> convertPdfToImages() async {
    final File file = File(pdfPath);
    final Uint8List pdfBytes = await file.readAsBytes();

    // Load the PDF document
    final PdfDocument document = PdfDocument(inputBytes: pdfBytes);

    for (int i = 0; i < document.pages.count; i++) {
      final PdfPage page = document.pages[i];

      //  imageFiles
    }

    document.dispose(); // Dispose the document to free memory
  }

  void toggleHighlight() {
    isHighlighting.value = !isHighlighting.value;
    isDrawing.value = false;
  }

  void toggleDrawing() {
    isDrawing.value = !isDrawing.value;
    isHighlighting.value = false;
  }

  void onDocumentLoaded(PdfDocumentLoadedDetails details) {
    pdfDocument.value = details.document;
  }

  void onTextSelectionChanged(PdfTextSelectionChangedDetails details) {
    if (details.selectedText == null && overlayEntry.value != null) {
      overlayEntry.value!.remove();
      overlayEntry.value = null;
    } else if (details.selectedText != null && overlayEntry.value == null) {
      showContextMenu(Get.context!, details);
    }
  }

  void showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    if (details.selectedText == null) {
      removeOverlay();
      return;
    }

    final OverlayState overlayState = Overlay.of(Get.overlayContext!);
    if (overlayState == null) {
      Get.snackbar("Error", "No Overlay found");
      return;
    }
    final Size screenSize = MediaQuery.of(context).size;

    double top = details.globalSelectedRegion!.top >= screenSize.height / 2
        ? details.globalSelectedRegion!.top - 250 - 10
        : details.globalSelectedRegion!.bottom + 20;

    double left = details.globalSelectedRegion!.bottomLeft.dx;
    left = left + 150 > screenSize.width ? screenSize.width - 150 - 10 : left;

    overlayEntry.value = OverlayEntry(
      builder: (context) => Positioned(
        top: top,
        left: left,
        child: Material(
          elevation: 4,
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _menuItem('Copy', () {
                  Clipboard.setData(ClipboardData(text: details.selectedText!));
                  removeOverlay();
                }),
                _menuItem(
                    'Highlight', () => addAnnotation(details, 'highlight')),
                _menuItem(
                    'Underline', () => addAnnotation(details, 'underline')),
                _menuItem('Strikethrough',
                    () => addAnnotation(details, 'strikethrough')),
                _menuItem('Squiggly', () => addAnnotation(details, 'squiggly')),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry.value!);
  }

  Widget _menuItem(String text, VoidCallback onTap) {
    return TextButton(
      onPressed: () {
        onTap();
        removeOverlay();
      },
      child: Text(text, style: const TextStyle(fontSize: 15)),
    );
  }

  void removeOverlay() {
    overlayEntry.value?.remove();
    overlayEntry.value = null;
    pdfViewerController.clearSelection();
  }

  // void addAnnotation(PdfTextSelectionChangedDetails details,
  //     PdfTextMarkupAnnotationType type) {
  //   final List<PdfTextLine>? textLines =
  //       pdfViewerKey.currentState?.getSelectedTextLines();
  //   if (textLines != null && textLines.isNotEmpty) {
  //     final annotation = PdfTextMarkupAnnotation(
  //       textLines.map((e) => e.bounds).first,
  //       type.toString().split('.').last,
  //       PdfColor(1, 1, 0, 1), // Convert enum to string
  //     );

  //     pdfViewerController.addAnnotation(annotation);
  //   }
  // }
  void addAnnotation(
      PdfTextSelectionChangedDetails details, String annotationType) async {
    final List<PdfTextLine>? textLines =
        pdfViewerKey.currentState?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final annotation = _createAnnotation(annotationType, textLines);
      if (annotation != null) {
        pdfViewerController.addAnnotation(annotation);

        PdfTextMarkupAnnotation textMarkupAnnotation = PdfTextMarkupAnnotation(
          details.globalSelectedRegion!, // ✅ Use first bounding box
          details.selectedText.toString(), // ✅ Set selected text
          PdfColor(255, 255, 0, 100),
          // ✅ Set type properly
          subject: annotation.subject, // ✅ Store type in subject
        );
        pdfDocument.value?.pages[annotation.pageNumber].annotations
            .add(textMarkupAnnotation as PdfAnnotation);

        await File(pdfPath).writeAsBytes(await pdfDocument.value!.save());
        // pdfViewerController.clearSelection();
        Get.snackbar("Success", "Annotation Added & PDF Saved!");
      }
    }
  }

  Annotation? _createAnnotation(
      String annotationType, List<PdfTextLine> textLines) {
    switch (annotationType) {
      case 'highlight':
        return HighlightAnnotation(textBoundsCollection: textLines);
      case 'underline':
        return UnderlineAnnotation(textBoundsCollection: textLines);
      case 'strikethrough':
        return StrikethroughAnnotation(textBoundsCollection: textLines);
      case 'squiggly':
        return SquigglyAnnotation(textBoundsCollection: textLines);
      default:
        return null;
    }
  }

  Future<void> savePdfWithAnnotations() async {
    List<int> bytes = await pdfDocument.value!.save();
    pdfDocument.value!.dispose();

    final File file = File(pdfPath);
    // await file.writeAsBytes(await pdfDocument.value!.save());
    await file.writeAsBytes(bytes);
    // pdfPath.value = filePath;
    Get.snackbar("Success", "PDF saved at: $pdfPath");
  }

  void sele() async {
    final List<PdfTextLine>? selectedTextLines =
        pdfViewerKey.currentState?.getSelectedTextLines();

    if (selectedTextLines != null && selectedTextLines.isNotEmpty) {
      // Creates a highlight annotation with the selected text lines.
      final HighlightAnnotation highlightAnnotation = HighlightAnnotation(
        textBoundsCollection: selectedTextLines,
      );
      // Adds the highlight annotation to the PDF document.
      pdfViewerController.addAnnotation(highlightAnnotation);
      File(pdfPath).writeAsBytes(await pdfDocument.value!.save());
    }
  }

  // void _highlightText(PdfTextSelectionChangedDetails details) {
  //   if (pdfDocument == null) return;

  //   int pageIndex = details.selectedTextRegion!.pageNumber;

  //   PdfTextMarkupAnnotation highlight = PdfTextMarkupAnnotation(
  //     details.globalSelectedRegion!,
  //     PdfTextMarkupAnnotationType.highlight as String,
  //     PdfColor(1, 1, 0, 1)
  //   );

  //   pdfDocument!.pages[details.startPageIndex].annotations.add(highlight);
  //   pdfViewerController.clearSelection();
  // }
  Future<void> _highlightText(PdfTextSelectionChangedDetails details) async {
    if (pdfDocument == null || details.selectedText == null) return;

    // Get the first page where text is selected
    int pageIndex =
        pdfViewerController.pageNumber - 1; // Adjusting for zero-based index

    PdfTextMarkupAnnotation highlight = PdfTextMarkupAnnotation(
      details.globalSelectedRegion!,
      details.selectedText.toString(),
      PdfColor(128, 43, 226),
      textMarkupAnnotationType: PdfTextMarkupAnnotationType.highlight,
      // No need for type casting
    ); // Yellow highlight

    pdfDocument.value!.pages[pageIndex].annotations.add(highlight);
    File(pdfPath).writeAsBytes(await pdfDocument.value!.save());
    // pdfViewerController.clearSelection();
  }
}
