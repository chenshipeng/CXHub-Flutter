import 'package:flutter/material.dart';
import 'package:cxhub_flutter/models/branch.dart';
import 'package:cxhub_flutter/models/commit.dart';
import 'package:cxhub_flutter/api/Api.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cxhub_flutter/models/repoModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:cxhub_flutter/util/CommonUtils.dart';
class CommitListPage extends StatefulWidget{
  final Branch branch;
  final RepoModel repo;
  CommitListPage(this.branch,this.repo,{Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommitListPageState(branch,repo);
  }
}
class CommitListPageState extends State<CommitListPage>{
  final Branch branch;
  final RepoModel repo;
  List<Commit> commits;
  int page = 1;
  CommitListPageState(this.branch,this.repo);
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  getDataWithPage(int page) async{
    print("branch url is ${branch.commit.url}");
    var res = await NetRequest.getDataWith(Api.reposUrl + "/${repo.owner.login}/${repo.name}/commits?sha=${branch.commit.sha}",page);
    if(res != null){
      if(res != null && res.length > 0){
        setState(() {
          if(page == 1){
            commits = res.map<Commit>((item) => Commit.fromJson(item)).toList();
          }else{
            commits.addAll(res.map<Commit>((item) => Commit.fromJson(item)).toList());
          }
        });
      }


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
    if(commits == null){
      return Scaffold(appBar:
      AppBar(
        title: Text(branch.name),
        centerTitle: true,
      ),
        body: Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(branch.name),),
      body: ListView(children: buildListView(),),
    );
  }
  buildListView(){
    List<Widget>allWidgets = [];
    for(int i=0;i<commits.length;i++){
      Commit model = commits[i];
      allWidgets.add(buildListItem(model,i));
      allWidgets.add(getDivider());
    }
    return allWidgets;
  }
  Widget getDivider(){
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: Divider(color: Colors.grey,),
    );
  }
  Widget buildListItem(Commit commit,index){
    print("date is ${commit.commit.author.date}");
    var createTime = "";
    if(commit.commit.author.date != null){
      createTime = CommonUtils.getNewsTimeStr(DateTime.parse(commit.commit.author.date));
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10,right: 10),
            child: ClipOval(
              child: Image.network(commit.author.avatar_url,width: 60,height: 60,),
            ),
          ),
          Expanded(
              child:
              Column(
                children: <Widget>[
                  Text(commit.commit.author.name??"",
                    style: TextStyle(color: Colors.black,fontSize: 14),),
                  Text(createTime,
                      style: TextStyle(color: Colors.black,fontSize: 14)),
                  Padding(padding: EdgeInsets.only(top: 5,right: 15,bottom: 5),
                    child: Text(commit.commit.message??"",
                        overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),

    );
  }
}