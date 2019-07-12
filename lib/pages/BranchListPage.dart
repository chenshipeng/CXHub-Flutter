import 'package:flutter/material.dart';
import 'package:cxhub_flutter/models/repoModel.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:cxhub_flutter/api/Api.dart';
import 'package:cxhub_flutter/models/branch.dart';
import 'package:cxhub_flutter/pages/CommitListPage.dart';
import 'package:flutter/cupertino.dart';
class BranchListPage extends StatefulWidget{
  final RepoModel repo;
  BranchListPage(this.repo,{Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BranchListPageState(this.repo);
  }
}
class BranchListPageState extends State<BranchListPage>{
  final RepoModel repo;
  List<Branch>branches;
  int page = 1;
  BranchListPageState(this.repo);
  getBranchList() async{
    var res = await NetRequest.getDataWith(Api.reposUrl + "/${repo.owner.login}/${repo.name}/branches",page);
    if(res != null){
      setState(() {
        if(res != null && res.length > 0){
          branches = res.map<Branch>((item) => Branch.fromJson(item)).toList();
        }
      });

    }
  }
  @override
  void initState() {
    super.initState();
    getBranchList();
  }
  @override
  Widget build(BuildContext context) {
    if(branches == null){
      return Scaffold(appBar:
      AppBar(
        title: Text(repo.name),
        centerTitle: true,
      ),
        body: Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(repo.name),),
      body: ListView(children: buildListView(),),
    );
  }
  buildListView(){
    List<Widget>allWidgets = [];
    for(int i=0;i<branches.length;i++){
      Branch model = branches[i];
      allWidgets.add(buildListItem(model.name ??"",i));
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
  Widget buildListItem(String title,index){
    return FlatButton(
      child: Row(
        children: <Widget>[
          Expanded(child: Text(title,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
          Icon(Icons.arrow_forward_ios,color: Colors.grey,),
        ],
      ),
      onPressed: (){
        Navigator.push(context,
            CupertinoPageRoute(builder:(context){
              return CommitListPage(branches[index]);
            })
        );
      },
    );
  }
}