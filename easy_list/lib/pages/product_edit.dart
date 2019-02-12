import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_list/widgets/form_inputs/location.dart';

import '../models/product.dart';
import '../scoped_models/main.dart';
import '../models/location_data.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  String titleValue = '';
  String descriptionValue = '';
  double priceValue = 0.0;
  LocationData location;
  final Map formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': "https://kuulpeeps.com/wp-content/uploads/2018/10/chocolate.gif",
    'lat': null,
    'lng': null,
    'address': null
  };
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Product product) {
    return TextFormField(
      initialValue: product == null ? '' : product.title,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long.';
        }
      },
      onSaved: (String value) {
        formData['title'] = value;
      },
      decoration: InputDecoration(labelText: 'Product title'),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
      initialValue: product == null ? '' : product.description,
      maxLines: 3,
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Title is required and should be 10+ characters long.';
        }
      },
      onSaved: (String desc) {
        formData['description'] = desc;
      },
      decoration: InputDecoration(labelText: 'Product description'),
    );
  }

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
      initialValue: product == null ? '' : product.price.toString(),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:[.]\d+)?$').hasMatch(value)) {
          return 'Title is required and should be a valid number.';
        }
      },
      onSaved: (String price) {
        formData['price'] = double.parse(price);
      },
      decoration: InputDecoration(labelText: 'Product price'),
    );
  }

  void _setLocation(LocationData locationData) {
    this.location = locationData;
    formData['lat'] = locationData.lat;
    formData['lng'] = locationData.lng;
    formData['address'] = locationData.address;
  }

  //model.addProduct, model.updateProduct, model.selectedProductIndex
  //Function addProduct, Function updateProduct, [int selectedProductIndex]
  void _submitForm(MainModel model) async {
    //print(formData);return;
    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save(); //TODO: Experiment with this

    formData['userId'] = model.authUser.id;

    model.toggleIsLoading();

    String productId =
        model.selectedProduct == null ? '' : model.selectedProduct.id;

    String error = "";
    http.Response res;

    try {
      res = await model.saveProductOnServer(formData, productId: productId);

      final Map responseData = json.decode(res.body);

      Product productData = Product(
          id: model.selectedProductId == null
              ? responseData['name']
              : model.selectedProduct.id,
          title: formData['title'],
          description: formData['description'],
          price: formData['price'],
          image: formData['image'],
          location: this.location,
          userId: model.authUser.id
      );

      if (model.selectedProductId == null) {
        model.addProduct(productData);
      } else {
        model.updateProduct(productData);
      }
    } catch (e) {
      error = e.toString();
    }

    model.toggleIsLoading();

    if (error.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Something went wrong.'),
              content: Text(error),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
      return;
    }

    Navigator.pushReplacementNamed(context, '/')
        .then((val) => model.selectProduct(null));
  }

  Widget _buildSubmitButton(MainModel model) {
    return model.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            onPressed: () => _submitForm(model),
            child: Text('Save'),
          );
  }

  Widget _builPageContent(BuildContext context, MainModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 600 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final product = model.selectedProduct;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
              FocusNode()); //close the keyboard when we tap outside of input fields of the form.
        },
        child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: targetPadding),
                  children: <Widget>[
                    _buildTitleTextField(product),
                    Text(titleValue),
                    _buildDescriptionTextField(product),
                    _buildPriceTextField(product),
                    SizedBox(height: 10.0),
                    LocationInput(_setLocation),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildSubmitButton(model)
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent = _builPageContent(context, model);
        print("****** ${model.selectedProductId}");

        return model.selectedProductId == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(title: Text('Edit Product')), body: pageContent);
      },
    );
  }
}
