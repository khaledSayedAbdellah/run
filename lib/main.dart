import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_map_booking/Prefs/pref_manager.dart';
import 'package:flutter_map_booking/language/app_language.dart';
import 'package:flutter_map_booking/localization/app_localization.dart';
import 'package:provider/provider.dart';

import 'Blocs/place_bloc.dart';
import 'app_router.dart';
import 'package:flutter/material.dart';
import 'Screen/SplashScreen/splash_screen.dart';
import 'theme/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PrefManager.initUserData();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlaceBloc>(create: (_) => PlaceBloc()),
        ChangeNotifierProvider<AppLanguage>(create: (_) => AppLanguage()),
      ],
      child: Consumer<AppLanguage>(
        builder: (context, appLanguage, child) {
          return MaterialApp(
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            locale: appLanguage.appLocale,
            theme: ThemeData(
              primaryColor: primaryColor,
              buttonColor: primaryColor,
              indicatorColor: Colors.white,
              splashColor: Colors.white24,
              splashFactory: InkRipple.splashFactory,
              accentColor: const Color(0xFF13B9FD),
              canvasColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              errorColor: const Color(0xFFB00020),
              iconTheme: new IconThemeData(color: primaryColor),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
              fontFamily: appLanguage.appLanguage == "ar" ? "Tajawal" : "Lucida",
            ),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoute.generateRoute,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
