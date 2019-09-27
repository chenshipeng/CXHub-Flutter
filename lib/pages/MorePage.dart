import 'package:flutter/material.dart';
import 'WebPage.dart';
import 'package:flutter/cupertino.dart';
import 'LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MorePage extends StatefulWidget{
  MorePage([Key key]):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return MorePageState();
  }
}
class MorePageState extends State<MorePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }
  doLogout() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new LoginPage()
        ), (route) => route == null);
  }
  logout(BuildContext context){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return new CupertinoAlertDialog(content: Text("Sure To Logout?"),actions: <Widget>[
        new CupertinoDialogAction(
          child: new Text('取消'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new CupertinoDialogAction(
          child: new Text('确定'),
          isDestructiveAction: true,
          onPressed: () {
            doLogout();
          },
        ),
      ],);
    });

  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(appBar: AppBar(title: Text("More"),centerTitle: true,actions: <Widget>[
      FlatButton(onPressed: (){logout(context);}, child: Text("Logout",style: TextStyle(color: Colors.white,fontSize: 15),))
    ],),
      body: Center(child:
              Row(children: <Widget>[
                Text("Github:"),
                FlatButton(onPressed: (){
                Navigator.push(context,
                CupertinoPageRoute(builder:(context){
                return WebPage("https://github.com/chenshipeng","chenshipeng");
                })
                );
                },
                child: Text("https://github.com/chenshipeng",style: TextStyle(color: Colors.red),)
                )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                )
      )
    );
  }
}
