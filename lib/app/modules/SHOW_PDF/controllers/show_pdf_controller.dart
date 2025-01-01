import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowPdfController extends GetxController {
  final RxString _pdfPath = "".obs;
  String get pdfPath => _pdfPath.value;
  set pdfPath(String str) => _pdfPath.value = str;

  final RxString _pageCount = "".obs;
  String get pageCount => _pageCount.value;
  set pageCount(String str) => _pageCount.value = str;

  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

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
}
