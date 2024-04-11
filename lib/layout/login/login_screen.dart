

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import 'package:todoapp/model/user.dart';
import 'package:todoapp/shared/constant.dart';
 import 'package:todoapp/style/app-colors.dart';
import 'package:todoapp/model/user.dart' as MyUser;
import '../../shared/dialog_utils.dart';
import '../../shared/provider/auth_provider.dart';
import '../../shared/remote/firebase/firestore_helper.dart';
import '../../shared/resuable_component/custom_form_field.dart';
import '../home_screen/home_screen.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName='login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
bool isObsecure=true;

//3n tre2 al controller t2dr tktb text mo3yn yban fe al awl aw tgeb al text al mwgod
 TextEditingController emailController=TextEditingController( );
TextEditingController PasswordController=TextEditingController( );

//adeto formstate 3shan function al validate mwgoda fe al formstate bs msh fe ay key
GlobalKey<FormState> formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Authprovider provider=Provider.of<Authprovider>(context);

    return Container(
      decoration: provider.theme==ThemeMode.light?
      BoxDecoration(
        image: DecorationImage(image: AssetImage(
          "assets/images/backgroundd.jpg"

        ))
      ):BoxDecoration(
        color: AppColors. DarkbackgroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title:Text('Login',style: TextStyle(color: Colors.white,fontSize: 25)),
          backgroundColor: Colors.transparent,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,//bmsabt al controller bta3t al text form field bardo btshghl al validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10,),


                CustomFormField(
                  keyboard:TextInputType.emailAddress ,
                  label:'Email' ,

                  controller: emailController,

                  ),

                SizedBox(height: 10,),


                CustomFormField(
                  keyboard:TextInputType.visiblePassword ,
                  label: 'Password',
                obsecureText: isObsecure,
                suffixIcon:IconButton( onPressed:(){

                  setState(() {
                    isObsecure=!isObsecure;
                  });
                } ,
                    icon:Icon(
                       isObsecure? Icons.visibility_off:Icons.visibility,
                      size: 24,
                      color: AppColors.PrimaryLightColor,
                    ) ) ,
                  validator: (value){
                    if(value==null||value.isEmpty){
                      return 'this feild cant be empty';
                    }
                    if(value.length<8){
                      return'Password should be at least 8 character';
                    }
                      return null;

                  },
                  controller: PasswordController,
                ),

                SizedBox(height: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PrimaryLightColor,
                  ),
                    onPressed: (){
                      //law al formkey de b true nfzle kza law b true azhrle al kalam
                   login();
                    },
                    child:  Text('Login',style: TextStyle(
                      color: Colors.white,
                    ),)),
                SizedBox(height: 10,),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context,RegisterScreen.routeName  );
                },
                    child: Text('Dont have an account? sign up') )

              ],),
          ),
        ),

      ),
    );
  }
    void login() async {
    //lazm listen de tkon b false law 3aml create le listen bra function build
      Authprovider provider=Provider.of<Authprovider>(context,listen: false);
    if(formkey.currentState?.validate() ??false){
      DialogUtils.showLoadingDialog(context);
      try {
        // da al user al gaybo mn al auth
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: PasswordController.text,
        );
        print("user id${credential.user?.uid}");
        DialogUtils.hideLoading(context);
        //3shan a2dr afr2 ben al User bta3e w al user bta3 al Auth
        MyUser.User? user= await FirestoreHelper.GetUser(credential.user!.uid); // da al user al gaybo mn al database
        //kda gebt obj mn al user 3ayzo yro7 ykhszno fe al provider
        provider.setUsers( credential.user, user) ;


         print(user!.fullname);
    Navigator.pushNamedAndRemoveUntil(context,HomeScreen.routeName, (route) => false,);
      } on FirebaseAuthException catch (e) {
        DialogUtils.hideLoading(context);
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          DialogUtils.showMessage(context: context, message:  'user-not-found',postiveText: "OK",postivePress: (){
          Navigator.pop(context);
          });
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          DialogUtils.showMessage(context: context, message:  'Wrong password',postiveText: "OK",postivePress: (){
            Navigator.pop(context);
          });
        }

        return;
      }
      //3shan hyshel al register aw al login w yfth al home

    }

    }
}
