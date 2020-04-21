import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {

  final String id ;
  final String title ;
  final String description ;
  final double price ;
  final String imageUrl ;
  bool isFavorite ;

  Product({@required this.id, @required this.title, this.description,@required this.price, @required this.imageUrl,
      this.isFavorite = false});

  void togleISfarvorite() async {
    final oldState = isFavorite ;
    isFavorite = !isFavorite ;
    notifyListeners();
    final url = 'https://eloko-507b3.firebaseio.com/products/${id}.json';
    try{
      await http.patch(url , body: json.encode({'isFavorite':isFavorite}));
    }catch(error){
      isFavorite = oldState ;
      notifyListeners();
    }


  }
}