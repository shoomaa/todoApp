import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/layout/home_screen/provider/home_provider.dart';
import 'package:todoapp/layout/home_screen/tabs/list_tab.dart';
import 'package:todoapp/layout/home_screen/tabs/settings_tab.dart';
import 'package:todoapp/layout/home_screen/widget/add_task_sheet.dart';
import 'package:todoapp/layout/login/login_screen.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/shared/dialog_utils.dart';
import 'package:todoapp/shared/provider/auth_provider.dart';
import 'package:todoapp/shared/remote/firebase/firestore_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../style/app-colors.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "homeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [ListTab(), SettingsTab()];

  TextEditingController titleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();
  bool state = false;

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  bool isSheetOpen = false;
  @override
  Widget build(BuildContext context) {
    Authprovider provider = Provider.of<Authprovider>(context);
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    //3shan at2kd al keyboard mfto7 walaa,law not=0 yobaa al keyboard mfto7
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Container(
      color: provider.theme==ThemeMode.light?AppColors.LightbackgroundColor:Colors.black ,
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: isKeyboardOpen
              ? null
              : FloatingActionButton(
                  shape: StadiumBorder(
                      side: BorderSide(color: provider.theme==ThemeMode.light?Colors.white:AppColors.DarkbackgroundColor, width: 4)),
                  onPressed: () async {
                    if (!isSheetOpen) {
                      showAddTaskBottomshet();
                      isSheetOpen = true;
                    } else {
                      if ((formkey.currentState?.validate() ?? false) &&
                          homeProvider.selectedDate !=
                              null) //shof fe data mdafa wala(title w dec) w al date ykon mwgod
                        await FirestoreHelper.AddNewTask(
                          Task(
                            title: titleController.text,
                            date: homeProvider
                                .selectedDate!.millisecondsSinceEpoch,
                            descripition: DescriptionController.text,
                          ),
                          provider.firebaseUserAuth!.uid,
                        );

                      DialogUtils.showMessage(
                          context: context,
                          message: "Task Added Succesfully",
                          postiveText: "ok",
                          postivePress: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                      isSheetOpen = false;
                    }
                    setState(() {});
                  },
                  child: isSheetOpen
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        )
                      : Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                ),
          bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias, //ah 3ayz a2oso
            color: Colors.transparent,
            elevation: 20,
            shape: CircularNotchedRectangle(),
            notchMargin: 10, //margin b ad eh
            child: BottomNavigationBar(
              onTap: (index) {
                homeProvider.changeTab(index);
              },
              backgroundColor:provider.theme==ThemeMode.light?Colors.white:AppColors.DarkbackgroundColor,
              currentIndex: homeProvider.currentNavIndex,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/images/list.svg",
                      color: AppColors.unselectedIconsColor,
                    ),
                    activeIcon: SvgPicture.asset(
                      "assets/images/list.svg",
                      colorFilter: ColorFilter.mode(
                          AppColors.PrimaryLightColor, BlendMode.srcIn),
                    ),
                    label: ""),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset("assets/images/settings.svg"),
                  activeIcon: SvgPicture.asset(
                    "assets/images/settings.svg",
                    color: AppColors.PrimaryLightColor,
                  ),
                  label: "",
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text( homeProvider.currentNavIndex==0?AppLocalizations.of(context)!.todo:AppLocalizations.of(context)!.settings, style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blue,
            leading: IconButton(
              onPressed: () async {
                await provider.SignOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: Icon(
                Icons.exit_to_app,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          body: Scaffold(
            key: scaffoldkey,
            body: tabs[homeProvider.currentNavIndex],
          )),
    );
  }

  void showAddTaskBottomshet() {
    scaffoldkey.currentState?.showBottomSheet(
        (context) => AddTaskSheet(
            titleController: titleController,
            descController: DescriptionController,
            formKey: formkey,
            onCancel: () {
              isSheetOpen = false;
              setState(() {});
            }),
        enableDrag: false);
  }

  void changestate(newState) {
    if (state == newState) return;
    state = newState;
  }
}
