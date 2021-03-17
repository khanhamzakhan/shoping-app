import 'package:flutter/material.dart';
import '../Provider/Product.dart';
import 'package:provider/provider.dart';
import '../Widget/user_products.dart';
import '../Widget/main_drawer.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_products';

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(
              children: [
                UserProducts(
                    productsData.items[i].id,
                    productsData.items[i].title,
                    productsData.items[i].imageUrl),
                Divider()
              ],
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
