import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '\$${loadedProduct.price}',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(loadedProduct.description),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }
}
