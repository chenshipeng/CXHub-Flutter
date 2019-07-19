import 'package:flutter/material.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:cxhub_flutter/api/Api.dart';
import 'package:cxhub_flutter/models/trending.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'RepoDetailPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cxhub_flutter/local/local_storage.dart';
import 'package:cxhub_flutter/util/DataUtil.dart';
import 'package:cxhub_flutter/models/starModel.dart';
class RepositoriesPage extends StatefulWidget{
    @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RepositoriesPageState();
  }
}
class RepositoriesPageState extends State<RepositoriesPage>{
  int page = 1;
  List<StarModel>repos;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  getDataWithPage(int page) async{
    String _userName = await LocalStorage.get(DataUtils.USER_LOGIN);
    String url = Api.usersUrl+"/${_userName}/repos";
    var res = await NetRequest.getDataWith(url,page);
    if(res != null){
      _refreshController.refreshCompleted();
      if(res != null && res.length > 0){
        var data = res;
        setState(() {
          if(page == 1){
            repos = data.map<StarModel>((item) => StarModel.fromJson(item)).toList();
          }else{
            repos.addAll(data.map<StarModel>((item) => StarModel.fromJson(item)).toList());
          }
        });
      }


    }
  }
  _onRefresh() async{
    page = 1;
    getDataWithPage(1);
  }
  _onLoading() async{
    page = page + 1;
    getDataWithPage(page);
  }
  @override
  void initState() {
    super.initState();
    getDataWithPage(1);
  }
  @override
  Widget build(BuildContext context) {
    if(repos == null){
      return Scaffold(appBar: AppBar(title: Text("Repositories"),centerTitle: true,),
        body: Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),)),);
    }
    return Scaffold(appBar: AppBar(title: Text("Repositories"),centerTitle: true,),
        body:SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropMaterialHeader(),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: buildCellWith(),
        ));
  }
  Widget buildCellWith(){
    return ListView.builder(
      itemBuilder: (BuildContext context,int index) {
        StarModel model = repos[index];
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left:5.0,right: 5.0),
            child: _buildCardWith(model),
          ),
        );
      },
      itemCount: repos.length,
    );
  }
  Widget _buildCardWith(StarModel repo){
    return FlatButton(
        onPressed: (){
          Navigator.push(context,
              CupertinoPageRoute(builder:(context){
                return RepoDetailPage(Api.reposUrl+"/${repo.full_name}",repo.full_name);
              })
          );
        },
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 15.0,right: 5.0,bottom: 10.0),
                  child:new ClipOval(child: Image.network(
                      repo.owner.avatar_url??"",
                      width: 30.0,
                      height: 30.0)),),
                new Expanded(
                    child: Column(children: <Widget>[
                      Text(repo.name??"",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                      Text(repo.language??"",)
                    ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    )
                ),
              ],
              ),
              new Padding(
                padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                child: Text(repo.description??""),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                child:Row(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child:Row(
                          children: <Widget>[
                            Icon(Icons.star_border,color: Colors.black,size: 15,),
                            Text(repo.stargazers_count.toString()??"")
                          ],
                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child:Row(
                          children: <Widget>[
                            Image.asset("images/fork.png",width: 10,height: 10,),
                            Text(repo.forks_count.toString()??"")
                          ],
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
