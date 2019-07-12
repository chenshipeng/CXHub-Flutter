import 'package:flutter/material.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:cxhub_flutter/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:cxhub_flutter/pages/UserListPage.dart';
import 'package:cxhub_flutter/api/Api.dart';
class UserDetailPage extends StatefulWidget{
  final String login;
  UserDetailPage(this.login,{Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return UserDetailPageState(login);
  }
}
class UserDetailPageState extends State<UserDetailPage>{
  final String login;
  UserModel model;
  bool isFollowing = false;
  List<UserModel>followers;
  List<UserModel>followings;
  UserDetailPageState(this.login);

  getUserInfoWith(String login) async{
    var response = await NetRequest.getDataWith(Api.usersUrl + "/${login}");
    if(response != null){
      setState(() {
        model = UserModel.fromJson(response);
      });
    }
    var response1 =  NetRequest.checkIfFollowing(login,(statusCode){
      if(statusCode == 204){
        setState(() {
          isFollowing = true;
        });
      }
      if(statusCode == 404){
        setState(() {
          isFollowing = false;
        });
      }
    });
  }

  getFollows() async{
    var response = await NetRequest.getDataWith("https://api.github.com/users/${login}/followers");
    if(response != null){
      followers = response.map<UserModel>((item) => UserModel.fromJson(item)).toList();
    }
  }
  getFollowing() async{
    var response = await NetRequest.getDataWith("https://api.github.com/users/${login}/following");
    if(response != null){
      followings = response.map<UserModel>((item) => UserModel.fromJson(item)).toList();
    }
  }
  @override
  void initState() {
    super.initState();
    getUserInfoWith(login);
    getFollows();
    getFollowing();
  }
  @override
  Widget build(BuildContext context) {
    if(model == null){
      return Scaffold(appBar:
      AppBar(
        title: Text(login),
        centerTitle: true,
      ),
        body: Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),)),
      );
    }

    return Scaffold(appBar:
        AppBar(
        title: Text(login),
    centerTitle: true,
    actions: <Widget>[
    isFollowing?
    FlatButton(onPressed: (){}, child: Text("unFollow",style: TextStyle(fontSize: 17,color: Colors.white),)):
    FlatButton(onPressed: (){}, child: Text("Follow",style: TextStyle(fontSize: 17,color: Colors.white),))
    ],
    ),
    body:Column(
      children: <Widget>[
        getTopHeaderView(),
        buildListView()
      ],
    ),
    );
  }

  //头部的view
  Widget getTopHeaderView(){
    return Column(
      children: <Widget>[
        _getTopHeaderInfoItem(model.name ?? "",model.location ?? "", model.login ?? ""),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Divider(color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildButtonColumn(model.followers.toString(), "Followers",0),
            buildButtonColumn(model.following.toString(), "Following",1),
          ],
        ),
        Container(height: 10,color: Color.fromRGBO(231, 231, 231, 0.5),),
//        buildListView(),
      ],
    );
  }

  Widget _getTopHeaderInfoItem(String name,String location,String description){
    return Row(children:
    <Widget>[
      Padding(
        padding: new EdgeInsets.all(10),
        child: ClipOval(child:Image.network(model.avatar_url,width: 60,height: 60),),
      ),
      Expanded(child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(child: Text(name,style: TextStyle(fontWeight: FontWeight.bold),)),
            Padding(padding: EdgeInsets.only(right: 15),child: Text(location,style: TextStyle(fontWeight: FontWeight.bold),),)
          ],),
          Padding(padding: EdgeInsets.only(top: 5,right: 15),
            child: Text(description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      )
      )
    ],
      mainAxisSize: MainAxisSize.min,
    );
  }
  Widget buildButtonColumn(String number, String des,num index) {
    return FlatButton(child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Container(
          child: new Text(
            number,
            style: new TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        new Container(
          child: new Text(
            des,
            style: new TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
      onPressed: (){
        pushWithTopIndex(index);
      },
    );
  }
  pushWithTopIndex(int index){
    if(index == 0){
      if(followers != null && followers.length > 0){
        Navigator.push(context,
            CupertinoPageRoute(builder:(context){
              return UserListPage(followers, "Followers");
            })
        );
      }

    }else if(index == 1){
      Navigator.push(context,
          CupertinoPageRoute(builder:(context){
            return UserListPage(followings, "Followings");
          })
      );
    }
  }
  //下面的cell
  Widget buildListView(){
    var imgUrls = ["images/events.png","images/organization.png","images/repository_selected.png",];
    var desArr = ["Events","Organizations","Repositories"];
    List<Widget>allWidgets = [];
    for(int i=0;i<imgUrls.length;i++){
      allWidgets.add(buildListItem(imgUrls[i],desArr[i],i));
      allWidgets.add(getDivider());
    }
    return Column(
      children: allWidgets,
    );
  }
  Widget getDivider(){
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Divider(color: Colors.grey,),
    );
  }
  Widget buildListItem(String iconImgName,String title,index){
    return FlatButton(
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(right: 10),child: Image.asset(iconImgName,width: 30,height: 30,),),
          Expanded(child: Text(title,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
          Icon(Icons.arrow_forward_ios,color: Colors.grey,),
        ],
      ),
      onPressed: (){
        bottomClickedWithIndex(index);
      },
    );
  }
  bottomClickedWithIndex(num index) {
    if(index == 0){

    }
  }
}