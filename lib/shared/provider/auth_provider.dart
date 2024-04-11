import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/model/user.dart' as MyUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/shared/remote/firebase/firestore_helper.dart';

//3shan ast5dm data bta3t al user fe al app kolo
class Authprovider extends ChangeNotifier {
  User? firebaseUserAuth; //da bta3 al auth //3shan al autologin
  MyUser.User? databaseUser; // w da obj al user bta3 al firestore

  void setUsers(User? newFirebaseUserAuth, MyUser.User? newDatabaseUser) {
    firebaseUserAuth = newFirebaseUserAuth;
    databaseUser = newDatabaseUser;
  }

  bool isFirebaseUserLoggedIn() {
    if (FirebaseAuth.instance.currentUser == null) return false;
    //law fe currentUser mfrod akhzo firebaseUserAuth
    firebaseUserAuth = FirebaseAuth.instance.currentUser;
    return true;
  }

  Future<void> retrieveDatabaseUserData() async {
    try {
      databaseUser = await FirestoreHelper.GetUser(firebaseUserAuth!.uid);
    } catch (error) {
      print(error);
    }
  }

  Future<void> SignOut() async {
    firebaseUserAuth = null;
    databaseUser = null;

    //Auth
    return await FirebaseAuth.instance.signOut();
  }


  ThemeMode theme=ThemeMode.light;


  Future<void> changeTheme(ThemeMode newThemeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(theme==newThemeMode)return;
    if (newThemeMode==ThemeMode.dark){
      prefs.setBool("theme",true);
    }else{
      prefs.setBool("theme",false);
    }


    theme=newThemeMode;

    //de zy setstate bs lkol al nas al mohtma b al data de htsm3 w tghyr kol wl widget ale sam3en al data bta3te
    notifyListeners();
  }


  String language='en';


  Future<void> changeLnaguage(String newLnaguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(language == newLnaguage)return;
    language= newLnaguage;
    prefs.setString('language',language);
    notifyListeners();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    language = prefs.getString("language")??"en" ;
    theme= prefs.getBool("theme")==true?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }

}
