import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cxhub_flutter/models/repoModel.dart';
import 'package:cxhub_flutter/models/EventModel.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:cxhub_flutter/util/CommonUtils.dart';
import 'package:cxhub_flutter/pages/RepoDetailPage.dart';
class RepoEventsListPage extends StatefulWidget{
  final RepoModel repoModel;
  RepoEventsListPage(this.repoModel,{Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return RepoEventsListPageState(this.repoModel);
  }
}
class RepoEventsListPageState extends State<RepoEventsListPage>{
  final RepoModel repo;
  List<EventModel>eventList;
  RepoEventsListPageState(this.repo);


  initParams() async{
    var res = await NetRequest.getDataWith(repo.events_url);
    if(res != null){
      print("response is ${res}");
      var data = res;
      if(data != null && data.length > 0){
        setState(() {
          eventList = data.map<EventModel>((item) => EventModel.fromJson(item)).toList();
          print(eventList);
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
    if(eventList == null){
      return Scaffold(appBar: AppBar(title: Text("Events"),),
        body: Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),)),);
    }
    return Scaffold(appBar: AppBar(title: Text("Events"),),
        body: ListView.builder(
          itemBuilder: (BuildContext context,int index) {
            EventModel model = eventList[index];
//          print(model.toString());
            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,right: 10.0),
                child: _getItem(index,model),
              ),
            );
          },
          itemCount: eventList.length,
        )
    );
  }
  Widget _getItem(int index,EventModel model){

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
      margin: EdgeInsets.all(10.0),
      child:new FlatButton(
          onPressed: (){
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