import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/product_List_page.dart';
import './pages/product_Detail.dart';
import './Providers/products_provider.dart';
import './Providers/cart_provider.dart';
import './pages/cart_page.dart';
import './Providers/oders_provider.dart';
import './pages/order_page.dart';
import './pages/user_page_product.dart';
import './pages/edit_product.dart';
import './pages/auth_screen.dart';
import './Providers/auth.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('built up');
    return MultiProvider( providers: [ChangeNotifierProvider.value(value:Auth() ) , ChangeNotifierProvider.value(value:OrderProvider() ) ,ChangeNotifierProvider.value(value: ProductProvider()) , ChangeNotifierProvider.value(value: CartProvide()) ],
      child: MaterialApp(
        title: 'shopApp',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: AuthScreen(),
        routes: {
          'product': (context) => ProjectListPage() ,
          ProductDetails.RouteName :(context)=> ProductDetails(),
          CartPage.RouteName :(context) => CartPage(),
          OrderPage.Routename:(context) => OrderPage(),
          UserProductsPage.RouteName:(context) => UserProductsPage(),
          EditPruduct.RouteName : (_) => EditPruduct()
        },
      )
    );
  }
}
