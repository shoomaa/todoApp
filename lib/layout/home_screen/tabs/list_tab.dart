import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/layout/home_screen/widget/task_widget.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/shared/provider/auth_provider.dart';
import 'package:todoapp/shared/remote/firebase/firestore_helper.dart';
import 'package:todoapp/style/app-colors.dart';

class ListTab extends StatefulWidget {


  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  DateTime selectedDate=DateTime ( DateTime.now().year,DateTime.now().month,DateTime.now().day) ;
  @override
  void initstate(){
    super.initState();
    Authprovider provider=Provider.of<Authprovider>(context,listen: false);
    FirestoreHelper.getTaskCollection(provider.firebaseUserAuth!.uid);
  }
  Widget build(BuildContext context) {
    Authprovider provider=Provider.of<Authprovider>(context);
    return   Column(
      children: [
        EasyInfiniteDateTimeLine(
          firstDate: DateTime.now(),
          activeColor:   provider.theme==ThemeMode.light?Colors.white:AppColors.DarkbackgroundColor,
          focusDate: selectedDate, //al date ale wa2f 3leh delwa2ty
          lastDate: DateTime.now().add(Duration(days: 365)),
          timeLineProps: EasyTimeLineProps(
            separatorPadding: 20,
          ),

          dayProps: EasyDayProps(
            activeDayStyle:  DayStyle(decoration: BoxDecoration(
              color:  provider.theme==ThemeMode.light?Colors.white:AppColors.DarkbackgroundColor,
            )),
            inactiveDayStyle:DayStyle(
              decoration: BoxDecoration(
                color:  provider.theme==ThemeMode.light?Colors.white:AppColors.DarkbackgroundColor
              )
            ) ,
            todayHighlightColor:  provider.theme==ThemeMode.light?Colors.white:AppColors.DarkbackgroundColor,
            todayHighlightStyle: TodayHighlightStyle.withBackground,


          ),
          showTimelineHeader: false,
          //lama tkhtar date hynade 3ala al function de
          onDateChange: (newselectedDate) {
            setState(() {
              selectedDate=DateTime(
                newselectedDate.year,
                newselectedDate.month,
                newselectedDate.day,
              );

            });
          },
        ),
        SizedBox(height: 20,),
        //h3rd shkl loading lhd mgeb al tasks w b3den h3ml setstate tzhr listview
        Expanded(

          child:StreamBuilder (
            //htakhod mnk haga future (eno ygeb al taskat)w trg3lk widget
               stream: FirestoreHelper.ListenTasks(provider.firebaseUserAuth!.uid,selectedDate.millisecondsSinceEpoch) ,
              //al widget ale 3ayz a3rdha
              builder:  (context, snapshot) {
                //mfrod handle halet al loading w al error w al success

                //Loading
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 200,
                   ));
                }

                //error
                if(snapshot.hasError){
                  Text("SomeThing went strong${snapshot.error}");
                  ElevatedButton(
                    onPressed: (){},
                    child: Text("try again"),);
                }
                  List<Task>  tasks=snapshot.data??[]; //gblk al data wenta ast5dmha
                return ListView.separated(
                    itemBuilder:(context, index) =>  TaskWidget( task: tasks[index], ),
                    separatorBuilder: (context, index) => SizedBox(height: 20,),
                    itemCount: tasks.length);

              } ,
          ) ,
        )
      ],
    );
  }
}
