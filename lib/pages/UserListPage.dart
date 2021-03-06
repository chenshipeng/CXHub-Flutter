import 'package:flutter/material.dart';
import 'package:cxhub_flutter/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:cxhub_flutter/pages/UserDetailPage.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class UserListPage extends StatefulWidget{
  final String title;
  final String url;
  UserListPage(this.url,this.title,{Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return UserListState(url,title);
  }
}
class UserListState extends State<UserListPage>{
  final String title;
  final String url;
  List<UserModel>users;
  int page = 1;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  UserListState(this.url,this.title);
  void getDataWithPage(int page) async{
    var res = await NetRequest.getUserListWith(url,page);
    if(res != null && res.length > 0){
      _refreshController.refreshCompleted();
      setState(() {
        if(page == 1){
          users = res.map<UserModel>((item) => UserModel.fromJson(item)).toList();
        }else{
          users.addAll(res.map<UserModel>((item) => UserModel.fromJson(item)).toList());
        }
      });
    }
  }
  @override
  void initState() {
    super.initState();
    getDataWithPage(page);
  }
  void _onRefresh() async{
    page = 1;
    getDataWithPage(page);
  }
  void _onLoading() async{
    page = page + 1;
    getDataWithPage(page);

  }
  @override
  Widget build(BuildContext context) {
    if(users == null){
      return Scaffold(
        appBar: AppBar(title: Text(title),),
        body:  Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(children: buildListView(),),
      ),
    );
  }
  buildListView(){
    List<Widget>allWidgets = [];
    for(int i=0;i<users.length;i++){
      UserModel model = users[i];
//      print("model detail is ${model.avatar_url},login is ${model.login}");
      allWidgets.add(buildListItem(model.avatar_url ??"",model.login??"",i));
      allWidgets.add(getDivider());
    }
    return allWidgets;
  }
  pushWithIndex(int index){
    Navigator.push(context,
        CupertinoPageRoute(builder:(context){
          return UserDetailPage(users[index].login);
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
              return UserDetailPage(users[index].login);
            })
        );
      },
    );
  }
}