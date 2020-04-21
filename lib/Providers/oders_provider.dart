import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './cart_provider.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';

class OrderItem {
  final String id ;
  final double amount ;
  final List <CartIem> products ;
  final DateTime date ;

  OrderItem({this.id, this.amount, this.products, this.date});


}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [] ;

  List <OrderItem> get orders {
    return [..._orders] ;
  }
  Future<void> addOrder(List<CartIem> cartProducts , double total ) async {
    final url = 'https://eloko-507b3.firebaseio.com/Orders.json';
    final timeStamp = DateTime.now() ;
    final reponse = await http.post(url ,body: json.encode(
        {
          'amount' : total ,
          'date': timeStamp.toIso8601String(),
          'products': cartProducts.map((cart)=>{
            'id' : cart.id ,
            'title' : cart.title,
            'quantity': cart.quantity,
            'price' : cart.price ,
          }).toList(),
        }
    ));
    _orders.insert(0,  OrderItem( id: json.decode(reponse.body)['name'], amount:total, products :cartProducts, date :DateTime.now()));
    notifyListeners();
  }

  Future<void> fetchAndSetProduct() async {
   // print('fetching order');
    const url = 'https://eloko-507b3.firebaseio.com/Orders.json';
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null ) return ;

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem (
              amount : orderData['amount'] ,
              id: orderId,
              date : DateTime.parse(orderData['date']),
              products: (orderData['products'] as List<dynamic>).map((item)=>
                  CartIem(
                id : item['id'],
                title : item['title'],
                quantity: item['quantity'],
                price : item['price'] ,)
              ).toList(),

        ),
        );
      });

      _orders = loadedOrders.reversed.toList() ;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }
}