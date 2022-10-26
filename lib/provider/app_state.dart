import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  Brightness currentBrightness = Brightness.dark;

  AppState() {
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool("isDark") ?? false) {
      currentBrightness = Brightness.light;
    } else {
      currentBrightness = Brightness.dark;
    }
  }

  Future<void> toggleBrightness() async {
    currentBrightness = currentBrightness == Brightness.dark
        ? Brightness.light
        :Brightness.dark;

    (await SharedPreferences.getInstance())
        .setBool("isDark", currentBrightness == Brightness.dark);

    notifyListeners();
  }
}
