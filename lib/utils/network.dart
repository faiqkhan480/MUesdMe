import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Network {
  static var client = http.Client();

  static Future get({url,headers}) async {
    try{
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if(headers !=null){
        apiHeaders.addAll(headers);
      }
      debugPrint("Request:>>>>>>>>>>>> $url");
      var response = await client.get(Uri.parse(url),headers: apiHeaders).timeout(Duration(seconds: 50));
      // debugPrint("Response:>>>>>>>>>>>> ${response.body}");
      if(response.statusCode == 200) {
        return response.body;
        // return json.decode(response.body);
      }
      if(response.statusCode < 200 || response.statusCode > 400) {
        return response.body;
      }
    } catch(e) {
      debugPrint("GET: $e");
      return throw Exception(e);
    }
  }

  static Future post({url,payload,headers}) async {
    try{
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if(headers !=null){
        apiHeaders.addAll(headers);
      }
      var body = json.encode(payload);
      debugPrint("Request:>>>>>>>>>>>> $url");
      debugPrint("Body:>>>>>>>>>>>> $body");
      var response = await client.post(Uri.parse(url),body: body,headers:apiHeaders );
      if(response.statusCode == 200) {
        return response.body;
        // return json.decode(response.body);
      }
      if(response.statusCode < 200 || response.statusCode > 400 || json == null) {
        // return json.decode(response.body);
        return response.body;
        // return json.decode(response.body);
      }
    } catch(e){
      debugPrint("POST: $e");
      return throw Exception(e);
    }
  }
}