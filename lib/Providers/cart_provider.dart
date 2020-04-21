import 'package:flutter/material.dart';

class CartIem {
 final String id;
 final String title ;
 final int quantity;
 final double price;

 CartIem({this.id, this.title, this.quantity, this.price});


}

class CartProvide with ChangeNotifier {
Map <String ,CartIem> _items = {} ;

Map <String , CartIem> get items {
  return {..._items} ;
}
void addItem(String productId , double price , String title) {

  if(_items.containsKey(productId)) {
    _items.update(productId, (existingCartItem) {
      return new CartIem(id: existingCartItem.id ,title: existingCartItem.title , price:existingCartItem.price , quantity: existingCartItem.quantity + 1 ) ;
    });
  }else {
     CartIem newCartIem = new CartIem(id: DateTime.now().toString() ,title: title , price: price ,quantity: 1);
    _items.putIfAbsent(productId,() => newCartIem) ;
  }
notifyListeners();
}

int get cartItemCount {
  return _items.length ;
}
double get getTotalAmount {
  double total = 0.0 ;
  _items.forEach((key , cartitem){ total += cartitem.price * cartitem.quantity ;});
  return total ;
}
void removeItem(String id) {
  _items.remove(id);
  notifyListeners();
}
void removeSingleItem(productId){
  if(!_items.containsKey(productId)){
    return ;
  } else if (_items[productId].quantity > 1 ) {
    _items.update(productId, (existingCartItem) {
      return new CartIem(id: existingCartItem.id ,title: existingCartItem.title , price:existingCartItem.price , quantity: existingCartItem.quantity + 1 ) ;
    });
  }else {
    _items.remove(productId);
  }
}
void clear() {
  _items = {} ;
  notifyListeners();
}

}