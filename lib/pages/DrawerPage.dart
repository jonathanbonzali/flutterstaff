import 'package:flutter/material.dart';
import './order_page.dart';
import '../pages/user_page_product.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Jonathan Bonzali'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('ShopApp'),
            onTap: (){Navigator.of(context).pop() ;},
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('My order'),
            onTap: (){ Navigator.of(context).pop(); Navigator.of(context).pushNamed(OrderPage.Routename) ; },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage My product'),
            onTap: (){ Navigator.of(context).pop(); Navigator.of(context).pushNamed(UserProductsPage.RouteName) ; },
          )
        ],
      ),
    );
  }
}
