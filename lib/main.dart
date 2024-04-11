import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/layout/home_screen/provider/home_provider.dart';
import 'package:todoapp/shared/provider/auth_provider.dart';
import 'package:todoapp/style/theme.dart';
 import 'firebase_options.dart';
import 'layout/home_screen/home_screen.dart';
import 'layout/home_screen/widget/edit_widget.dart';
import 'layout/login/login_screen.dart';
import 'layout/register/register_screen.dart';
import 'layout/splash_screen/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

 void  main() async {
   WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [
        //btdek list mn al provider msh provider wahed
        ChangeNotifierProvider(create:  (context) => Authprovider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Authprovider provider=Provider.of<Authprovider>(context);
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('ar'), //  arby
      ],
      locale: Locale(provider.language),

      routes: {
        EditWidget.routeName:(context) => EditWidget(),
        LoginScreen.routeName:(context) => LoginScreen(),
        RegisterScreen.routeName:(context) => RegisterScreen(),
        HomeScreen.routeName:(context) => ChangeNotifierProvider(
            create:(context) => HomeProvider(),
            child: HomeScreen()),
        SplashScreen.routeName:(context) => SplashScreen(),
      },
      initialRoute: SplashScreen.routeName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.DarkTheme,
      themeMode:provider.theme,
      //home: EditWidget(),
      

    );
  }
}
