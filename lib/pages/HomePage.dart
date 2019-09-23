import 'package:flutter/material.dart';
import 'package:cxhub_flutter/pages/NewsListPage.dart';
import 'package:cxhub_flutter/pages/StarsListPage.dart';
import 'package:cxhub_flutter/pages/DiscoveryListPage.dart';
import 'package:cxhub_flutter/pages/RepositoriesListPage.dart';
import 'package:cxhub_flutter/pages/MorePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cxhub_flutter/pages/LoginPage.dart';
import 'package:cxhub_flutter/local/local_storage.dart';
import 'package:cxhub_flutter/util/DataUtil.dart';
class HomePage extends StatefulWidget{
  static final String sName = 'home';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}
class HomePageState extends State<HomePage>{
  final appBarTitles = ["News","Trending","Stars","Repositories","More"];
  final tabTextStyleSelected = TextStyle(color: Colors.white);
  final tabTextStyleNormal = TextStyle(color:Colors.grey[600]);
  int _tabIndex = 0;
  var tabImages;
  var _body;
  var pages;

  Image getTabImage(path){
    return Image.asset(path,width: 20.0,height: 20.0);
  }

  @override
  void initState() {
    super.initState();
    pages = <Widget>[NewsListPage(),DiscoveryPage(),StarsPage(),RepositoriesPage(),MorePage()];
    if(tabImages == null){
      tabImages = [
        [getTabImage('images/news_selected.png'),
        getTabImage('images/news.png')
        ],
        [getTabImage('images/discovery_selected.png'),
        getTabImage('images/discovery.png')
        ],
        [getTabImage('images/stars_selected.png'),
        getTabImage('images/stars.png')
        ],
        [getTabImage('images/repository_selected.png'),
        getTabImage('images/repository.png')
        ],
        [getTabImage('images/more_selected.png'),
        getTabImage('images/more.png')
        ]
      ];
    }
  }

  TextStyle getTabTextStyle(int curIndex){
    if(curIndex == _tabIndex){
      return tabTextStyleSelected;
    }
    return tabTextStyleNormal;
  }
  Image getTabIcon(int curIndex){
    if(curIndex == _tabIndex){
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }
  Text getTabTitle(int curIndex){
    return Text(appBarTitles[curIndex],style: getTabTextStyle(curIndex));
  }
  @override
  Widget build(BuildContext context) {
    _body = pages[_tabIndex];
    return Scaffold(
      body: _body,
      bottomNavigationBar: CupertinoTabBar(items:<BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: getTabIcon(0),
            title: getTabTitle(0),
        ),
        BottomNavigationBarItem(
            icon: getTabIcon(1),
            title: getTabTitle(1),
        ),
        BottomNavigationBarItem(
            icon: getTabIcon(2),
            title: getTabTitle(2),
        ),
        BottomNavigationBarItem(
            icon: getTabIcon(3),
            title: getTabTitle(3),
        ),
        BottomNavigationBarItem(
            icon: getTabIcon(4),
            title: getTabTitle(4),
        ),
      ] ,
        currentIndex: _tabIndex,
        onTap: (index){
          setState(() {
            _tabIndex = index;
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}