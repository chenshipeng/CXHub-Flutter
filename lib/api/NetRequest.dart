import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cxhub_flutter/api/NetConfig.dart';
import 'package:cxhub_flutter/api/Api.dart';
import 'package:cxhub_flutter/interceptors/token_interceptor.dart';
import 'package:cxhub_flutter/local/local_storage.dart';
import 'package:cxhub_flutter/util/DataUtil.dart';
import 'dart:convert';
import 'package:cxhub_flutter/interceptors/log_interceptor.dart';
import 'package:cxhub_flutter/pages/HomePage.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cxhub_flutter/models/login.dart';
import 'package:cxhub_flutter/models/userModel.dart';
class NetRequest{
  static Dio dio = new Dio(BaseOptions(responseType: ResponseType.json));
  static TokenInterceptors _tokenInterceptors = new TokenInterceptors();
  static Future login(String userName,String password,BuildContext context) async {
    String type = userName + ":" + password;
    var bytes = utf8.encode(type);
    var base64Str = base64.encode(bytes);
    //缓存在本地
    await LocalStorage.save(DataUtils.USER_NAME, userName);
    await LocalStorage.save(DataUtils.PWD_KEY, password);
    await LocalStorage.save(DataUtils.USER_BASIC_CODE, base64Str);
    Map requestParams = {
      "scopes": ['user', 'repo', 'gist', 'notifications'],
      "note": "admin_script",
      "client_id": NetConfig.CLIENT_ID,
      "client_secret": NetConfig.CLIENT_SECRET,
      "redirect_uri":Api.redirectUri
    };
    dio.interceptors.add(_tokenInterceptors);
    dio.interceptors.add(new LogsInterceptors());
    Response response;
    try{
      response = await dio.post(Api.authUrl,data: json.encode(requestParams));
    }on DioError catch(e){
      print(e);
      return null;
    }
    if(response != null && response.data != null){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt(DataUtils.IS_LOGIN, 1);
//      print("data is ${Login.fromJson(response.data).toString()}");
      getLoginUserInfo(userName,context);
      return response.data;
    }
  }

  static getLoginUserInfo(String userName,BuildContext context) async{
    dio.interceptors.add(new TokenInterceptors());
    Response response;
    String url = Api.userInfoUrl;
    try{
      response = await dio.get(url);
    }on DioError catch(e){
      print(e);
      return null;
    }
    if(response != null && response.data != null){
      print("user info is ${response.data}");
      UserModel user = UserModel.fromJson(response.data);
      if(user.login != null){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString(DataUtils.USER_LOGIN, user.login);
        Navigator.pushReplacementNamed(context,HomePage.sName);
      }
    }

  }

  static received_events(String userName,int page) async{
//    dio.interceptors.add(new TokenInterceptors());
    Response response;
    String url = Api.usersUrl + "/${userName}/received_events?page=${page}";
    print("url is ${url}");
    try{
      response = await dio.get(url);
//      print("received events data is ${response.data.toString()}");
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.data != null){
      print("response is ${response.data.toString()}");
      return response.data;
    }
  }

  static repo_detail(String url) async{
//    dio.interceptors.add(new TokenInterceptors());
    Response response;
    try{
      response = await dio.get(url);
      print("received events data is ${response.data.toString()}");
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.data != null){
      return response.data;
    }
    return response;
  }
  //检查是否star了仓库
  static checkIfStarredRepo(String repoLogin,String repoName,callBack) async{
//    dio.interceptors.add(new TokenInterceptors());
    Response response;
    String url = Api.checkIfStarredRepoUrl + "/${repoLogin}/${repoName}";
    print("url is ${url}");
    try{
      response = await dio.get(url);
      print("check if starred ${response.toString()}");
      if(response.statusCode == 404){
        callBack(response.statusCode);
      }
      if(response.statusCode == 204){
        callBack(response.statusCode);
      }
      print("statuscode is ${response.statusCode}");
    }on DioError catch(e){

      print("statusCode1 is ${e.response.statusCode},status message is ${e.response.statusMessage}");
    }
    if(response != null && response.data != null){
      return response.data;
    }
  }
  static starTheRepo(String repoLogin,String repoName,bool starred,callBack) async{
//    dio.interceptors.add(new TokenInterceptors());
    Response response;
    String url = Api.starTheRepoUrl + "/${repoLogin}/${repoName}";
    print("url is ${url}");
    try{
      if(starred){
        response = await dio.delete(url);
      }else{
        response = await dio.put(url);
      }
      print("statusCode  is ${response.statusCode},statusMessage is ${response.statusMessage}");
      callBack(response.statusCode);
    }on DioError catch(e){
      print("statusCode is ${e.response.statusCode}");
    }
    if(response != null && response.data != null){
      return response.data;
    }
  }
  static getUserListWith(String url,int page) async{
//    dio.interceptors.add(new TokenInterceptors());
    Response response;
    print("url is ${url}");
    try{
      response = await dio.get(url+"?page=${page}");
    }on DioError catch(e){
//      print("statusCode is ${e.response.statusCode},status message is ${e.response.statusMessage}");
    }
    if(response != null && response.data != null){
      return response.data;
    }
  }
  static Future getUserInfo(String login) async{
//    dio.interceptors.add(new TokenInterceptors());
    Response response;
    String url = Api.usersUrl + "/${login}";
    try{
      response = await dio.get(url);
    }on DioError catch(e){
      print(e);
      return null;
    }
    if(response != null && response.data != null){
      return response.data;
    }
  }
  static checkIfFollowing(String login,callBack) async{
//    dio.interceptors.add(new TokenInterceptors());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String selfLogin =  preferences.getString(DataUtils.USER_LOGIN);
    Response response;
    String url = Api.usersUrl + "/${selfLogin}/following/${login}";
    try{
      response = await dio.get(url);
      if(response.statusCode == 404){
        callBack(response.statusCode);
      }
      if(response.statusCode == 204){
        callBack(response.statusCode);
      }
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.data != null){
      return response.data;
    }
  }

  static getDataWith(String url,int page) async{
//    dio.interceptors.add(new TokenInterceptors());
    print("url is ${url}");
    String finalUrl = url;
    if(!finalUrl.contains("?")){
      finalUrl = url+"?page=${page}";
    }else{
      finalUrl = url +"&page=${page}";
    }
    Response response;
    try{
      response = await dio.get(finalUrl);
      print("url is ${finalUrl}");
    }on DioError catch(e){
      print("${finalUrl} erros is ${e}");
    }
    if(response != null && response.data != null){
      return response.data;
    }
  }
}