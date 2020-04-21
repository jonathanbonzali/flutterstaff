import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/cart_provider.dart';
import '../Providers/oders_provider.dart';

class CartPage extends StatefulWidget {
  static const RouteName = '/CartPage';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvide>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(18),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$ ${cart.getTotalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                          child:  isLoading
                              ? Center(
                            child: CircularProgressIndicator(),
                          )
                              : Text('ORDER Now'),
                          onPressed: cart.getTotalAmount <= 0
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Provider.of<OrderProvider>(context)
                                      .addOrder(cart.items.values.toList(),
                                          cart.getTotalAmount)
                                      .then((_) {
                                        isLoading = false ;
                                  });
                                  cart.clear();
                                },
                          textColor: Theme.of(context).primaryColor,
                        )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.cartItemCount,
                itemBuilder: (context, index) {
                  return CartitemView(cart.items.values.toList()[index],
                      cart.items.keys.toList()[index]);
                }),
          )
        ],
      ),
    );
  }
}

class CartitemView extends StatelessWidget {
  final CartIem _cartItem;
  final String _cartItemKey;

  CartitemView(this._cartItem, this._cartItemKey);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (DismissDirection) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Are you sure'),
                content: Text('Are you sure you want to delete this item'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('NO'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            });
      },
      onDismissed: (direction) {
        Provider.of<CartProvide>(context, listen: false)
            .removeItem(_cartItemKey);
      },
      key: ValueKey(_cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
        alignment: Alignment.centerRight,
        color: Colors.pinkAccent,
        child: Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            trailing: Text('${_cartItem.quantity}x'),
            subtitle: Text('Total: ${_cartItem.price * _cartItem.quantity}'),
            title: Text(_cartItem.title),
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$ ${_cartItem.price}')),
            ),
          ),
        ),
      ),
    );
  }
}
