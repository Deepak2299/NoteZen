import 'package:flutter/material.dart';
import 'package:note_app/providers/notification_service.dart';
import 'package:note_app/providers/theme_data_provider.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/screens/add_todo_screen.dart';
import 'package:note_app/screens/homescreen.dart';
import 'package:note_app/screens/splash_screen.dart';
import 'package:note_app/utils/theme_data_styles.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // <
  runApp(MultiProvider(
    providers: [
//      ChangeNotifierProvider(
//        create: (context) => NoteProvider(),
//      ),
      ChangeNotifierProvider(
        create: (context) => SignInProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    NotificationService().handleApplicationWasLaunchedFromNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NoteZen',
        theme: Styles.themeData(value.darkTheme, context),
        home: SplashScreen(),
      );
    });
  }
}
