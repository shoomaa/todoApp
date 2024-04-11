import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/layout/home_screen/home_screen.dart';
import 'package:todoapp/model/user.dart';
import 'package:todoapp/shared/constant.dart';
import 'package:todoapp/shared/dialog_utils.dart';
import 'package:todoapp/shared/provider/auth_provider.dart';
import 'package:todoapp/shared/remote/firebase/firestore_helper.dart';
import 'package:todoapp/style/app-colors.dart';
import 'package:todoapp/model/user.dart' as MyUser;
import '../../shared/resuable_component/custom_form_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName='Register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isConfirmObsecure=true;
  bool isObsecure=true;


//3n tre2 al controller t2dr tktb text mo3yn yban fe al awl aw tgeb al text al mwgod
  TextEditingController emailController=TextEditingController( );
  TextEditingController FullNameController=TextEditingController( );
  TextEditingController PasswordController=TextEditingController( );
  TextEditingController confirmPasswrodController=TextEditingController( );


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
          title:Text('Create Account ',style: TextStyle(color: Colors.white,fontSize: 25)),
          backgroundColor: Colors.transparent,
        ),

        body: Padding(
          padding: const EdgeInsets.only(top: 85,left: 30,right: 30),
          child: Form(
            key: formkey,//bmsabt al controller bta3t al text form field bardo btshghl al validation
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),


                  CustomFormField(
                    keyboard:TextInputType.name ,//lama t3ml space hy3mlk awl hrf capital
                    label:'Full Name' ,
                    validator:(value){
                      if(value==null||value.isEmpty){
                        return 'this feild cant be empty';
                      }

                      return null; //law 3ada kol dol al validate tkon b null
                    } ,
                    controller: FullNameController,

                  ),
                  SizedBox(height: 10,),
                  SizedBox(height: 10,),
                  CustomFormField(
                    keyboard:TextInputType.emailAddress ,
                    label:'Email' ,
                    validator:(value){
                      if(value==null||value.isEmpty){
                        return 'this feild cant be empty';
                      }
                      //de 3obara 3n function btbd2 tt2kd en al value mktob bnfs seght al variable da btrg3 true or false
                      if(!RegExp(Constant.emailRegex).hasMatch(value)) {
                        return "Enter valid Email";
                      }
                      return null; //law 3ada kol dol al validate tkon b null
                    } ,
                    controller: emailController,

                  ),

                  SizedBox(height: 10,),

                  CustomFormField(
                    keyboard:TextInputType.visiblePassword ,
                    label: 'pass',
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

                  CustomFormField(
                    keyboard:TextInputType.visiblePassword ,
                    label: 'Confirm Password',
                    obsecureText: isConfirmObsecure,
                    suffixIcon:IconButton( onPressed:(){

                      setState(() {
                        isConfirmObsecure=!isConfirmObsecure;
                      });
                    } ,
                        icon:Icon(
                          isConfirmObsecure? Icons.visibility_off:Icons.visibility,
                          size: 24,
                          color: AppColors.PrimaryLightColor,
                        ) ) ,
                    validator: (value){
                       if(value != PasswordController.text ){
                         return"Don't match" ;
                       }
                      return null;

                    },
                    controller: confirmPasswrodController,
                  ),



                  SizedBox(height: 10,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.PrimaryLightColor,
                      ),
                      onPressed: (){
                        //law al formkey de b true nfzle kza law b true azhrle al kalam
                        createNewUer(  );
                      },
                      child:  Text('Register  ',style: TextStyle(
                        color: Colors.white,
                      ),)),

                ],),
            ),
          ),
        ),

      ),
    );
  }

  //de function bta3t al authorization law create acc
   Future<void> createNewUer( ) async {
    Authprovider provider=Provider.of<Authprovider>(context,listen: false);
     if(formkey.currentState?.validate() ??false){
       DialogUtils.showLoadingDialog(context);
       try {

         //instance de singelton y3ny ht3ml create le al obj mara wahda law msh mwgod w  law mwgod hts5dmo
         final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
           email: emailController.text,
           password: PasswordController.text,
         );
         await FirestoreHelper.Adduser(emailController.text, FullNameController.text, credential.user!.uid);

         DialogUtils.hideLoading(context);
       DialogUtils.showMessage(context: context, message: 'Registered successfully${credential.user?.uid}', NegativeText:"OK",
           negativePress :() {
             DialogUtils.hideLoading(context);
             provider.setUsers( credential.user,
                 MyUser.User(
                   id: credential.user!.uid,
                     fullname: FullNameController.text,
                     email: emailController.text,)  ) ;
             DialogUtils.hideLoading(context);
             Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName,(route) => false,);
           },  );

         print(credential.user?.uid );
       } on FirebaseAuthException catch (e) {
         DialogUtils.hideLoading(context);
         //bt handle ay Exception le al firebaseAuth b enha return code
         if (e.code == 'weak-password') {
           print('The password provided is too weak.');
           DialogUtils.showMessage(context: context, message:"The password provided is too weak.",postiveText: "OK",postivePress: () => DialogUtils.hideLoading(context),  );
         } else if (e.code == 'email-already-in-use') {
           print('The account already exists for that email.');
           DialogUtils.showMessage(context: context, message:"The account already exists for that email.",postiveText: "OK",postivePress: () => DialogUtils.hideLoading(context),  );

         }
         return;
       } catch (e) {
         DialogUtils.hideLoading(context);
         DialogUtils.showMessage(context: context, message:"${e.toString()}",postiveText: "OK",postivePress: () => DialogUtils.hideLoading(context),  );

       }
     }

   }

}
