import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products_provider.dart';
import '../models/product.dart';
import './product_Detail.dart';
import '../Providers/cart_provider.dart';
import './badge_icon.dart';
import '../pages/cart_page.dart';
import '../pages/DrawerPage.dart';

enum FilterOptions { Favorite, All }

class ProjectListPage extends StatefulWidget {
  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  bool _showOnlyFavorite = false;
  bool _isInit = true ;
  var _isLoading = false ;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_isInit){
      _isLoading = true ;
      Provider.of<ProductProvider>(context).fetchAndSetProduct().then((_){
        setState(() {
          _isLoading = false ;
        });
      });
  }
    _isInit = false ;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final listOFproducts = _showOnlyFavorite ? productsData.favorite : productsData.items;
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
          actions: <Widget>[
            Consumer<CartProvide>(
              builder: (context, cart, child) => Badge(
                  child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartPage.RouteName);
                      }),
                  value: cart.cartItemCount.toString()),
            ),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedvalue) {
                if (selectedvalue == FilterOptions.Favorite) {
                  setState(() {
                    _showOnlyFavorite = true;
                  });
                } else {
                  setState(() {
                    _showOnlyFavorite = false;
                  });
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorite,
                ),
                PopupMenuItem(
                  child: Text('Show all'),
                  value: FilterOptions.All,
                ),
              ],
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading ?Center(
          child: CircularProgressIndicator(),
        ):GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            padding: const EdgeInsets.all(10.0),
            itemCount: listOFproducts.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                  value:listOFproducts[index],
                  child: GridViewItem(ValueKey(listOFproducts[index].id)));
            }));
  }
}

class GridViewItem extends StatelessWidget {
  GridViewItem(Key key) :super(key:key) ;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final _productProvider = Provider.of<ProductProvider>(context);
    final cart = Provider.of<CartProvide>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            leading: Consumer<Product>(
                builder: (context, product, child) => IconButton(
                    icon: product.isFavorite
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                          ),
                    onPressed: () {
                      product.togleISfarvorite();
                    })),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                      SnackBar(action: SnackBarAction(label: 'UNDO', onPressed: (){
                        cart.removeItem(product.id);
                      }),content: Text('Item added to cart')),);
                }),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9),
              overflow: TextOverflow.fade,
            ),
          ),
          child: GestureDetector(
            onTap: () {
             Navigator.of(context).pushNamed(ProductDetails.RouteName, arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          )),
    );
  }

}
