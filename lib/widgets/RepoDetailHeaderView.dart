import 'package:flutter/material.dart';
class RepoDetailHeaderView extends StatelessWidget{
  final String avatarUrl;
  final String name;
  final String description;
  final num starsCount;
  final num forksCount;
  final num watchersCount;
//  final topClick;
  RepoDetailHeaderView(this.avatarUrl,this.name,this.description,this.starsCount,this.forksCount,this.watchersCount,{Key key}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _getTopHeaderInfoItem(name, description),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: Divider(color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildButtonColumn(starsCount.toString(), "Stars"),
            buildButtonColumn(forksCount.toString(), "Forks"),
            buildButtonColumn(watchersCount.toString(), "Watchers"),],
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
        child: ClipOval(child:Image.network(avatarUrl,width: 60,height: 60),),
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
  Widget buildButtonColumn(String number, String des) {
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
//        click();
      },
    );
  }
}
