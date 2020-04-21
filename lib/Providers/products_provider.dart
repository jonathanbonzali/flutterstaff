import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;
class ProductProvider with ChangeNotifier {
  List <Product> _items = [] ;
  List <Product> _items2 = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yel low Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),

  ];

  List <Product> get items {
    //return a copy instead of a pointer
    return _items;
  }

  List <Product> get favorite {
    return _items.where((product) => product.isFavorite).toList();
  }

  Map _getMap(Product product) {
    return {
      'id' : product.id,
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite,
    };
  }

  Future<void> fetchAndSetProduct() async {
    const url = 'https://eloko-507b3.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite']));
      });
      _items = loadedProducts ;
      print('done');
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://eloko-507b3.firebaseio.com/products.json';
    try {
      final response = await http.post(
          url, body: json.encode(_getMap(product)));
      final NewProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite
      );
      _items.add(product);
      notifyListeners();
    } catch (onError) {
      print(onError.toString());
      throw onError;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void updateproduct(Product newProduct) async {
    print(newProduct.id);
    final url = 'https://eloko-507b3.firebaseio.com/products/${newProduct.id}.json';
    //merge data with the in comming data
    try{
      await  http.patch( url , body : json.encode(_getMap(newProduct)));
    }catch(error){
      print(error);
    }

    final index = _items.indexWhere((item) => item.id == newProduct.id);
    _items[index] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    print(id);
    print('deleting');
    final url = 'https://eloko-507b3.firebaseio.com/products/$id.json';
    http.delete(url);

    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}