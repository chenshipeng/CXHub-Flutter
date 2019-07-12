import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cxhub_flutter/models/repoModel.dart';
import 'package:cxhub_flutter/models/issue.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:cxhub_flutter/util/CommonUtils.dart';
import 'package:cxhub_flutter/api/Api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class RepoIssuesListPage extends StatefulWidget{
  final RepoModel repo;
  RepoIssuesListPage(this.repo,{Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return RepoIssuesListPageState(this.repo);
  }
}
class RepoIssuesListPageState extends State<RepoIssuesListPage>{
  final RepoModel repo;
  List<Issue>issuesList;
  int page = 1;
  RepoIssuesListPageState(this.repo);
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  getDataWithPage(int page) async{
    var res = await NetRequest.getDataWith(Api.reposUrl + "/${repo.owner.login}/${repo.name}/issues",page);
    if(res != null){
      var data = res;
      if(data != null){
        setState(() {
          if(page == 1){
            issuesList = data.map<Issue>((item) => Issue.fromJson(item)).toList();
          }else{
            issuesList.addAll(data.map<Issue>((item) => Issue.fromJson(item)).toList());
          }
        });
      }
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
    if(issuesList == null){
      return Scaffold(
        appBar:AppBar(
          title: Text("Issues"),),
        body: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text("Issues"),),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (BuildContext context,int index) {
            Issue issue = issuesList[index];
            return Container(
              child: Padding(padding:
              EdgeInsets.only(left: 10.0,right: 10.0),
                child: _getItemWith(issue,index),
              ),
            );
          },
          itemCount: issuesList.length,
        )
      )
    );
  }
  Widget _getItemWith(Issue issue,int index){
    var createTime = CommonUtils.getNewsTimeStr(DateTime.parse(issue.created_at));
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
      margin: EdgeInsets.all(10.0),
      child:Column(children: <Widget>[
        Padding(padding: EdgeInsets.all(10),
          child:Text(issue.body ?? "",style: TextStyle(fontSize: 15,color: Colors.black),maxLines: 3,overflow: TextOverflow.ellipsis,) ,),
        Row(children: <Widget>[
          Padding(padding:EdgeInsets.all(10),
          child: Text("#${issue.number}",style: TextStyle(fontSize: 13,color: Colors.red),),),
          Spacer(),
          Padding(padding: EdgeInsets.all(10),
            child:Text(createTime ?? "",style: TextStyle(fontSize: 13,color: Colors.grey),),)


        ],),
      ],
      )
    );
  }
}