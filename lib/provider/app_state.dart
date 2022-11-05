import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  Brightness currentBrightness = Brightness.dark;

  double importProgress = 0;
  double importBookFromExcel = 0;

  AppState() {
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("is dark : ${prefs.getBool('isDark')}");

    if (prefs.getBool("isDark") ?? true) {
      currentBrightness = Brightness.dark;
    } else {
      currentBrightness = Brightness.light;
    }
  }

  Future<void> toggleBrightness() async {
    currentBrightness = currentBrightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    (await SharedPreferences.getInstance())
        .setBool("isDark", currentBrightness == Brightness.dark);

    notifyListeners();
  }

  set updateImportProgress(double value) {
    importProgress = value;

    notifyListeners();
  }

  set updateImportBookFromExcelProgress(double value) {
    importBookFromExcel = value;

    notifyListeners();
  }
}
