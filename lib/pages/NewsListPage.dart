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
import 'package:pull_to_refresh/pull_to_refresh.dart';
class NewsListPage extends StatefulWidget{

  NewsListPage([Key key]):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsListPageState();
  }
}
class _NewsListPageState extends State<NewsListPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  String _userName = '';
  List<EventModel>list;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int page = 1;
  getDataWithPage(int page) async{
    _userName =   await LocalStorage.get(DataUtils.USER_LOGIN);
    print("user name is ${_userName}");
    var res = await NetRequest.received_events(_userName, page);
    _refreshController.refreshCompleted();

    if(res != null && res.length > 0){
      var data = res;
      setState(() {
        if(page == 1){
          list = data.map<EventModel>((item) => EventModel.fromJson(item)).toList();
        }else{
          list.addAll(data.map<EventModel>((item) => EventModel.fromJson(item)).toList());
        }
        print("list length is ${list.length}");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    page = 1;
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
    super.build(context);
    if(list == null){
      return Scaffold(appBar: AppBar(title: Text("News"),centerTitle: true,),
      body: Center(child:
      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),)),);
    }
    return Scaffold(appBar: AppBar(title: Text("News"),centerTitle: true,),
    body:SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropMaterialHeader(),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        itemBuilder: (BuildContext context,int index) {
          EventModel model = list[index];
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10.0),
              child: _getItem(index,model),
            ),
          );
        },
        itemCount: list.length,
      ),
    ));
  }
  Widget _getItem(int index,EventModel model){

    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
      margin: EdgeInsets.all(10.0),
      child:new FlatButton(onPressed: (){
        print("click ${index},url is ${model.repo.url},name is ${model.repo.name}");
        Navigator.push(context,
            MaterialPageRoute(builder:(context){
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
                    height: 30.0)),
            ),
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

