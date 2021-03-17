import 'package:flutter/material.dart';
import '../Screens/orders_screen.dart';
import '../Screens/user_product_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String text, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        text,
        style: TextStyle(fontFamily: 'Lato', fontSize: 17),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: Text('Hello Friend!'),
          automaticallyImplyLeading: false,
        ),
        SizedBox(
          height: 20,
        ),
        buildListTile('Shop', Icons.shop, () {
          Navigator.of(context).pushReplacementNamed('/');
        }),
        buildListTile('Orders', Icons.payment, () {
          Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
        }),
        buildListTile('Manage Products', Icons.edit, () {
          Navigator.of(context)
              .pushReplacementNamed(UserProductScreen.routeName);
        }),
      ],
    ));
  }
}
