import 'package:flutter/material.dart';
import 'package:cxhub_flutter/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:cxhub_flutter/pages/UserDetailPage.dart';

class UserListPage extends StatefulWidget{
  final List<UserModel>userArr;
  final String title;
  UserListPage(this.userArr,this.title,{Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return UserListState(userArr,title);
  }
}
class UserListState extends State<UserListPage>{
  final List<UserModel>userArr;
  final String title;
  UserListState(this.userArr,this.title);
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("title${title},user arr is ${userArr.toString()}");
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: ListView(children: buildListView(),),
    );
  }
  buildListView(){
    List<Widget>allWidgets = [];
    for(int i=0;i<userArr.length;i++){
      UserModel model = userArr[i];
      print("model detail is ${model.avatar_url},login is ${model.login}");
      allWidgets.add(buildListItem(model.avatar_url ??"",model.login,i));
      allWidgets.add(getDivider());
    }
    return allWidgets;
  }
  pushWithIndex(int index){
    Navigator.push(context,
        CupertinoPageRoute(builder:(context){
          return UserDetailPage(userArr[index].login);
        })
    );
  }
  Widget getDivider(){
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Divider(color: Colors.grey,),
    );
  }
  Widget buildListItem(String iconImgName,String title,index){
    print("icon image name is ${iconImgName}");
    return FlatButton(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: ClipOval(
                child: Image.network(
                        iconImgName,
                        width: 30.0,
                        height: 30.0)
            ),
          ),
          Expanded(child: Text(title,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
          Icon(Icons.arrow_forward_ios,color: Colors.grey,),
        ],
      ),
      onPressed: (){
        Navigator.push(context,
            CupertinoPageRoute(builder:(context){
              return UserDetailPage(userArr[index].login);
            })
        );
      },
    );
  }
}