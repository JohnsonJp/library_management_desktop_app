import 'package:fluent_ui/fluent_ui.dart';
import 'package:library_management_desktop_app/pages/addbook.dart';
import 'package:library_management_desktop_app/pages/books.dart';
import 'package:library_management_desktop_app/pages/excel.dart';
import 'package:library_management_desktop_app/provider/app_state.dart';
import 'package:library_management_desktop_app/provider/books_provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  windowManager.setMinimumSize(const Size(700, 700));

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
  @override
  Widget build(BuildContext context) {
    return NavigationView(
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
              icon: const Icon(FluentIcons.user_followed),
              body: const BookPage(),
              title: const Text("Book"),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.add_friend),
              body: const AddBook(),
              title: const Text("Add Books"),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.add_friend),
              body: const ExcelPage(),
              title: const Text("upload Excel"),
            ),
          ]),
    );
  }
}
