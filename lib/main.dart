import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kuebiko_web_client/pages/404.dart';
import 'package:kuebiko_web_client/pages/client_selection.dart';
import 'package:kuebiko_web_client/pages/loading.dart';
import 'package:kuebiko_web_client/pages/setup/setup.dart';
import 'generated/i18n/app_localizations.dart';
import 'pages/reader/horizontalv3.dart';
import 'url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromRGBO(31, 32, 65, 1);
    const Color backgroundColor = Color.fromRGBO(235, 235, 211, 1);
    const Color shadowColor = Color.fromRGBO(75, 63, 114, 1);
    return MaterialApp(
      initialRoute: '/client-selection',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('de'), // German
      ],
      onGenerateRoute: (RouteSettings routeSettings){
        String routeName = routeSettings.name!;
        List<String> routeList = routeName.split('/');
        switch (routeList[1]) {
          case '':
            break;
          case 'init':
            return MaterialPageRoute(
                builder: (context) => const LoadingPage()
            );
          case 'client-selection':
            return MaterialPageRoute(
                builder: (context) => const ClientSelectionPage()
            );
          case 'setup':
            return MaterialPageRoute(
                builder: (context) => const SetupPage()
            );
          default:
            return MaterialPageRoute(
                builder: (context) => const PageNotFoundPage()
            );
        }
        return null;
      },
      title: 'Kuebiko App',
      theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor,
          primaryColor: primaryColor,
          shadowColor: shadowColor,
          highlightColor: const Color.fromRGBO(25, 100, 126, 1),
          inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(
                  color: shadowColor
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: shadowColor
                  )
              )
          ),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color?>(primaryColor),
                  foregroundColor: WidgetStateProperty.all<Color?>(backgroundColor),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 20)),
                  textStyle: WidgetStateProperty.all(
                      const TextStyle(
                          fontSize: 18,
                          color: backgroundColor
                      )
                  )
              )
          )
      ),
    );
  }
}
