import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:library_management_desktop_app/pages/Staff.dart';
import 'package:library_management_desktop_app/pages/addbook.dart';
import 'package:library_management_desktop_app/pages/addstaff.dart';
import 'package:library_management_desktop_app/pages/books.dart';
import 'package:library_management_desktop_app/pages/excel.dart';
import 'package:library_management_desktop_app/provider/app_state.dart';
import 'package:library_management_desktop_app/provider/books_provider.dart';
import 'package:library_management_desktop_app/provider/staffs_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  windowManager.setMinimumSize(const Size(780, 700));

  await flutter_acrylic.Window.initialize();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setSize(const Size(760, 545));
    await windowManager.setMinimumSize(const Size(350, 600));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setPreventClose(false);
    await windowManager.setSkipTaskbar(false);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
          ChangeNotifierProvider(create: (_) => BooksProvider()),
          ChangeNotifierProvider(create: (_) => StaffProvider()),
        ],
        builder: (_, __) => FluentApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(brightness: Brightness.dark),
          home: const Home(),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedindex = 0;
  final viewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            width: 138,
            height: 50,
            child: WindowCaption(
              brightness: FluentTheme.of(context).brightness,
              backgroundColor: Colors.transparent,
            ),
          ),
        ]),
        automaticallyImplyLeading: false,
        title: () {
          return const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Library Management",
              ),
            ),
          );
        }(),
      ),
      pane: NavigationPane(
          displayMode: PaneDisplayMode.auto,
          selected: selectedindex,
          onChanged: (value) {
            setState(() {
              selectedindex = value;
            });
          },
          items: [
            PaneItem(
              icon: const FaIcon(FontAwesomeIcons.book),
              body: const BookPage(),
              title: const Text("Book"),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.add),
              body: const AddBook(),
              title: const Text("Add Books"),
            ),
            PaneItem(
              icon: const FaIcon(FontAwesomeIcons.user),
              body: const StaffPage(),
              title: const Text("Staffs"),
            ),
            PaneItem(
              icon: const FaIcon(FontAwesomeIcons.userPlus),
              body: const AddStaff(),
              title: const Text("Add Staff"),
            ),
            PaneItem(
              icon: const FaIcon(FontAwesomeIcons.fileExcel),
              body: const ExcelPage(),
              title: const Text("upload Excel"),
            ),
          ]),
    );
  }
}