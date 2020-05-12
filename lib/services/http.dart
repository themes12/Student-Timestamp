import 'dart:convert';

import 'package:http/http.dart' as http;

class Http {
  var client = http.Client();
  Future sendStudentID(String id) async {
    try{
      final url = 'https://std.cleverapps.io/api';
      var response = await http.post(url, body: {'uid': '123', 'std_id': id});
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