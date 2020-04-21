import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../Providers/products_provider.dart';

class EditPruduct extends StatefulWidget {
  static const RouteName = '/editProduct';

  @override
  _EditPruductState createState() => _EditPruductState();
}

class _EditPruductState extends State<EditPruduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  String title;
  String price;
  String descriptiom;
  String imageUrl;
  String productid;
  var product = Product(
      id: '', description: '', price: 0, imageUrl: '', isFavorite: false);

  bool isInited = true;
  bool _isUploading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isInited) {
      productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        product = Provider.of<ProductProvider>(context).findById(productid);
        _priceController.value =
            TextEditingValue(text: product.price.toString());
      } else {}
    }
    isInited = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  void _onSubmitForm(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    print('form submited ${isValid}');
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        _isUploading = true;
      });
      try{



      }catch(_){}
      if (productid != null) {
        product = Product(
            id: product.id,
            title: title,
            description: descriptiom,
            price: double.parse(price),
            imageUrl: imageUrl,
            isFavorite: false);

        Provider.of<ProductProvider>(context).updateproduct(product);
        Navigator.of(context).pop();
      } else {
        product = Product(
            id: DateTime.now().toString(),
            title: title,
            description: descriptiom,
            price: double.parse(price),
            imageUrl: imageUrl,
            isFavorite: false);
        try {
          await Provider.of<ProductProvider>(context).addProduct(product);
        } catch (error) {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('An Error Occurer'),
                  content: Text('Something went wrong'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Okey'))
                  ],
                );
              });
        } finally {
          setState(() {
            _isUploading = false;
          });
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Project')),
      body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: _isUploading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: product.title,
                            onSaved: (value) {
                              title = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please provide a value";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          TextFormField(
                            controller: _priceController,
                            onSaved: (value) {
                              price = value;
                            },
                            textInputAction: TextInputAction.newline,
                            focusNode: _priceFocusNode,
                            keyboardType: TextInputType.numberWithOptions(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please provide a value";
                              } else if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Price',
                            ),
                          ),
                          TextFormField(
                            initialValue: product.description,
                            onSaved: (value) {
                              descriptiom = value;
                            },
                            textInputAction: TextInputAction.newline,
                            maxLines: 3,
                            focusNode: _descriptionFocusNode,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: 'Description',
                            ),
                          ),
                          TextFormField(
                            initialValue: product.imageUrl,
                            onSaved: (value) {
                              imageUrl = value;
                            },
                            textInputAction: TextInputAction.newline,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelText: 'Image Link',
                            ),
                          ),
                          Container(
                            width: 200,
                            child: RaisedButton(
                              child: Text('Save Data'),
                              onPressed: () {
                                _onSubmitForm(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ))),
    );
  }
}
