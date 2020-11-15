import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/order_item.dart';

import '../providers/orders.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderListItem(orders.orders[i]),
        itemCount: orders.orders.length,
      ),
    );
  }
}
