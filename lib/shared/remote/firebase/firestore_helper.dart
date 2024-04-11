import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//3mlt al class da ahot kol al function bta3t al firestore
import '../../../model/task.dart';
import '../../../model/user.dart';
class FirestoreHelper{
  //htetha fe func lwa7da 3shan al code da bst5dmo kter
  static CollectionReference<User> getUsersCollections(){
    // //3shan ageb obj mn al collection law collection user msh mwgod howa hy33mlo create
    var reference= FirebaseFirestore.instance.collection("User").withConverter(

      //howa hyakhod al func bta3tna w ynfzha w hy convert mn map le obj
        //bt3btlk al data al gya mn firestore fe snapshot(copy of doc)
        fromFirestore:(snapshot,option){
          Map<String,dynamic>?data=snapshot.data();//bydek al snapshot bta3 kol doc bs 3ala hy2et map
          return User.fromFirestore( data??{});  //law b null hb3thalo fadya 3shan kol haga tkon b null gowa,h7wlha le obj
        }  ,

        //hy7wl  al obj le map
        toFirestore: (user,options){
          return user.toFirestore();
        } );
    //ana bdef al user fe al collection fm7tag awl haga ageb al collection
    //kda bgeb al collection 3shan ykon fe edy w abd2 adef feh user brahte
    return reference;
  }


  // func bt3ml create le obj mn al user w ab3tlha al variable bta3tha
  static Future<void> Adduser(String email,String fullname,String userID)async{

              // create document :3ayz akhzn al obj (document) flazm a3ml document gded mn al colletion da
        var document= getUsersCollections().doc(userID); //wana b3ml al doc al id msh auto generated la

        //hbd2 a3ml set le data fe al doc fe shkl object mn class   hint:law mkontsh 3mlt cinvert kan hytlob map
     await document.set(
      User(
          id: userID ,
          fullname:  fullname,
          email: email, )
    );
  }

  //tb law 3ayz ageb user >read data > Get data
  static Future<User?> GetUser(String  userID)async{
    //3ayz arbot al doc b al user flazm al etnen ykono nfs al ID f3shan kda b3t le al doc al User ID
    var document= getUsersCollections().doc(userID);
    var snapshot=await document.get(); //btgblk al data ale fe al doc
    User? user=snapshot.data();//  al data htrg3 3ala shkl obj mn al user
    return user;

 }


 //h3ml awl haga function trg3 collection mn no3 task
  //bs h3ml collection gowa al user
  //hygeb al user al awl w b3den ygeb al collection task ale feh
 static CollectionReference< Task> getTaskCollection(String userID){
    //bgeb collection al user al awl w ageb meno doc 3shan ahot feh al task
   //.collection kda 3mlt collection gowa al doc da
var tasksCollection=getUsersCollections().doc(userID).collection("tasks").withConverter(
    fromFirestore:  (snapshot, options) =>Task.fromFirestore(snapshot.data()??{}) ,
    toFirestore: (Task, options) =>Task.tofirestore ()
);
return tasksCollection;

  }

  static Future<void>  AddNewTask(Task task,String userid) async {
    var refrence=getTaskCollection(userid );//kda gebt a; collection
    var taskDocument=refrence.doc(); //h3ml doc gdeda w auto generate al id bta3 al document
    task.taskID=taskDocument.id; //3ayz akhzn al id bta3 al docc 3shan lama age am3ml 3leh update b3d kda
    await taskDocument.set(task);
  }

  //3ayzen n3ml func tgeb list mn al taskat l user mo3yn
 static Future<List<Task>> GetAllTask(String userID)async{
    //awl haga lazm ageb al collection
   var taskQuery=await getTaskCollection(userID).get();//msh . doc l2ne 3ayz ageb list mn al task msh wahed bs
   //delwa2ty 3ayz a7wl list mn list<QueryDocumentSnapshot> le List mn al task
   //func map:w docs 3obara 3n list mn snapshot w al map htmshe 3ala kol doc (snapshot w t7wlo le snapshot.data=task) fytl3le listOfTask
   List<Task>taskList=taskQuery.docs.map((snapshot) => snapshot.data()).toList();
   //3ala fekra map btmshe 3ala list w t3od trg3lk item item feha w t7wlo le haga tanya w lazm tege fe al akhr t2olo .tolist
   return taskList;
 }

 static Future<void> deleteTask({required String userID,required String taskID})async{
    await getTaskCollection(userID).doc(taskID).delete();
 }

 static  Stream<List<Task>> ListenTasks(String userID,int date)async*{
    //snapshot bdl al future btrg3 stream bykon fe channel benk w ben al collection de ay tghyer yhsl feha ysm3 3ndk 3ala tol
   //function where adrt filter al tarekh blshkl da
   Stream<QuerySnapshot<Task>> taskQueryStream=getTaskCollection(userID).where("date",isEqualTo: date).snapshots();
   Stream<List<Task>>tasksStream=taskQueryStream.map((querySnapshot) => querySnapshot.docs.map((document) => document.data()).toList() );
   yield* tasksStream; //zy al return
   //hena msh await la hena enta listen leh
   //3ndk howa streamOfSnapshoOftask hkhleha list of task
   //fanta hwlt mn list of   stream le list of  doc w mn doc le list of task bs still stream
 }

  static Future<void> updateTask(String userId, String taskId, Task updatedTask) async {
    var ref = getTaskCollection(userId);
    var taskDoc = ref.doc(taskId);

    await taskDoc.update(updatedTask.tofirestore());
  }

}