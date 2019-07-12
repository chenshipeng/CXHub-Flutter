import 'package:flutter/material.dart';
import 'package:cxhub_flutter/models/branch.dart';
import 'package:cxhub_flutter/models/commit.dart';
import 'package:cxhub_flutter/api/Api.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
class CommitListPage extends StatefulWidget{
  final Branch branch;
  CommitListPage(this.branch,{Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommitListPageState(branch);
  }
}
class CommitListPageState extends State<CommitListPage>{
  final Branch branch;
  List<Commit>commits;
  CommitListPageState(this.branch);

  getAllCommits() async{
    print(branch.commit.url);
    var res = await NetRequest.getDataWith(branch.commit.url);
    if(res != null){
      setState(() {
        if(res != null && res.length > 0){
          commits = res.map<Commit>((item) => Commit.fromJson(item)).toList();
        }
      });

    }
  }
  @override
  void initState() {
    super.initState();
    getAllCommits();
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
      body: Center(child: Text(branch.name),),
//      body: ListView(children: buildListView(),),
    );
  }
//  buildListView(){
//    List<Widget>allWidgets = [];
//    for(int i=0;i<branches.length;i++){
//      Branch model = branches[i];
//      allWidgets.add(buildListItem(model.name ??"",i));
//      allWidgets.add(getDivider());
//    }
//    return allWidgets;
//  }
//  Widget getDivider(){
//    return Padding(
//      padding: EdgeInsets.only(left: 15),
//      child: Divider(color: Colors.grey,),
//    );
//  }
//  Widget buildListItem(String title,index){
//    return FlatButton(
//      child: Row(
//        children: <Widget>[
//          Expanded(child: Text(title,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
//          Icon(Icons.arrow_forward_ios,color: Colors.grey,),
//        ],
//      ),
//      onPressed: (){
//        Navigator.push(context,
//            CupertinoPageRoute(builder:(context){
//              return CommitListPage(branches[index]);
//            })
//        );
//      },
//    );
//  }
}