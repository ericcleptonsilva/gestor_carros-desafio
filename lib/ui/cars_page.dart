import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gestor_cars/helpers/Cars_helps.dart';
import 'package:gestor_cars/stores/list_store.dart';
import 'package:image_picker/image_picker.dart';

class CarsPage extends StatefulWidget {
  final ListStore listStore = ListStore();
  final CarsList carslist;

  CarsPage({this.carslist});

  @override
  _CarsPageState createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final _modelControl = TextEditingController();
  final _brandControl = TextEditingController();
  final _yearControl = TextEditingController();
  final _priceControl = TextEditingController();
  final _photoControl = TextEditingController();
  final _photoFocus = FocusNode();

  ListStore _listStore = ListStore();

  CarsList _editedCarslist;

  @override
  void initState() {
    super.initState();

    if (widget.carslist == null) {
      _editedCarslist = CarsList();
    } else {
      _editedCarslist = CarsList.fromMap(widget.carslist.toMap());

      _modelControl.text = _editedCarslist.model;
      _brandControl.text = _editedCarslist.brand;
      _yearControl.text = _editedCarslist.year;
      _priceControl.text = _editedCarslist.price;
      _photoControl.text = _editedCarslist.photo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text(_editedCarslist.model ?? "Novo carro"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedCarslist.photo != null &&
                _editedCarslist.photo.isNotEmpty) {
              Navigator.pop(context, _editedCarslist);
            } else {
              FocusScope.of(context).requestFocus(_photoFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Observer(
          builder: (_) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      width: 250,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: _editedCarslist.photo != null
                                ? FileImage(File(_editedCarslist.photo))
                                : AssetImage("images/car-icon.jpg")),
                      ),
                    ),
                    onTap: () {
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery)
                          .then((file) {
                        if (file == null) return;
                        setState(() {
                          _editedCarslist.photo = file.path;
                        });
                      });
                    },
                  ),
                  TextField(
                    controller: _modelControl,
                    decoration: InputDecoration(
                        labelText: "Modelo de carro:",
                        errorText: _listStore.modelError),
                    onChanged: (text) {
                      setState(() {
                        _editedCarslist.model = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _brandControl,
                    decoration: InputDecoration(
                        labelText: "Frabricante:",
                        errorText: _listStore.brandError),
                    onChanged: (text) {
                      setState(() {
                        _editedCarslist.brand = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _yearControl,
                    decoration: InputDecoration(
                        labelText: "Ano de Fabricação:",
                        errorText: _listStore.yearError),
                    onChanged: (text) {
                      setState(() {
                        _editedCarslist.year = text;
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _priceControl,
                    decoration: InputDecoration(
                        labelText: "Preço:", errorText: _listStore.priceError),
                    onChanged: (text) {
                      setState(() {
                        _editedCarslist.price = text;
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            );
          },
        ));
  }
}
