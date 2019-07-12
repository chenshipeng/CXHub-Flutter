import 'package:dio/dio.dart';
import 'package:cxhub_flutter/local/local_storage.dart';
import 'package:cxhub_flutter/util/DataUtil.dart';

class TokenInterceptors extends InterceptorsWrapper{
  String _token;
  @override
  onRequest(RequestOptions options) async{
    if(_token == null){
      var authorizationCode = await getAuthorization();
      if(authorizationCode != null){
        _token = authorizationCode;
      }
      print(_token);
      options.headers["Authorization"] = _token;
    }
    return super.onRequest(options);
  }
  @override
  onRseponse(Response response) async{
    try{
      var responseJson = response.data;
      if(response.statusCode == 201 && responseJson["token"] != null){
        _token = 'token' + responseJson["token"];
        await LocalStorage.save(DataUtils.HEADER_TOKEN, _token);
      }
    } catch(e){
      print(e);
    }
  }

  clearAuthorization(){
    this._token = null;
    LocalStorage.remove(DataUtils.HEADER_TOKEN);
  }
  getAuthorization() async{
    String token = await LocalStorage.get(DataUtils.HEADER_TOKEN);
    if(token == null){
      String basic = await LocalStorage.get(DataUtils.USER_BASIC_CODE);
      if(basic == null){
        //提示请输入账号密码
      }else{
        return "Basic $basic";
      }
    }else{
      this._token = token;
      return token;
    }
  }
}