import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/provider/auth_provider.dart';
import '../../../style/app-colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
 /* String selectedValue = 'English';
  List<String> dropdownItems = ['English', 'Araby',  ];

  String selectedMode="Light";
  List<String> dropdownItemMode=['Light','Dark'];*/

  @override
  Widget build(BuildContext context) {

    String selectedValue =  AppLocalizations.of(context)!.english;
    List<String> dropdownItems = [ AppLocalizations.of(context)!.english,  AppLocalizations.of(context)!.araby,  ];

    String selectedMode= AppLocalizations.of(context)!.light;
    List<String> dropdownItemMode=[ AppLocalizations.of(context)!.light, AppLocalizations.of(context)!.dark];
    Authprovider provider=Provider.of<Authprovider>(context);

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                textAlign:TextAlign.left ,
                AppLocalizations.of(context)!.language,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 22),

              ),
            ),
            SizedBox(height: 20),
            Container(
             decoration: BoxDecoration(
               color:  provider.theme==ThemeMode.light?Colors.white: AppColors.DarkbackgroundColor,
              shape: BoxShape.rectangle,
               borderRadius: BorderRadius.circular(120)

             ),
              alignment: Alignment.center,
              child: SizedBox(
                height:60,
                child: DropdownButton<String>(
                  
                   dropdownColor: Colors.white,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.only( left:40 ,right: 40),
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    if(newValue== AppLocalizations.of(context)!.english){
                      provider.changeLnaguage("en");
                    }else{
                      provider.changeLnaguage("ar");
                    }

                    });
                  },
                  items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
        SizedBox(height:30,),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                textAlign:TextAlign.left ,
                AppLocalizations.of(context)!.mode,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 22
                ),


              ),
            ),
            SizedBox(height: 20),

            Container(

                decoration: BoxDecoration(
                    color:  provider.theme==ThemeMode.light?Colors.white: AppColors.DarkbackgroundColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(120)

                ),
                alignment: Alignment.center,
              child: SizedBox(
                height: 60,
                child: DropdownButton<String>(
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.only( left:40 ,right: 40),
                  value: selectedMode,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMode = newValue!;
                      if(newValue== AppLocalizations.of(context)!.dark){
                        provider.changeTheme(ThemeMode.dark);
                      }else{
                        provider.changeTheme(ThemeMode.light);
                      }
                    });
                  },
                  items: dropdownItemMode.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}