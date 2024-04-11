import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/layout/home_screen/provider/home_provider.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/shared/dialog_utils.dart';
import 'package:todoapp/shared/remote/firebase/firestore_helper.dart';
import 'package:todoapp/style/theme.dart';

import '../../../shared/provider/auth_provider.dart';
import '../../../shared/resuable_component/custom_form_field.dart';
import '../../../style/app-colors.dart';
import '../home_screen.dart';

class EditWidget extends StatefulWidget {
   static const String routeName="EditWidget";

  @override
  State<EditWidget> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditWidget> {
    TextEditingController titleController=TextEditingController();

   TextEditingController detailsController=TextEditingController();

   TextEditingController timeController=TextEditingController();

   GlobalKey<FormState>formkey=GlobalKey();

     DateTime? selectedDate;

   @override
  Widget build(BuildContext context) {
     Authprovider provider = Provider.of<Authprovider>(context);

     Task tasks=ModalRoute.of(context)?.settings.arguments as Task;

     return    Container(
      decoration: BoxDecoration(
        color: provider.theme==ThemeMode.light?AppColors.LightbackgroundColor:Colors.black,
      ),
      child: Stack(
        children: [
          Scaffold(

            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(140),
              child: AppBar(


              title: Text("To Do List",style: Theme.of(context).appBarTheme.titleTextStyle,),
              ),
            ) ,

          ),
          Padding(
            padding: const EdgeInsets.only( top: 30,bottom: 70,left: 30,right: 30,),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              color: provider.theme==ThemeMode.light?AppColors.LightbackgroundColor:AppColors.DarkbackgroundColor,
              margin: EdgeInsets.only( top: 100),
              child: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: Text("Edit Task",style: Theme.of(context).textTheme.labelMedium,)),
                      SizedBox(height: 80,),
                      CustomFormField(
                        label:"This is title" ,
                        keyboard:  TextInputType.text,
                        controller: titleController,
                        validator: (value){
                          if(value!.isEmpty || value==null){
                            return"please enter the title";
                          }
                        },),
                      SizedBox(height: 18,),
                      CustomFormField(
                        label:"Task details" ,
                        keyboard:  TextInputType.text,
                        controller: detailsController,
                        validator: (value){
                         if(value!.isEmpty || value==null){
                         return"please enter the title";
                         }}
                      ),
                      SizedBox(height: 25,),
                      InkWell(

                          onTap: ( ) async {
                            ;
                            selectedDate=await showDatePicker(context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(Duration(days: 365)),
                                initialDate: DateTime. now( ),
                            );
                           // print(selectedDate);
                            setState(() {
                            });
                          },

                          child: Center(child: Text("Select time",style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 20),))),
                           SizedBox(height: 20,),
                           selectedDate!=null?Center(child: Text(" ${selectedDate?.day}  - ${selectedDate?.month} - ${selectedDate?.year}",style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 18,fontWeight: FontWeight.w100),)):Text(" "),

                          SizedBox(height: 50,),
                          Container(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)),
                                onPressed:  () async {
                                
                                Task updatedTask=Task(title: titleController.text, date: selectedDate?.millisecondsSinceEpoch  , descripition:detailsController.text,taskID:tasks.taskID);
                                  print(tasks.taskID);
                               await FirestoreHelper.updateTask(FirebaseAuth.instance.currentUser!.uid ,tasks.taskID!    ,updatedTask);
                                DialogUtils.showMessage(context: context, message:  "task Updated successfully",
                               postiveText: "ok",
                                  postivePress: (){
                                  Navigator.pushNamed(context, HomeScreen.routeName);
                                  }
                                );
                                },
                                child:  Text("Save Changes")),
                          )





              ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
