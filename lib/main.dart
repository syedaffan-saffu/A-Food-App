import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/firebase_options.dart';
import 'package:rajputfoods/pages/intro/intropage1.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/pages/bottomnavpage.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = SharedprefStoreUser();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => TabIndexProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => UserIdProvider(prefs),
    ),
    ChangeNotifierProvider(
      create: (_) => ItemIndexProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => LocationProvider(),
    ),
  ], child: const MyApp()));
}

GlobalKey<NavigatorState> rootnavkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserIdProvider>(context);
    print("main :::::::::::::::::::: ${userprovider.userid}");
    return MaterialApp(
      navigatorKey: rootnavkey,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE21B1B)),
          indicatorColor: Colors.red,
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: Color(0xFFE21B1B)),
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          listTileTheme: const ListTileThemeData(
            tileColor: Color(0xFFFFFFFF),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF555555),
            selectionHandleColor: Color(0xFFE21B1B),
          ),
          useMaterial3: true,
          fontFamily: "Montserrat",
          cardTheme: CardTheme(
              color: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE21B1B),
              foregroundColor: const Color(0xFFFFFFFF),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: "Montserrat",
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Button shape
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFE21B1B)))),
      title: "Rajput Foods",
      home:
          //  PagewithBottomBar(),
          userprovider.isloggedin
              ? const PagewithBottomBar()
              : const Intropage1(),
    );
  }
}
