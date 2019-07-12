import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cxhub_flutter/models/repoModel.dart';
import 'package:cxhub_flutter/models/issue.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:cxhub_flutter/util/CommonUtils.dart';
import 'package:cxhub_flutter/api/Api.dart';
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
  RepoIssuesListPageState(this.repo);

  initParams() async{
    var res = await NetRequest.getDataWith(Api.reposUrl + "/${repo.owner.login}/${repo.name}/issues");
    if(res != null){
      var data = res;
      if(data != null){
        setState(() {
          issuesList = data.map<Issue>((item) => Issue.fromJson(item)).toList();
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
      body: ListView.builder(
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
      ),
    );
  }
  Widget _getItemWith(Issue issue,int index){
    var createTime = CommonUtils.getNewsTimeStr(DateTime.parse(issue.created_at));
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
      margin: EdgeInsets.all(10.0),
      child:Column(children: <Widget>[
        Text(issue.body ?? "",style: TextStyle(fontSize: 15,color: Colors.black),maxLines: 3,overflow: TextOverflow.ellipsis,),
        Row(children: <Widget>[
          Padding(padding:EdgeInsets.only(left: 10),
          child: Text("#${issue.number}",style: TextStyle(fontSize: 13,color: Colors.red),),),
          Spacer(),
          Padding(padding: EdgeInsets.only(right: 10),
            child:Text(createTime ?? "",style: TextStyle(fontSize: 13,color: Colors.grey),),)


        ],),
      ],
      )
    );
  }
}