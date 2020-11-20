import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

import '../widgets/app_drawer.dart';
import '../providers/products.dart';

import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('User Products'),
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                })
          ],
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: products.items.length,
              itemBuilder: (ctx, i) => Column(
                    children: [
                      UserProductItem(products.items[i].id,
                          products.items[i].title, products.items[i].imageUrl),
                      Divider(),
                    ],
                  )),
        ));
  }
}
