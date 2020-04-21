import 'package:flutter/material.dart';
import '../Providers/oders_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import './DrawerPage.dart';

class OrderPage extends StatefulWidget {
  static const Routename = '/orders';

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    // TODO: implement initState
    //  Future.delayed(Duration.zero).then((_){
    //   Provider.of<OrderProvider>(context , listen: false).fetchAndSetProduct();
    //  });
    //  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('My Order')),
        body: FutureBuilder(
            future:Provider.of<OrderProvider>(context ,listen: false).fetchAndSetProduct() ,
            builder: (ctx , datasnapshot ) {
              if(datasnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }else {
                if(datasnapshot.data != null ){
                  return Center(child: Text('something went wrong'),);
                }else {
                  return Consumer<OrderProvider>( builder: (ctx , orderData , child){
                    return ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (context, index) {
                          return OrderItemView(orderData.orders[index]);
                        });
                  });
                }
              }
            }));
  }
}

class OrderItemView extends StatefulWidget {
  final OrderItem myOrder;

  OrderItemView(this.myOrder);

  @override
  _OrderItemViewState createState() => _OrderItemViewState();
}

class _OrderItemViewState extends State<OrderItemView> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            trailing: IconButton(
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                }),
            title: Text('\$ ${widget.myOrder.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.myOrder.date)),
          ),
          if (isExpanded)
            Column(
              children: <Widget>[
                ...widget.myOrder.products.map((product) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Text(product.title),
                        Spacer(),
                        Chip(
                          label: Text('${product.quantity} x ${product.price}'),
                        )
                      ],
                    ),
                  );
                }).toList()
              ],
            )
        ],
      ),
    );
  }
}
