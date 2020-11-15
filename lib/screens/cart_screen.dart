import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Chip(
                        label: Text('\$${cart.totalAmount.toString()}',
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: Theme.of(context).primaryColor),
                    FlatButton(
                        child: Text('ORDER NOW'),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          orders.addOrder(
                              cart.items.values.toList(), cart.totalAmount);
                          cart.clear();
                        }),
                  ],
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (ctx, i) {
                    String key = cart.items.keys.elementAt(i);
                    CartItem cartItem = cart.items[key];

                    return CartListItem(cartItem.id, key, cartItem.title,
                        cartItem.price, cartItem.quantity);
                  }))
        ],
      ),
    );
  }
}
