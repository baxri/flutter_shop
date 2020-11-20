import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlControler = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _init = true;

  Product _editProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');

  var _initValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final productID = ModalRoute.of(context).settings.arguments as String;

      if (productID != null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productID);

        _initValue = {
          'title': _editProduct.title,
          'price': _editProduct.price.toString(),
          'description': _editProduct.description,
          'imageUrl': _editProduct.imageUrl,
        };
      }
    }

    _init = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlControler.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    Provider.of<Products>(context, listen: false).addProduct(_editProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValue['title'],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Title can\'t be empty.';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editProduct = Product(
                        id: null,
                        title: value,
                        description: _editProduct.description,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl);
                  },
                ),
                TextFormField(
                  initialValue: _initValue['price'],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Price can\'t be empty.';
                    }

                    if (double.tryParse(value) == null) {
                      return 'Please enter valid number.';
                    }

                    if (double.parse(value) <= 0) {
                      return 'Please enter a number greater then zero.';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _editProduct = Product(
                        id: null,
                        title: _editProduct.title,
                        description: _editProduct.description,
                        price: double.parse(value),
                        imageUrl: _editProduct.imageUrl);
                  },
                ),
                TextFormField(
                  initialValue: _initValue['description'],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Description can\'t be empty.';
                    }

                    if (value.length < 10) {
                      return 'Description should be at least 10 characters.';
                    }

                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  onSaved: (value) {
                    _editProduct = Product(
                        id: null,
                        title: _editProduct.title,
                        description: value,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl);
                  },
                ),
                Text(_imageUrlControler.text),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlControler.text.isEmpty
                          ? Text(_imageUrlControler.text)
                          : FittedBox(
                              child: Image.network(_imageUrlControler.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        // initialValue: _initValue['imageUrl'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Image URL can\'t be empty.';
                          }

                          // // if(!value.endsWith('http')){
                          // if (!value.startsWith('http')) {
                          //   return 'Please enter a valid URL.';
                          // }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Image URL',
                        ),
                        keyboardType: TextInputType.url,
                        controller: _imageUrlControler,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) => _saveForm(),
                        onSaved: (value) {
                          _editProduct = Product(
                              id: null,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              price: _editProduct.price,
                              imageUrl: value);
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
