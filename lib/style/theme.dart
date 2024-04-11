import 'package:flutter/material.dart';
import 'package:todoapp/style/app-colors.dart';
//hena h7ot al theme

class AppTheme{
  static  ThemeData lightTheme=ThemeData(
    floatingActionButtonTheme:FloatingActionButtonThemeData(
      backgroundColor: AppColors.PrimaryLightColor,
    ) ,
    appBarTheme: AppBarTheme(
      toolbarHeight: 100,
      titleTextStyle: TextStyle(color: Colors.white,fontSize: 20),
      backgroundColor: AppColors.PrimaryLightColor,
    ),
    scaffoldBackgroundColor: AppColors.LightbackgroundColor,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.PrimaryLightColor,
        primary:  AppColors.PrimaryLightColor,
      secondary: Colors.black
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.PrimaryLightColor,
      unselectedItemColor: AppColors.unselectedIconsColor ,
      showSelectedLabels: false,
      showUnselectedLabels: false,

    ),
    useMaterial3: false,

    textTheme: TextTheme(
      titleSmall: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColors.timeColor
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: AppColors.PrimaryLightColor
      ),
      labelMedium: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    ),
  );

  static  ThemeData DarkTheme=ThemeData(
    floatingActionButtonTheme:FloatingActionButtonThemeData(
      backgroundColor: AppColors.PrimaryDarkColor  ,
    ) ,
    appBarTheme: AppBarTheme(
      toolbarHeight: 100,
      titleTextStyle: TextStyle(color: Colors.black,fontSize: 20),
      backgroundColor: AppColors.PrimaryLightColor ,
    ),
    scaffoldBackgroundColor:Colors.black ,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.PrimaryDarkColor,
      primary:  AppColors.PrimaryDarkColor ,
      secondary: Colors.white
    ),


    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.DarkbackgroundColor,
      unselectedItemColor: Colors.white ,
      showSelectedLabels: false,
      showUnselectedLabels: false,

    ),
    useMaterial3: false,

    textTheme: TextTheme(
      titleSmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.white
      ),
      titleMedium: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppColors.PrimaryDarkColor
      ),
      labelMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    ),
  );

}