import 'package:flutter/material.dart';
import '../Provider/Products.dart';
import 'package:provider/provider.dart';
import '../Provider/Product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_products';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0.0);
  var isInit = true;
  var _inItValues = {
    'title': '',
    'description': '',
    'imageURL': '',
    'price': ''
  };
  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product = Provider.of<Products>(context).findById(productId);
        _editedProduct = product;
        _inItValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'imageURL': '',
          'price': _editedProduct.price.toString()
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https') ||
          !_imageUrlController.text.endsWith('png') &&
              !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occured'),
                  content: Text('Something went wrong'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
      }
    }
    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _inItValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: value,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Insert the title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _inItValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (double.tryParse(value) == null) {
                          return 'Please Enter a valid Number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter amount greater then 0';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value));
                      },
                    ),
                    TextFormField(
                      initialValue: _inItValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Insert the Description';
                        }
                        if (value.length < 10) {
                          return 'Please Insert text equal to or more then 10';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                            child: TextFormField(
                          decoration: InputDecoration(labelText: ('Image URL')),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          validator: (value) {
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageUrl: value,
                                price: _editedProduct.price);
                          },
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
