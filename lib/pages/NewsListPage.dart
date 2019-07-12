import 'package:flutter/material.dart';
import 'package:cxhub_flutter/local/local_storage.dart';
import 'package:cxhub_flutter/util/DataUtil.dart';
import 'dart:async';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:cxhub_flutter/models/EventModel.dart';
import 'dart:convert';
import 'package:cxhub_flutter/util/CommonUtils.dart';
import 'RepoDetailPage.dart';
import 'package:flutter/cupertino.dart';
class NewsListPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsListPageState();
  }
}
class _NewsListPageState extends State<NewsListPage>{
  String _userName = '';
  List<EventModel>list;

  initParams() async{
    _userName =   await LocalStorage.get(DataUtils.USER_LOGIN);
    print("user name is ${_userName}");
    var res = await NetRequest.received_events(_userName, 1);
    print("res is ${res}");

    if(res != null){
      var data = res;
      if(data != null && data.length > 0){
        setState(() {
          list = data.map<EventModel>((item) => EventModel.fromJson(item)).toList();
          print("list length is ${list.length}");
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initParams();
  }
  @override
  Widget build(BuildContext context) {
    if(list == null){
      return Center(child:
      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),));
    }
    return ListView.builder(
        itemBuilder: (BuildContext context,int index) {
          EventModel model = list[index];
//          print(model.toString());
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10.0),
              child: _getItem(index,model),
            ),
          );
        },
      itemCount: list.length,
    );

  }
  Widget _getItem(int index,EventModel model){

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
      margin: EdgeInsets.all(10.0),
      child:new FlatButton(onPressed: (){
        print("click ${index},url is ${model.repo.url},name is ${model.repo.name}");
        Navigator.push(context,
            CupertinoPageRoute(builder:(context){
              return RepoDetailPage(model.repo.url,model.repo.name ?? "");
            })
        );
      },
          child: _getColumn(model)),
    );
  }
  Widget _getColumn(EventModel model){
    var action = "";
    if(model.type != null && model.type == "CreateEvent"){
      action = "create";
    }else if(model.type != null && model.type == "WatchEvent"){
      action = "stared";
    }else if(model.type != null && model.type == "ForkEvent"){
      action = "forked";
    }
    var createTime = CommonUtils.getNewsTimeStr(DateTime.parse(model.created_at));

    var ref_type = model.payload.ref_type ?? "";
    var repoName =  model.repo.name ?? "";
    var str = action + " " + ref_type + " " + repoName;
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 10.0,top: 10.0,right: 5.0,bottom: 10.0),
                child:new ClipOval(child: Image.network(
                    model.actor.avatar_url,
                    width: 30.0,
                    height: 30.0)),),
            new Expanded(
                child: new Text(
                    model.actor.login ?? "",
                    style: TextStyle(color: Colors.black,fontSize: 14.0,fontWeight: FontWeight.bold)
                )
            ),
            new Text(createTime ?? "", style: TextStyle(color: Colors.grey,fontSize: 13.0)),
          ],
        ),
        new Padding(padding: const EdgeInsets.only(left: 10,bottom: 5),
          child: Container(
              child: new Text(str , style: TextStyle(color: Colors.black,fontSize: 13.0,fontWeight: FontWeight.bold)),
              margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
              alignment: Alignment.topLeft
          ),)
      ],
    );
  }
}

