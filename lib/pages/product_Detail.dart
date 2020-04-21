import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../Providers/products_provider.dart';
class ProductDetails extends StatelessWidget {
  static const RouteName = "/productDetails" ;


  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String ;
    final Product product = Provider.of<ProductProvider>(context , listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(title: Text(product.title),),
      body: Column(
        children: [Container(
          height: 300,
          width: double.infinity,
          child: Image.network(product.imageUrl , fit: BoxFit.cover,),
        ),
          SizedBox(height: 10,),
          Text('\$ ${product.price}', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
          SizedBox(height: 10,),

    ]
      ),
    );
  }
}
