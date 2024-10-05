import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '/core/constants/app_route_view.dart';
import '/features/viewmodel/providers/theme_provider.dart';
import '/shared/theme/app_theme.dart';

//independencias de firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProviderProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Adoptame perro',
      theme: isDarkMode ? AppTheme.darkMode : AppTheme.lightMode,
      routerConfig: appRoute,
    );
  }
}




