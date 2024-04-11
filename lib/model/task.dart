import 'package:cloud_firestore/cloud_firestore.dart';

//h3ml al collection awl haga
class Task{
  String? title;
  String? descripition;
  int? date; //tre2a represent al tarekh zy al DateTime bzbt
  String?taskID;  // hnkhle al user yshel al task
  bool? isDone  ;

Task({required this.title,required this.date,required this.descripition,  this.taskID,this.isDone=false});

//NmaedConstructor
Task.fromFirestore(Map<String,dynamic> data){
  title=data["title"];
  descripition=data["descripition"];
  date=data["date"];
  taskID=data["taskID"];
  isDone=data["isDone"];

}
Map<String,dynamic> tofirestore(){
  Map<String,dynamic>data={
    "title":title,
    "descripition":descripition,
    "date":date,
    "taskID":taskID,
    "isDone":isDone,

  };
  return data;
}
}