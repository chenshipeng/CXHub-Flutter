import 'package:flutter/material.dart';
import 'package:cxhub_flutter/local/local_storage.dart';
import 'package:cxhub_flutter/util/DataUtil.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter/material.dart' as prefix0;
import 'dart:async';
import 'HomePage.dart';
class LoginPage extends StatefulWidget{
  static final String sName = 'login';
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}
class LoginPageState extends State<LoginPage>{
  String _userName = "";
  String _password = "";

  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwdController = new TextEditingController();
  
  LoginPageState():super();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initParams();
  }
  initParams() async{
    _userName = await LocalStorage.get(DataUtils.USER_NAME);
    _password = await LocalStorage.get(DataUtils.PWD_KEY);
    print("userName is ${_userName},password is ${_password}");
    userController.value = new TextEditingValue(text: _userName ?? "");
    pwdController.value = new TextEditingValue(text: _password ?? "");
  }
  void _showCustomWidgetToast() {
    var w = Center(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 50,
            width: 50,
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black)
          ),
        ),
      ),
    );
    showToastWidget(w,
    duration: Duration(seconds: 10));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: new EdgeInsets.all(0),
        child: new Center(
          child: SafeArea(child: SingleChildScrollView(
            child: new Card(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10.0)),),
              color: Colors.white,
              margin: const EdgeInsets.only(left: 30.0,right: 30.0),
              child: new Padding(
                padding: new EdgeInsets.only(left: 30.0,top: 40.0,right: 30.0,bottom: 0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new Image(image: new AssetImage("images/github.png"),width: 90.0,height: 90.0),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new TextField(
                      decoration:InputDecoration(
                          labelText: "username",
                          labelStyle: TextStyle(color: Colors.grey),
                          icon: Icon(Icons.person,color: Colors.black)
                      ),
                      controller: userController,
                      onChanged: (String value){
                        _userName = value;
                      },
                    ),
                    new Padding(padding: new EdgeInsets.all(10.0)),
                    new TextField(
                      decoration: InputDecoration(
                          labelText: "password",
                          labelStyle: TextStyle(color: Colors.grey),
                          icon: Icon(Icons.lock,color: Colors.black)
                      ),
                      controller: pwdController,
                      obscureText: true,
                      onChanged: (String value){
                        _password = value;
                      },
                    ),
                    new Padding(padding: new EdgeInsets.all(30.0)),
                    new FlatButton(
                        padding: new EdgeInsets.only(left: 20.0,top: 10.0,right: 20.0,bottom: 10.0),
                        color: Colors.black,
                        textColor: Colors.white,
                        splashColor: Colors.grey,
                        onPressed: (){
                          if(_userName == null || _userName.length == 0){
                            return;
                          }
                          if(_password == null || _password.length == 0){
                            return;
                          }
                          _showCustomWidgetToast();
                          NetRequest.login(_userName.toString(), _password.toString(),context);
                        },
                        child: new Flex(direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Text("Login",style: TextStyle(fontSize: 17.0),)],)),
                    new Padding(padding: new EdgeInsets.all(30.0))

                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}