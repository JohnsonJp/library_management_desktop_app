import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:library_management_desktop_app/model/book.dart';
import 'package:library_management_desktop_app/sql/sql.dart';
import 'package:overlay_support/overlay_support.dart';

class ExcelPage extends StatefulWidget {
  const ExcelPage({super.key});

  @override
  State<ExcelPage> createState() => _ExcelPageState();
}

class _ExcelPageState extends State<ExcelPage> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Button(
            child: const Text("Hey"),
            onPressed: () async {
              String? path = await _openFileExplorer();

              File f = File(path!);

              final input = f.openRead();
              List fields = await input
                  .transform(utf8.decoder)
                  .transform(const CsvToListConverter())
                  .toList();

              for (int i = 1; i < fields.length; i++) {
                log("passed");
                Book book = Book(
                  authour: fields[i][1],
                  isavailable: (fields[i][3] == "TRUE") ? true : false,
                  uniqueid: fields[i][0],
                  name: fields[i][2],
                );

                await SqlHelper().insertBook(book);

                if (i == fields.length - 1) {
                  if (mounted) {
                    setState(() {
                      _visible = true;
                    });
                  } else {
                    showSimpleNotification(
                      const Text("this is a message from simple notification"),
                      background: Colors.green,
                      duration: const Duration(seconds: 7),
                      position: NotificationPosition.bottom,
                    );
                  }
                }
              }
            },
          ),
          const Spacer(),
          if (_visible)
            InfoBar(
                title: const Text('Data inserted Sucessfully'),
                severity: InfoBarSeverity
                    .info, // optional. Default to InfoBarSeverity.info
                onClose: () {
                  // Dismiss the info bar
                  setState(() => _visible = false);
                }),
        ],
      ),
    );
  }

  Future<String?> _openFileExplorer() async {
    try {
      final paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ["csv"],
      ))
          ?.files;

      print(paths?.first.path);

      return paths?.first.path;
    } on PlatformException catch (e) {
      log("Unsupported operation$e");
    } catch (ex) {
      log(ex.toString());
    }
    return null;
  }
}
