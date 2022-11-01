import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:library_management_desktop_app/model/book.dart';
import 'package:library_management_desktop_app/provider/app_state.dart';
import 'package:library_management_desktop_app/sql/sql.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../model/borrow.dart';
import '../model/staff.dart';

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
          SizedBox(
            height: 50,
            width: 200,
            child: Button(
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Create Table"),
                ),
                onPressed: () async {
                  await SqlHelper().createTable();
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: Button(
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Upload book from excel"),
              ),
              onPressed: () async {
                String? path = await _openFileExplorer();

                File f = File(path!);

                final input = f.openRead();
                List fields = await input
                    .transform(utf8.decoder)
                    .transform(const CsvToListConverter())
                    .toList();

                for (int i = 150; i < fields.length; i++) {
                  log("passed ${fields[i].toString()}");
                  Book book = Book(
                    authour: fields[i][1],
                    isavailable: true,
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
                        const Text(
                            "Book Data from Excel imported Successfully"),
                        background: Colors.green,
                        duration: const Duration(seconds: 7),
                        position: NotificationPosition.bottom,
                      );
                    }
                  }
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: Button(
              onPressed: () async {
                await backup();
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text("Backup Data"),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 60,
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  onPressed: () async {
                    await restore();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Import Data"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child:
                      Consumer<AppState>(builder: (_, AppState appState, __) {
                    return appState.importProgress == 0
                        ? const SizedBox()
                        : ProgressBar(value: appState.importProgress);
                  }),
                ),
              ],
            ),
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

  Future<bool> backup() async {
    List<String> books =
        (await SqlHelper().getBooks()).map((book) => book.toJson()).toList();
    List<String> staffs =
        (await SqlHelper().getStaffs()).map((staff) => staff.toJson()).toList();
    List<String> borrows = (await SqlHelper().getborrow())
        .map((borrow) => borrow.toJson())
        .toList();

    Map backupData = {"books": books, "staffs": staffs, "borrows": borrows};

    String path = (await getApplicationDocumentsDirectory()).path;
    File backupFile = File("$path\\backup.json");

    await backupFile.writeAsString(jsonEncode(backupData));

    showSimpleNotification(
      const Text("Backup completed successfully"),
      background: Colors.blue,
      duration: const Duration(seconds: 2),
      position: NotificationPosition.bottom,
    );

    return true;
  }

  Future<bool> restore() async {
    AppState appState = Provider.of<AppState>(context, listen: false);

    String path = (await getApplicationDocumentsDirectory()).path;
    File backupFile = File("$path\\backup.json");

    String fileData = await backupFile.readAsString();
    Map importedData = jsonDecode(fileData);

    List<Map<String, dynamic>> books = List<Map<String, dynamic>>.from(
        importedData["books"].map((e) => jsonDecode(e)).toList());
    List<Map<String, dynamic>> staffs = List<Map<String, dynamic>>.from(
        importedData["staffs"].map((e) => jsonDecode(e)).toList());
    List<Map<String, dynamic>> borrow = List<Map<String, dynamic>>.from(
        importedData["borrows"].map((e) => jsonDecode(e)).toList());

    SqlHelper sql = SqlHelper();
    sql.db = sql.openDb();
    int totalProgress = books.length + staffs.length + borrow.length;

    for (int i = 0; i < books.length; i++) {
      await sql.importBook(books[i]);
      appState.updateImportProgress = (i / totalProgress) * 100;
    }

    showSimpleNotification(
      const Text("Books imported successfully"),
      background: Colors.blue,
      duration: const Duration(seconds: 2),
      position: NotificationPosition.bottom,
    );

    for (int i = 0; i < staffs.length; i++) {
      await sql.importStaff(staffs[i]);
      appState.updateImportProgress =
          ((i + books.length) / totalProgress) * 100;
    }

    showSimpleNotification(
      const Text("Staffs imported successfully"),
      background: Colors.blue,
      duration: const Duration(seconds: 2),
      position: NotificationPosition.bottom,
    );

    for (int i = 0; i < borrow.length; i++) {
      await sql.importBorrow(borrow[i]);
      appState.updateImportProgress =
          ((i + books.length + staffs.length) / totalProgress) * 100;
    }

    showSimpleNotification(
      const Text("Borrow imported successfully"),
      background: Colors.blue,
      duration: const Duration(seconds: 2),
      position: NotificationPosition.bottom,
    );

    appState.updateImportProgress = 0;
    sql.closeDB();

    showSimpleNotification(
      const Text("All imports successfully"),
      background: Colors.blue,
      duration: const Duration(seconds: 2),
      position: NotificationPosition.bottom,
    );

    return true;
  }
}
