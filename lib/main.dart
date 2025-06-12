import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kuebiko_client/kuebiko_client.dart';
import 'package:kuebiko_web_client/pages/404.dart';
import 'package:kuebiko_web_client/pages/book/book_detail.dart';
import 'package:kuebiko_web_client/pages/client_selection.dart';
import 'package:kuebiko_web_client/pages/library/libraries.dart';
import 'package:kuebiko_web_client/pages/library/library.dart';
import 'package:kuebiko_web_client/pages/library/overview.dart';
import 'package:kuebiko_web_client/pages/library/library_add.dart';
import 'package:kuebiko_web_client/pages/library/upload.dart';
import 'package:kuebiko_web_client/pages/loading.dart';
import 'package:kuebiko_web_client/pages/reader/horizontalv3.dart';
import 'package:kuebiko_web_client/pages/setup/setup.dart';
import 'generated/i18n/app_localizations.dart';
import 'pages/login.dart';
import 'url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(const KuebikoApp());
}

class KuebikoApp extends StatelessWidget {
  const KuebikoApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromRGBO(31, 32, 65, 1);
    const Color backgroundColor = Color.fromRGBO(235, 235, 211, 1);
    const Color shadowColor = Color.fromRGBO(75, 63, 114, 1);
    const Color accentColor = Color.fromRGBO(25, 100, 126, 1);
    const Color errorColor = Color.fromRGBO(211, 47, 47, 1);
    const Color textPrimaryColor = Color.fromRGBO(31, 32, 65, 0.85);
    const Color textSecondaryColor = Color.fromRGBO(31, 32, 65, 0.6);
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
        Widget targetPage;
        switch (routeName) {
          case '/':
            return null;
          case '/init':
            targetPage = const LoadingPage();
          case '/client-selection':
            targetPage = const ClientSelectionPage();
          case LoginPage.route:
            targetPage = LoginPage();
          case LibrariesPage.route:
            targetPage = const LibrariesPage();
          case OverviewPage.route:
            targetPage = const OverviewPage();
          case LibraryAddPage.route:
            targetPage = LibraryAddPage();
          case UploadPage.route:
            targetPage = const UploadPage();
          case BookDetailPage.route:
            Book book = routeSettings.arguments as Book;
            targetPage = BookDetailPage(book: book);
          case '/book/read':
            Book book = routeSettings.arguments as Book;
            targetPage = HorizontalV3ReaderPage(book: book,);
          case SetupPage.route:
            targetPage = const SetupPage();
          case LibraryPage.route:
            targetPage = const LibraryPage();
          default:
            targetPage = const PageNotFoundPage();
        }
        return MaterialPageRoute(builder: (context) => targetPage);
      },
      title: 'Kuebiko App',
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: backgroundColor,
          primaryColor: primaryColor,
          shadowColor: shadowColor,
          highlightColor: accentColor,
          cardColor: backgroundColor,
          dividerColor: shadowColor.withOpacity(0.3),
          disabledColor: textSecondaryColor.withOpacity(0.5),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: primaryColor,
            onPrimary: backgroundColor,
            secondary: accentColor,
            onSecondary: backgroundColor,
            error: errorColor,
            onError: backgroundColor,
            surface: backgroundColor,
            onSurface: textPrimaryColor,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: textPrimaryColor, fontSize: 16),
            bodyMedium: TextStyle(color: textPrimaryColor, fontSize: 14),
            titleLarge: TextStyle(color: textPrimaryColor, fontSize: 22, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(color: textPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold),
            labelLarge: TextStyle(color: textPrimaryColor, fontSize: 16),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
            foregroundColor: backgroundColor,
            //elevation: 4,
            //shadowColor: shadowColor,
            titleTextStyle: TextStyle(
              color: shadowColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: shadowColor),
          ),
          inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(
                  color: shadowColor
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: shadowColor
                  )
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: accentColor,
                  width: 2.0,
                ),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: errorColor,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: errorColor,
                  width: 2.0,
                ),
              ),
              labelStyle: TextStyle(color: textPrimaryColor),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color?>(accentColor),
              foregroundColor: WidgetStateProperty.all<Color?>(backgroundColor),
              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
              elevation: WidgetStateProperty.all(3),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color?>(primaryColor),
              side: WidgetStateProperty.all(const BorderSide(color: primaryColor)),
              padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 25, vertical: 4)),
              /*shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),*/
            ),
          ),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color?>(primaryColor),
                  foregroundColor: WidgetStateProperty.all<Color?>(backgroundColor),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                  textStyle: WidgetStateProperty.all(
                      const TextStyle(
                          fontSize: 18,
                          color: backgroundColor
                      )
                  ),
                  /*shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )*/
              )
          ),
          cardTheme: CardThemeData(
            color: backgroundColor,
            elevation: 3,
            shadowColor: shadowColor,
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          dividerTheme: DividerThemeData(
            color: shadowColor.withOpacity(0.3),
            thickness: 1,
            space: 24,
          ),
          iconTheme: const IconThemeData(
            color: primaryColor,
            size: 24,
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: primaryColor,
            contentTextStyle: const TextStyle(color: backgroundColor),
            actionTextColor: accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ),
    );
  }
}
