import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/shared/remote/firebase/firestore_helper.dart';
import 'package:todoapp/style/app-colors.dart';

import '../../../shared/provider/auth_provider.dart';
import '../provider/home_provider.dart';
import 'edit_widget.dart';

class TaskWidget extends StatefulWidget {
  //l2 al data ale fe al widget hgbha mn al obj ale asmo task
  Task  task;

  TaskWidget({required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {

    //resposive >>mediaQuery htglk height al shasha w width al shasha w t2olo ana 3ayz al widget de nsba mn hight al shasha
var height=MediaQuery.of(context).size.height;
DateTime taskDate=DateTime.fromMicrosecondsSinceEpoch(widget.task.date??0);
Authprovider provider=Provider.of<Authprovider>(context);
HomeProvider providerr=Provider.of<HomeProvider>(context);

    //IntrinsicHeight: bt7dd heya al hight bta3 al child bta3ha 3ala hsb al dataa ale gowa
    return IntrinsicHeight(
      child: Slidable(
        //htzhrlk al bdaya 3ala al shmal
        startActionPane: ActionPane(
          extentRatio: 0.4,
            motion:ScrollMotion (),
            children:  [
              SlidableAction(
                onPressed: (contex){

                  FirestoreHelper.deleteTask(userID:provider.firebaseUserAuth!.uid, taskID:   widget.task.taskID??"");
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),

              SlidableAction(
                onPressed:  (contex){

                  providerr.changetaskID(widget.task.taskID);
                  Navigator.pushNamed(context, EditWidget.routeName, arguments: widget.task );
                },
                backgroundColor: Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ]),
         child: Container(

          decoration: BoxDecoration(
            color: provider.theme==ThemeMode.light?Colors.white:AppColors.DarkbackgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(

            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  height: height *0.1,
                   width:4  ,
                  decoration: widget.task.isDone==false?BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ):BoxDecoration(
                    color: Color(0xff61E757),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.task.isDone==false?Text(
                     widget.task.title??"",

                    style: Theme.of(context).textTheme.titleMedium,
                    ):Text(widget.task.title??"",
                      style: Theme.of(context).textTheme.titleMedium?.
                      copyWith(color:Color(0xff61E757) ),



                    ),
                    SizedBox(height:10,),
                    Row(
                       children: [
                         Icon
                           (
                           Icons.access_alarm_outlined,
                          color:   Theme.of(context).colorScheme.secondary,
                           size: 20,
                         ),
                         SizedBox(width: 10,),
                         Text(
                         "${DateFormat.jm().format(taskDate)}" ,
                         style: Theme.of(context).textTheme.titleSmall,)
                       ],
                    ),

                  ],
                )),
                widget.task.isDone==false?ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                    onPressed:  (){
                    setState(() {
                    });
                     widget.task.isDone=true;
                     var userID=FirebaseAuth.instance.currentUser?.uid;
                    var taskID= widget.task.taskID;
                    print("userIDis ${userID}and taskID is${taskID}");
                    Task updatedTaskk=Task(title: widget.task.title ,date:  widget.task.date,taskID:taskID, descripition: widget.task.descripition,isDone: widget.task.isDone);
                      FirestoreHelper.updateTask(userID! , taskID! , updatedTaskk);
                     print (widget.task.isDone);
                    setState(() {
                    });


                    },
                    child:  Icon(
                        Icons.check
                    )):Text("Done!",style:TextStyle(color:Color(0xff61E757),fontSize: 20,fontWeight: FontWeight.bold) ,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
