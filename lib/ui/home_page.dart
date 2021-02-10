import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gestor_cars/helpers/Cars_helps.dart';
import 'package:gestor_cars/ui/cars_page.dart';

enum OrderOption { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarsHelper helper = CarsHelper();
  List<CarsList> carslist = [];

  @override
  void initState() {
    super.initState();
    _getAllCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Carros"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOption>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOption>>[
              const PopupMenuItem<OrderOption>(
                child: Text("Ordenar de A-Z"),
                value: OrderOption.orderaz,
              ),
              const PopupMenuItem<OrderOption>(
                child: Text("Ordenar de Z-A"),
                value: OrderOption.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCarsPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: carslist.length,
          itemBuilder: (context, index) {
            return _carsCard(context, index);
          }),
    );
  }

  Widget _carsCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: carslist[index].photo != null
                          ? FileImage(File(carslist[index].photo))
                          : AssetImage("images/car-icon.jpg")),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Modelo: ",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          carslist[index].model ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Fabricante: ",
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                        Text(
                          carslist[index].brand ?? "",
                          style: TextStyle(fontSize: 22.0),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Ano: ",
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                        Text(
                          carslist[index].year ?? "",
                          style: TextStyle(fontSize: 22.0),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Preço: R\$",
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                        ),
                        Text(
                          carslist[index].price ?? "",
                          style: TextStyle(fontSize: 22.0),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          child: Text(
                            "Editar",
                            style: TextStyle(
                                color: Colors.lightBlueAccent, fontSize: 20.0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showCarsPage(carslist: carslist[index]);
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                          child: Text(
                            "Excluir",
                            style: TextStyle(
                                color: Colors.lightBlueAccent, fontSize: 20.0),
                          ),
                          onPressed: () {
                            helper.deleteCarsList(carslist[index].id);
                            setState(() {
                              carslist.removeAt(index);
                              Navigator.pop(context);
                            });
                          }),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void _showCarsPage({CarsList carslist}) async {
    final recCars = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CarsPage(
                  carslist: carslist,
                )));
    if (recCars != null) {
      if (carslist != null) {
        await helper.updateCarList(recCars);
      } else {
        await helper.saveCarsLIst(recCars);
      }
      _getAllCars();
    }
  }

  void _getAllCars() {
    helper.getALLCarsList().then((list) {
      setState(() {
        carslist = list;
      });
    });
  }

  void _orderList(OrderOption result) {
    switch (result) {
      case OrderOption.orderaz:
        carslist.sort((a, b) {
          return a.model.toLowerCase().compareTo(b.model.toLowerCase());
        });
        break;
      case OrderOption.orderza:
        carslist.sort((a, b) {
          return b.model.toLowerCase().compareTo(a.model.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}

//TESTE =>
/* @override
  void initState() {
    super.initState();

      CarsList c = CarsList();
    c.model = "Gol";
    c.brand = "Volkswagen";
    c.photo =
        "https://www.guia4rodas.com.br/wp-content/uploads/2021/01/Volkswagem-Gol.png";
    c.price = "30000";
    c.year = "2007";

    helper.saveCarsLIst(c);

    helper.getALLCarsList().then((list) {
      print(list);
    });
  }*/
