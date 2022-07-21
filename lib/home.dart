import 'package:convmoedas/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class Conversor extends StatefulWidget {
  const Conversor({Key? key}) : super(key: key);

  @override
  _ConversorState createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  double? coin1;
  double? coin2;
  double? coinV1;
  double? coinV2;

  final realC = MoneyMaskedTextController(
      initialValue: 0.00, decimalSeparator: '.', thousandSeparator: ',');
  final coin1C = MoneyMaskedTextController(
      initialValue: 0.00, decimalSeparator: '.', thousandSeparator: ',');
  final coin2C =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  // final realC = TextEditingController();
  // final dolarC = TextEditingController();
  // final euroC = TextEditingController();

  String moeda = 'USD';
  String moeda2 = 'EUR';

  List<String> moedas = [
    'USD',
    'EUR',
  ];

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
              coin2 = snapshot.data!["results"]["currencies"][moeda2]["buy"];
              coinV2 =
                  snapshot.data!["results"]["currencies"][moeda2]["variation"];

              coin1 = snapshot.data!["results"]["currencies"][moeda]["buy"];
              coinV1 =
                  snapshot.data!["results"]["currencies"][moeda]["variation"];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.monetization_on,
                        size: 150, color: Colors.amber),
                    const Divider(),
                    buidTextField(
                      "BRL",
                      "R\$ ",
                      realC,
                      realChanged2,
                    ),
                    const Divider(),
                    buidTextField(moeda, "\$ ", coin1C, realChanged,
                        variation: coinV1),
                    const Divider(),
                    buidTextField2(moeda2, "\$ ", coin2C, realChanged1,
                        variation: coinV2),
                  ],
                ),
              );
            }
        }
      },
    );
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
        prefixIcon: label != 'BRL'
            ? Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                child: DropdownButton<String>(
                  dropdownColor: Colors.black,
                  hint: Icon(Icons.search_rounded),
                  isDense: true,
                  value: moeda,
                  items: moedas
                      .map(
                        (teste) => DropdownMenuItem(
                          child: Text(
                            teste,
                            style: TextStyle(color: Colors.amber),
                          ),
                          value: teste,
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      moeda = value!;
                      realChanged2(realC.text);
                    });
                  },
                  icon:
                      Icon(Icons.arrow_drop_down_rounded, color: Colors.amber),
                ),
              )
            : TextButton(
                onPressed: null,
                child: Text(
                  prefix,
                  style: TextStyle(color: Colors.amber, fontSize: 18),
                )),
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
        // prefixText: prefix
      ),
      style: const TextStyle(color: Colors.amber, fontSize: 25),
    );
  }

  Widget buidTextField2(String label, String prefix,
      MoneyMaskedTextController C, Function(String) F,
      {double? variation}) {
    return TextField(
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      onChanged: F,
      controller: C,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
          child: DropdownButton<String>(
            underline: Container(height: 0),
            hint: Icon(Icons.search_rounded),
            isDense: true,
            value: moeda2,
            items: moedas
                .map(
                  (teste) => DropdownMenuItem(
                    child: Text(
                      teste,
                      style: TextStyle(color: Colors.amber),
                    ),
                    value: teste,
                  ),
                )
                .toList(),
            onChanged: (String? value) {
              setState(() {
                moeda2 = value!;
                realChanged2(realC.text);
              });          
            },
            icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.amber),
          ),
        ),
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
        // prefixText: prefix
      ),
      style: const TextStyle(color: Colors.amber, fontSize: 25),
    );
  }

  void clearAll() {
    coin1C.clear();
    realC.clear();
    coin2C.clear();
  }

  realChanged(String? valorReal) {
    if (valorReal!.isEmpty) {
      clearAll();
      return;
    }

    valorReal = valorReal.replaceAll(",", "");

    double realAtual = double.parse(valorReal);
    coin2C.text = (realAtual * coin1! / coin2!).toStringAsFixed(2);
    realC.text = (realAtual * coin1!).toStringAsFixed(2);
  }

  realChanged1(String valorReal) {
    if (valorReal.isEmpty) {
      clearAll();
      return;
    }

    valorReal = valorReal.replaceAll(",", "");

    double realAtual = double.parse(valorReal);
    coin1C.text = (realAtual * coin2! / coin1!).toStringAsFixed(2);
    realC.text = (realAtual * coin2!).toStringAsFixed(2);
  }

  realChanged2(String valorDolar) {
    if (valorDolar.isEmpty) {
      clearAll();
      return;
    }
    valorDolar = valorDolar.replaceAll(",", "");

    double dolarAtual = double.parse(valorDolar);
  coin1C.text = (dolarAtual * coin1!).toStringAsFixed(2);
    coin2C.text = (dolarAtual * coin2!).toStringAsFixed(2);
    
  }
}
