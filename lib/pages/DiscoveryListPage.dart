import 'package:flutter/material.dart';
import 'package:cxhub_flutter/api/NetRequest.dart';
import 'package:cxhub_flutter/api/Api.dart';
import 'package:cxhub_flutter/models/trending.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'RepoDetailPage.dart';
import 'package:flutter/cupertino.dart';
class DiscoveryPage extends StatefulWidget{
  DiscoveryPage([Key key]):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return DiscoveryPageState();
  }
}
class DiscoveryPageState extends State<DiscoveryPage> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  List <Tab>tabs = <Tab>[Tab(text: "Daily",),Tab(text: "Weekly",),Tab(text: "Monthly",)];
  TabController _tabController;
  int currentIndex = 0;
  String language = "";
  List<String>languages = ["all languages","javascript","java","php","ruby","python","css","cpp","c","objective-c","swift","dart","shell","r","perl","lua","html","scala","go"];
  List<Trending>dailyTrendings;
  List<Trending>weekTrendings;
  List<Trending>monthTrendings;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  getDataWithPage(int page) async{
    String url = "";
    if(language.length > 0 && language != "all languages"){
      url = "https://github-trending-api.now.sh/repositories?" + "language=${language}?since=${tabs[currentIndex].text}";
    }else{
      url = "https://github-trending-api.now.sh/repositories?" + "since=${tabs[currentIndex].text}";
    }
    var res = await NetRequest.getDataWith(url,page);
    if(res != null){
      _refreshController.refreshCompleted();
      if(res != null && res.length > 0){
        setState(() {
          if(currentIndex == 0){
            dailyTrendings = res.map<Trending>((item) => Trending.fromJson(item)).toList();
          }else if(currentIndex == 1){
            weekTrendings = res.map<Trending>((item) => Trending.fromJson(item)).toList();
          }else{
            monthTrendings = res.map<Trending>((item) => Trending.fromJson(item)).toList();
          }
        });
      }


    }
  }
  _onRefresh() async{
    getDataWithPage(0);
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener((){
      currentIndex = _tabController.index;
      switch(_tabController.index){
        case 0:
          {
            print("selected 0 index");
            if(dailyTrendings == null){
              getDataWithPage(0);
            }
          }
          break;
        case 1:
          {
            print("selected 1 index");
            if(weekTrendings == null){
              getDataWithPage(0);
            }
          }
          break;
        case 2:
          {
            print("select 2index");
            if(monthTrendings == null){
              getDataWithPage(0);
            }
          }
          break;
      }
    });
    getDataWithPage(0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void showMenuSelection(String value){
    if(value != language){
      language = value;
      if(value == "all languages"){
        language = "";
      }
      getDataWithPage(0);
    }

  }
  _renderHeaderPopItemChild(List<String> data) {
    List<PopupMenuEntry<String>> list = new List();
    for (String item in data) {
      list.add(PopupMenuItem<String>(
        value: item,
        child: new Text(item),
      ));
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Trending"),
        bottom: TabBar(
            tabs: tabs,
        controller: _tabController,
        indicatorColor: Colors.white,),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: new PopupMenuButton<String>
              (itemBuilder: (BuildContext context){
              return _renderHeaderPopItemChild(languages);
            },
                onSelected:showMenuSelection,
                child: new Center(
                    child: new Text(language.length == 0?"all":language, style:TextStyle(color: Colors.white))
                )
            ),
          )
        ],
      ),
      body: TabBarView(
          children: tabs.map((Tab tab){
            return buildItemWidgetWithIndex(tab);
      },).toList(),
      controller: _tabController,),
    );
  }

  Widget buildItemWidgetWithIndex(Tab tab){
    String name = tab.text;
    if(name == "Daily"){
      if(dailyTrendings == null){
        return Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),));
      }else{
        return buildCellWith(dailyTrendings,0);
      }
    }else if(name == "Weekly"){
      if(weekTrendings == null){
        return Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),));
      }else{
        return buildCellWith(weekTrendings,1);
      }
    }else{
      if(monthTrendings == null){
        return Center(child:
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),));
      }else{
        return buildCellWith(monthTrendings,2);
      }
    }
  }
  Widget buildCellWith(List<Trending>trendings,int tabIndex){
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropMaterialHeader(),
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemBuilder: (BuildContext context,int index) {
          Trending model = trendings[index];
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10.0),
              child: _buildCardWith(model),
            ),
          );
        },
        itemCount: trendings.length,
      ),
    );
  }
  Widget _buildCardWith(Trending trending){
    return FlatButton(
        onPressed: (){
          Navigator.push(context,
              CupertinoPageRoute(builder:(context){
                return RepoDetailPage(Api.reposUrl+"/${trending.author}/${trending.name}","${trending.author}/${trending.name}");
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
                      trending.avatar,
                      width: 30.0,
                      height: 30.0)),),
                new Expanded(
                    child: Column(children: <Widget>[
                      Text(trending.name??"",style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                      Text(trending.language??"",)
                    ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    )
                ),
              ],
              ),
              new Padding(
                padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
                child: Text(trending.description??""),
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
                          Text(trending.stars.toString()??"")
                        ],
                      )
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child:Row(
                        children: <Widget>[
                          Image.asset("images/fork.png",width: 10,height: 10,),
                          Text(trending.forks.toString()??"")
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

