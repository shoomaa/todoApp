// fe case al login appear dialog
// fe case al loading appear dialog
// fe case al successes appear dialog
// fe case al fail appear dialog



import 'package:flutter/material.dart';

class DialogUtils{
  
  static void showLoadingDialog(BuildContext context){
    showDialog(context: context, builder: (context) {
      //lazm wrap bhaga asmha material heya widget monsba zy al scaffold 3shan yzhr design al material
      return  Material(
        color: Colors.transparent,
        //wrap al container b center 3shan yakhod 7gmo msh al shasaha kolha
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),

            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  //3ala ad al widget
                  mainAxisSize: MainAxisSize.min,
                children: [
                  //law sh8al 3ala android hyzhrlk al material w law ios caprtino
                  CircularProgressIndicator.adaptive(),
                  SizedBox(width: 15,),
                  Text('Loading')
                ],
              ),
            ),
          ),
        ),
      );
    }  );
  }

  static void hideLoading(BuildContext context){
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    String?postiveText,
    String?NegativeText,
    void Function()? postivePress,
    void Function()? negativePress,
  }){
    showDialog(context: context, builder: (context) {
      //lazm wrap bhaga asmha material heya widget monsba zy al scaffold 3shan yzhr design al material
      return  Material(
        color: Colors.transparent,
        //wrap al container b center 3shan yakhod 7gmo msh al shasaha kolha
        child: Center(
          child: Container(
            margin: EdgeInsets. only(right: 30,left: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),

            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                //3shan al dialog yobaa 3ala ad al column
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message),
                  SizedBox(height: 15,),
                  //msh 3ayz azhrlo al error w akhfeh la howa ydos ok yt2fl
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //y3ny law msh b null
                      if(postiveText!=null)
                      TextButton(
                        //akne bb3t parameter 3ady bs heya function
                          onPressed: postivePress   ,
                          child:Text(postiveText),  ),
                      if(NegativeText!=null)
                        TextButton(onPressed:  negativePress,
                        child: Text(NegativeText))



                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }  );
  }
}
