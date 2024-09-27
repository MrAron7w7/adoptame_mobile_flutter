import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/*  

  RIVERPOD -> Manejamos el estado del cambio de tema en la aplicación.

*/

@Riverpod(keepAlive: true)
class ThemeProvider extends _$ThemeProvider {
  static const isDarkMode = 'isDarkMode';
  @override
  bool build() {
    return GetStorage().read(isDarkMode) ?? false;
  }

  void toggleTheme() {
    state = !state;
    GetStorage().write(isDarkMode, state);
  }

  void toggleThemeWeb({required bool value}) {
    GetStorage().write(isDarkMode, value);
  }
}
