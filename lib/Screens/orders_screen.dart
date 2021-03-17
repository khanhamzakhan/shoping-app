import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/order.dart';
import '../Widget/order_item.dart' as ord;
import '../Widget/main_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var inIt = true;
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Order>(context, listen: false)
          .fetchAndSetData()
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  /*@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (inIt) {
      Provider.of<Order>(context).fetchAndSetData();
    }
    inIt = false;
    super.didChangeDependencies();
  }*/

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: MainDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => ord.OrderItem(orderData.orders[i])),
    );
  }
}
