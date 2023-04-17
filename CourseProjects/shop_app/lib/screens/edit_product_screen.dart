import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode =
      FocusNode(); // Not neccesaryu anymore but for course and learning just add it
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _edittedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      return;
    }

    final productId = ModalRoute.of(context).settings.arguments;

    if (productId == null) {
      return;
    }

    _edittedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    _initValues = {
      'title': _edittedProduct.title,
      'description': _edittedProduct.description,
      'price': _edittedProduct.price.toStringAsFixed(2),
      'imageUrl': '',
    };
    _imageUrlController.text = _edittedProduct.imageUrl;
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void setLoadingFalseAndQuitPage(BuildContext context) {
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_edittedProduct.id == null) {
      await Provider.of<Products>(context, listen: false)
          .addProduct(_edittedProduct)
          .then(
            (_) => setLoadingFalseAndQuitPage(context),
          )
          .catchError(
        (err) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error occured'),
              content: Text(
                  'Something went wrong, if this error keeps occuring please forward what you tried to do and the error to us. \n\nError:\n$err'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'))
              ],
            ),
          ).then((_) => setLoadingFalseAndQuitPage(context));
        },
      );
    } else {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_edittedProduct.id, _edittedProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (val) {
                          _edittedProduct = Product(
                            id: _edittedProduct.id,
                            isFavorite: _edittedProduct.isFavorite,
                            title: val,
                            description: _edittedProduct.description,
                            price: _edittedProduct.price,
                            imageUrl: _edittedProduct.imageUrl,
                          );
                        },
                        validator: (val) {
                          return val.isEmpty ? 'Please enter a Title' : null;
                        },
                      ),
                      TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          focusNode: _priceFocusNode,
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'PLease enter a price';
                            }
                            if (double.tryParse(val) == null) {
                              return 'PLease enter a valid number';
                            }
                            if (double.parse(val) <= 0) {
                              return 'Minimum price cant be 0 or lower';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            _edittedProduct = Product(
                              id: _edittedProduct.id,
                              isFavorite: _edittedProduct.isFavorite,
                              title: _edittedProduct.title,
                              description: _edittedProduct.description,
                              price: double.parse(val),
                              imageUrl: _edittedProduct.imageUrl,
                            );
                          }),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: (val) {
                          _edittedProduct = Product(
                            id: _edittedProduct.id,
                            isFavorite: _edittedProduct.isFavorite,
                            title: _edittedProduct.title,
                            description: val,
                            price: _edittedProduct.price,
                            imageUrl: _edittedProduct.imageUrl,
                          );
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter a discription';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
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
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'PLease enter an image URL';
                                  }
                                  if (!Uri.parse(val).isAbsolute) {
                                    return 'Invalid URL';
                                  }
                                  return null;
                                },
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                onFieldSubmitted: (_) => _saveForm(),
                                onSaved: (val) {
                                  _edittedProduct = Product(
                                    id: _edittedProduct.id,
                                    isFavorite: _edittedProduct.isFavorite,
                                    title: _edittedProduct.title,
                                    description: _edittedProduct.description,
                                    price: _edittedProduct.price,
                                    imageUrl: val,
                                  );
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
