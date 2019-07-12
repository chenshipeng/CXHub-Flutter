import 'package:flutter/material.dart';
import 'package:cxhub_flutter/models/repoModel.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:cxhub_flutter/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'UserListPage.dart';
import 'package:cxhub_flutter/pages/UserDetailPage.dart';
import 'package:cxhub_flutter/pages/RepoEventsListPage.dart';
import 'package:cxhub_flutter/pages/RepoIssuesListPage.dart';
import 'package:cxhub_flutter/models/readme.dart';
import 'package:cxhub_flutter/api/Api.dart';
import 'package:cxhub_flutter/pages/WebPage.dart';
import 'package:cxhub_flutter/pages/BranchListPage.dart';
class RepoDetailPage extends StatefulWidget{

  final String repoUrl;
  final String fullName;
  RepoDetailPage(this.repoUrl,this.fullName,{Key key}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return RepoDetailState(this.repoUrl,this.fullName);
  }
}
class RepoDetailState extends State<RepoDetailPage>{
  final String repoUrl;
  final String fullName;
  RepoModel repo;
  List<UserModel>stargazers;
  List<UserModel>forkers = [];
  List<UserModel>watchers;
  bool stared = false;
  Readme readme;
  RepoDetailState(this.repoUrl,this.fullName);

  getData() async{
    print("url is ${repoUrl},fullName is ${fullName}");
    var res = await NetRequest.repo_detail(repoUrl);
    if(res != null){
      setState(() {
        repo = RepoModel.fromJson(res);
      });
      await checkIfStarredRepo();
      await getAllForTheRepo();
      await getReadme();

    }
//    print(res);
  }
  getReadme() async{
    var res = await NetRequest.getDataWith(Api.reposUrl + "/${repo.owner.login}/${repo.name}/readme");
    if(res != null){
      setState(() {
        readme = Readme.fromJson(res);
      });
    }
  }
  checkIfStarredRepo() async{
    var response = await NetRequest.checkIfStarredRepo(repo.owner.login, repo.name,(statusCode){
      if(statusCode == 404){
        setState(() {
          stared = false;
        });
      }else if (statusCode == 204){
        setState(() {
          stared = true;
        });
      }
    });
  }
  starTheRepo() async{
    var response = await NetRequest.starTheRepo(repo.owner.login, repo.name,stared,(statusCode){
      if(statusCode == 204){
        setState(() {
          stared = !stared;
        });
      }
    });
  }
  getAllForTheRepo() async{
    var res = await NetRequest.getUserListWith(repo.stargazers_url);
    if(res != null && res.length > 0){
      stargazers = res.map<UserModel>((item) => UserModel.fromJson(item)).toList();
    }
//    print(res);
    var res1 = await NetRequest.getUserListWith(repo.forks_url);
    if(res1 != null && res1.length > 0){
      var forkRepos = res1.map<RepoModel>((item) => RepoModel.fromJson(item)).toList();
      forkRepos.forEach((item){
        forkers.add(item.owner);
      });
    }
//    print(res1);
    var res2 = await NetRequest.getUserListWith(repo.subscribers_url);
    if(res2 != null && res2.length > 0){
      watchers = res2.map<UserModel>((item) => UserModel.fromJson(item)).toList();
    }
//    print(res2);
  }
  @override
  void initState() {
    super.initState();
    getData();
  }


  pushWithTopIndex(int index){
    if(index == 0){
      Navigator.push(context,
          CupertinoPageRoute(builder:(context){
            return UserListPage(stargazers, "Stargazers");
          })
      );
    }else if(index == 1){
      Navigator.push(context,
          CupertinoPageRoute(builder:(context){
            return UserListPage(forkers, "Forkers");
          })
      );
    }else if(index == 2){
      Navigator.push(context,
          CupertinoPageRoute(builder:(context){
            return UserListPage(watchers, "Watchers");
          })
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if(repo == null){
      return Scaffold(appBar:
      AppBar(
        title: Text(fullName),
        centerTitle: true,
      ),
        body: Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),)),
      );
    }
    return Scaffold(appBar:
      AppBar(
        title: Text(repo.full_name),
        centerTitle: true,
        actions: <Widget>[
          stared?
          FlatButton(onPressed: starTheRepo, child: Text("unStar",style: TextStyle(fontSize: 17,color: Colors.white),)):
      FlatButton(onPressed: starTheRepo, child: Text("Star",style: TextStyle(fontSize: 17,color: Colors.white),))
        ],
      ),
      body: Column(
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
        _getTopHeaderInfoItem(repo.full_name, repo.description ?? ""),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Divider(color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildButtonColumn(repo.stargazers_count.toString(), "Stars",0),
            buildButtonColumn(repo.forks_count.toString(), "Forks",1),
            buildButtonColumn(repo.watchers_count.toString(), "Watchers",2),],
        ),
        Container(height: 10,color: Color.fromRGBO(231, 231, 231, 0.5),),
//        buildListView(),
      ],
    );
  }

  Widget _getTopHeaderInfoItem(String name,String description){
    return Row(children:
    <Widget>[
      Padding(
        padding: new EdgeInsets.all(10),
        child: ClipOval(child:Image.network(repo.owner.avatar_url,width: 60,height: 60),),
      ),
      Expanded(child: Column(
        children: <Widget>[
          Text(name,style: TextStyle(fontWeight: FontWeight.bold),),
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
  //下面的cell
  Widget buildListView(){
    var imgUrls = ["images/owner.png","images/events.png","images/issue_icon.png","images/readme.png","images/commit.png"];
    var desArr = ["Owner","Events","Issues","Readme","Commits"];
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
      Navigator.push(context,
          CupertinoPageRoute(builder:(context){
            return UserDetailPage(repo.owner.login);
          })
      );
    }else if(index == 1){
      Navigator.push(context,
          CupertinoPageRoute(builder:(context){
            return RepoEventsListPage(repo);
          })
      );
    }else if(index == 2){
      Navigator.push(context,
          CupertinoPageRoute(builder:(context){
            return RepoIssuesListPage(repo);
          })
      );
    }else if(index == 3){
      if(readme != null){
        print("link html is ${readme.links.html}");
        Navigator.push(context,
            CupertinoPageRoute(builder:(context){
              return WebPage(readme.links.html, "Readme");
            })
        );
      }
    }else if(index == 4){
      Navigator.push(context,
          CupertinoPageRoute(builder:(context){
            return BranchListPage(repo);
          })
      );
    }
  }
}