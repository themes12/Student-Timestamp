import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

class Http {
  var client = http.Client();
  Future sendStudentID(String uid, String id) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    try{
      final url = 'https://std.cleverapps.io/api';
      var response = await http.post(url, body: {'uid': uid, 'std_id': id, 'version': version});
      if(response.statusCode == 200){
        Map _data = await jsonDecode(response.body);
        return _data;
      }else{
        return null;
      }
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}