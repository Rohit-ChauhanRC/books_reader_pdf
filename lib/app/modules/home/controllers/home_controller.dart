import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  //
  final RxList<String> _folderNames = <String>[].obs;
  List<String> get folderNames => _folderNames;
  set folderNames(List<String> lst) => _folderNames.assignAll(lst);

  List<FileSystemEntity> files = [];

  final RxString _folderPath = "".obs;
  String get folderPath => _folderPath.value;
  set folderPath(String str) => _folderPath.value = str;

  final RxList<Map<String, String>> _pdfFiles = <Map<String, String>>[].obs;
  List<Map<String, String>> get pdfFiles => _pdfFiles;
  set pdfFiles(List<Map<String, String>> lst) => _pdfFiles.assignAll(lst);

  // String folderPath = "";
  String baseFold = '';

  @override
  void onInit() async {
    super.onInit();
    await listPdfFiles();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> listPdfFiles() async {
    try {
      // Get the base directory
      final Directory? appDir = Directory("/storage/emulated/0/Download");

      // Define the root folder
      final String rootFolderPath = '${appDir!.path}/Books';
      final baseFolder = Directory(rootFolderPath);
      baseFold = baseFolder.path;
      final entities = baseFolder.listSync(recursive: true);
      final pdfFilesList = entities
          .where((entity) =>
              FileSystemEntity.isFileSync(entity.path) &&
              entity.path.endsWith('.pdf'))
          .map((file) => {
                'name': file.path.split('/').last,
                'path': file.path,
              })
          .toList();

      pdfFiles = pdfFilesList;
    } catch (e) {
      if (kDebugMode) {
        print("Error reading PDF files: $e");
      }
    }
  }
}
