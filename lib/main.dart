import 'package:flutter/material.dart';

import 'src/screens/home.dart';
import 'src/screens/favourites.dart';
import 'src/screens/settings.dart';
import 'src/utils/theme_data.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'src/utils/shared_pref.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Контроль.Гродно!',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/favourites': (context) =>
            const Favourites(title: 'Избранные остановки'),
        '/settings': (context) => const Settings(title: 'Настройки'),
      },
    );
  }
}

// theme: ThemeData(
//   pageTransitionsTheme: PageTransitionsTheme(
//     builders: {
//       TargetPlatform.android: buildTransitions(
//           BuildContext context,
//           Animation<double> animation,
//           Animation<double> secondaryAnimation,
//           Widget child,
//       ),
//     },
//   ),
// ),