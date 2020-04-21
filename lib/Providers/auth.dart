import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Auth with ChangeNotifier {
  String token ;
  DateTime _expireDate ;
  String _userId ;

  Future<void> SignUp(String email , String password) async {
  String url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[AIzaSyDQtFYf0fe9_JaFToLPM8kU1Qijbi2hqxs]";
 final response = await  http.post(url , body: json.encode(
    { email:email , 'password' :password , 'returnSecureToken':true}
  ));
 print(json.decode(response.body));
  }

  Future<void> Login (String email , String password) async{
    String url = "  https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[AIzaSyDQtFYf0fe9_JaFToLPM8kU1Qijbi2hqxs]";
    final response = await  http.post(url , body: json.encode(
        { email:email , 'password' :password , 'returnSecureToken':true}
    ));
    print(json.decode(response.body));

  }

}