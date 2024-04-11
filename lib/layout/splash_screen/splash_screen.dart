import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/layout/home_screen/home_screen.dart';
import 'package:todoapp/layout/login/login_screen.dart';
import 'package:todoapp/shared/provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {

static const String routeName='SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Authprovider provider = Provider.of<Authprovider>(context);

    //htkhleh yshtghl w2t mo3yn w b3den ynfz func mo3yna
    Future.delayed(Duration(seconds: 2),(){
      CheckAutoLogin();
     });
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(provider.theme==ThemeMode.light?'assets/images/splash.jpg':"assets/images/splash – 1.png",),
          fit: BoxFit.cover,//yakhod al screen kolha

        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        
       ),
    );
  }
  // fe al autologin 3ayz t check howa m3mlo login wala w kont 3amel al func de fe al provider
  CheckAutoLogin() async {
    Authprovider provider=Provider.of<Authprovider>(context,listen: false);
      if(provider.isFirebaseUserLoggedIn()){
        await provider.retrieveDatabaseUserData();//3ayzo myro7sh al home gher lama ygeb al data bta3t al user 3shan law ast5dmtha
        Navigator.pushReplacementNamed(context, HomeScreen. routeName);

      }else{
        //m3naha fadya
        Navigator.pushReplacementNamed(context, LoginScreen. routeName);
      }
  }

}
