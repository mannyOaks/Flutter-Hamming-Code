import 'dart:math';
import 'package:flutter/material.dart';
import 'Drawer_.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String code = "";
  final textController = TextEditingController();
  int parNum = 0;
  var codeList = [];

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // realiza el procedimiento de codificacion
  hamming() {
    final exp = RegExp(r"^[01]+$");
    if (!exp.hasMatch(textController.text)) {
      this._displayErrDialog('No se ingresó un código válido');
      return null;
    }

    parNum = howManyBits(textController.text.length);
    codeList = addParityBits(textController.text);
    int power = 1, j, total;

    for (int i = 0; i < parNum; i++) {
      power = pow(2, i);
      j = 1;
      total = 0;
      var tmp = [];

      while (j * power - 1 < codeList.length) {
        var lowIndex, upIndex;

        if (j * power - 1 == codeList.length - 1) {
          lowIndex = j * power - 1;
          tmp = codeList.sublist(lowIndex, codeList.length);
        } else if ((j + 1) * power - 1 >= codeList.length) {
          lowIndex = j * power - 1;
          tmp = codeList.sublist(lowIndex, codeList.length);
        } else if ((j + 1) * power - 1 < codeList.length - 1) {
          lowIndex = j * power - 1;
          upIndex = (j + 1) * power - 1;
          tmp = codeList.sublist(lowIndex, upIndex);
        }

        j += 2;
        total += tmp.reduce((a, b) => a + b);
      }

      if (total % 2 > 0) {
        codeList[power - 1] = 1;
      }
    }

    return codeList.map((e) => e.toString()).join();
  }

  // regresa la cantidad de bits de paridad
  howManyBits(bits) {
    var power = 0;
    while (pow(2, power) <= bits + 1) {
      power++;
    }

    return power;
  }

  // agrega espacios vacios donde iran los bits de paridad
  addParityBits(bits) {
    int power = 0; //en que bit se ingresa el bit de paridad
    int bit = 0; //en que bit se encuentra
    List lista = []; //lista que retornara

    for (int i = 0; i < parNum + bits.length; i++) {
      if (i == (pow(2, power)) - 1) {
        lista.insert(i, 0);
        power++;
      } else {
        lista.insert(i, int.parse(bits[bit]));
        bit++;
      }
    }

    return lista;
  }

  _displayErrDialog(msg) {
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                Padding(padding: EdgeInsets.only(right: 10)),
                Text("Error", style: TextStyle(color: Colors.red))
              ],
            ),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: const Text("Ok"),
                onPressed: () => Navigator.pop(context, 'Ok'),
              )
            ],
          ),
    );
  }

  // Crea la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hamming Code")),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.code),
                hintText: 'Código',
              ),
              controller: textController,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            FlatButton(
              textColor: Theme.of(context).accentColor,
              child: Text('Convertir'),
              onPressed: () {
                if (textController.text.length > 0) {
                  this.setState(() {
                    code = this.hamming();
                  });
                } else {
                  this._displayErrDialog("No se ingreso un código");
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            Text(
              code != null && code.length > 0 ? "Resultado $code" : "",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
