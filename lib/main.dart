import 'package:flutter/material.dart';
import 'package:music_player/screens/home.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:music_player/utils/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
          primarySwatch: Colors.blue,
          brightness: brightness,
          primaryIconTheme: const IconThemeData.fallback().copyWith(
            color: Colors.black,
          ),
    ),
    themedWidgetBuilder: (context, theme) {
      return MaterialApp(onGenerateTitle: (BuildContext context) =>
      MyLocalizations
          .of(context)
          .title,
        localizationsDelegates: [
          const MyLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('es', ''),
          const Locale('fr', ''),
          const Locale('de', ''),
          const Locale('ru', ''),
        ],
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: TabView(),
        routes: {
        '/home': (context)=>TabView()
        },
      );
    }
    );
  }
}


