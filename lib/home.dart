import 'package:convmoedas/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class Conversor extends StatefulWidget {
  const Conversor({Key? key}) : super(key: key);

  @override
  _ConversorState createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  double? dolar;
  double? euro;
  double? dolarV;
  double? euroV;

  final realC =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final dolarC =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  final euroC =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  // final realC = TextEditingController();
  // final dolarC = TextEditingController();
  // final euroC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: conversor(),
    );
  }

  conversor() {
    return FutureBuilder<Map>(
        future: getData(),
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "carregando dados",
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "erro ao carregar dados",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                dolarV =
                    snapshot.data?["results"]["currencies"]["USD"]["variation"];
                euroV =
                    snapshot.data?["results"]["currencies"]["EUR"]["variation"];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.monetization_on,
                          size: 150, color: Colors.amber),
                      buidTextField(
                        "Reais",
                        "R\$ ",
                        realC,
                        realChanged,
                      ),
                      const Divider(),
                      buidTextField("Dolar", "U\$ ", dolarC, dolarChanged,
                          variation: dolarV),
                      const Divider(),
                      buidTextField("Euro", "€ ", euroC, euroChanged,
                          variation: euroV)
                    ],
                  ),
                );
              }
          }
        });
  }

  Widget buidTextField(String label, String prefix, MoneyMaskedTextController C,
      Function(String) F,
      {double? variation}) {
    return TextField(
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      onChanged: F,
      controller: C,
      decoration: InputDecoration(
          suffixIcon: variation == null
              ? null
              : variation == 0
                  ? const Icon(
                      Icons.minimize,
                      color: Colors.grey,
                    )
                  : variation.toString().contains("-")
                      ? const Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                          size: 20,
                        )
                      : const Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                          size: 20,
                        ),
          suffix: variation != null
              ? Text(
                  variation.toString(),
                  style: const TextStyle(color: Colors.amber, fontSize: 15),
                )
              : const Text(""),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.amber),
          border: const OutlineInputBorder(),
          prefixStyle: const TextStyle(color: Colors.amber, fontSize: 25),
          prefixText: prefix),
      style: const TextStyle(color: Colors.amber, fontSize: 25),
    );
  }

  void clearAll() {
    dolarC.clear();
    realC.clear();
    euroC.clear();
  }

  realChanged(String valorReal) {
    if (valorReal.isEmpty) {
      clearAll();
      return;
    }

    valorReal = valorReal.replaceAll(",", "");

    double realAtual = double.parse(valorReal);
    dolarC.text = (realAtual / dolar!).toStringAsFixed(2);
    euroC.text = (realAtual / euro!).toStringAsFixed(2);
  }

  dolarChanged(String valorDolar) {
    if (valorDolar.isEmpty) {
      clearAll();
      return;
    }

    valorDolar = valorDolar.replaceAll(",", "");

    double dolarAtual = double.parse(valorDolar);
    realC.text = (dolarAtual * dolar!).toStringAsFixed(2);
    euroC.text = (dolarAtual * dolar! / euro!).toStringAsFixed(2);
  }

  euroChanged(String valorEuro) {
    if (valorEuro.isEmpty) {
      clearAll();
      return;
    }

    valorEuro = valorEuro.replaceAll(",", "");

    double euroAtual = double.parse(valorEuro);
    realC.text = (euroAtual * euro!).toStringAsFixed(2);
    dolarC.text = (euroAtual * euro! / dolar!).toStringAsFixed(2);
  }
}
