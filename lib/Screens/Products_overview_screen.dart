import 'package:Shop_App/Widget/main_drawer.dart';
import 'package:flutter/material.dart';
import '../Widget/products_grid.dart';
import '../Widget/21.1 badge.dart';
import '../Provider/cart.dart';
import 'package:provider/provider.dart';
import './cart_screen.dart';
import '../Provider/Product.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFilterData = false;
  var inIt = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (inIt) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    inIt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedOption) {
                setState(() {
                  if (selectedOption == FilterOptions.Favorites) {
                    _showFilterData = true;
                  } else {
                    _showFilterData = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFilterData),
    );
  }
}
