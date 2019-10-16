import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'pages/LoginPage.dart';
import 'local/local_storage.dart';
import 'util/DataUtil.dart';
import 'pages/HomePage.dart';
import 'package:cxhub_flutter/event/LoginEvent.dart';
import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oktoast/oktoast.dart';
void main() => runApp(LoginTextApp());

class LoginTextApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MyCXHubApp();
  }
}

class MyCXHubApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyCXHubState();
}
class MyCXHubState extends State<MyCXHubApp>{
  int isLogin = 0;

  MyCXHubState(){
    init();
  }
  init() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isLogin = preferences.getInt(DataUtils.IS_LOGIN) ?? 0;
    print("init");
    print("isLogin ${isLogin}");
    setState(() {

    });
  }
  @override
  void initState(){
    super.initState();
//    LoginEvent.eventBus.on<LoginEvent>().listen((LoginEvent loginEvent){
//      print("event bus fired ${loginEvent.isLogin}");
//      setState(() {
//        isLogin = "1";
//      });
//    });

  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      dismissOtherOnShow: true,
      radius: 8.0,
      backgroundColor: Colors.grey.withAlpha(200),
      textStyle: TextStyle(fontSize: 16.0,color: Colors.white),
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.black,hintColor: Colors.black),
        home: isLogin > 0 ? HomePage():LoginPage(),
        routes: {
          HomePage.sName:(context){
            return HomePage();
          },
          LoginPage.sName:(context){
            return LoginPage();
          },
        },
      ),
    ); 

  }

}

