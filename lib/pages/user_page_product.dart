import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import './edit_product.dart';
import '../pages/edit_product.dart';
import '../Providers/products_provider.dart';
class UserProductsPage extends StatelessWidget {
  static const RouteName = '/userScreemPage' ;

  Future<void> _refreshProdut (BuildContext context) async {
    Provider.of<ProductProvider>(context).fetchAndSetProduct();
}
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Text'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: (){ Navigator.of(context).pushNamed(EditPruduct.RouteName);},)

        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProdut(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(itemCount:productData.items.length,itemBuilder: (context , index) =>Column(
            children: <Widget>[
              userProductItem(productData.items[index]),
              Divider()
            ],
          )),
        ),
      ),
    );
  }
}

class userProductItem extends StatelessWidget {
  final Product product ;
  userProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.edit , color: Theme.of(context).primaryColor,), onPressed: (){
                Navigator.of(context).pushNamed(EditPruduct.RouteName,arguments: product.id);
              } ),
              IconButton(icon: Icon(Icons.delete ,color: Colors.red,), onPressed: (){
                Provider.of<ProductProvider>(context).deleteProduct(product.id);
              }),
            ],
          ),
        ),
        title: Text(product.title),
        leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl),),
      );
  }
}
