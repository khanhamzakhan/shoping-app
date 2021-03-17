import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/Product_Item.dart';
import '../Provider/Product.dart';

class ProductGrid extends StatelessWidget {
  final bool favItems;
  ProductGrid(this.favItems);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = favItems ? productsData.FavoriteItems : productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: products.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: products[index], child: ProductItem()));
  }
}
