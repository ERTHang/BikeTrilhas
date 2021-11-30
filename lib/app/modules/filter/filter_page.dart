import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'filter_controller.dart';

class FilterPage extends StatefulWidget {
  final String title;
  const FilterPage({Key key, this.title = "Filter"}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends ModularState<FilterPage, FilterController> {
  List<Item> _data = generateItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Filtros',
            style: TextStyle(fontFamily: 'Rancho', fontSize: 25),
          ),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              mapController.tappedTrilha = null;

              store.filtrar(_data, store, context);
            },
            label: Text('Filtrar')),
        body: SingleChildScrollView(
          child: Container(
            child: _buildPanel(),
          ),
        ));
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _data[index].isExpanded = !isExpanded;
          });
        },
        children: <ExpansionPanel>[
          tipo(),
          subtipo(),
          regiao(),
          bairro(),
          superficie(),
          categoria(),
          dificuldade(),
          distancia()
        ]);
  }

  ExpansionPanel distancia() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[7], onTap: (Item item) {
          mapController.distanceValue = 100;
        });
      },
      body: Column(
        children: <Widget>[
          Slider(
            value: mapController.distanceValue.toDouble(),
            min: 50,
            max: 500,
            divisions: 9,
            label: mapController.distanceValue.toString() + ' Km',
            onChanged: (double value) {
              setState(() {
                mapController.distanceValue = value.round();
              });
            },
          )
        ],
      ),
      isExpanded: _data[7].isExpanded,
    );
  }

  ExpansionPanel tipo() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[0], onTap: (Item item) {
          item.value = null;
          store.value = 0;
        });
      },
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Radio(
              groupValue: _data[0].value,
              value: 'Ciclovia',
              onChanged: (value) {
                setState(() {
                  store.value = 2;
                  _data[0].modified = 2;
                  _data[0].value = value;
                  _data[0].modifiedValue.clear();
                  _data[0].modifiedValue.add(value);
                });
              },
            ),
            title: Text('Ciclovia'),
            onTap: () {
              setState(() {
                store.value = 2;
                _data[0].modified = 2;
                _data[0].value = 'Ciclovia';
                _data[0].modifiedValue.clear();
                _data[0].modifiedValue.add(_data[0].value);
              });
            },
          ),
          ListTile(
            leading: Radio(
              groupValue: _data[0].value,
              value: 'Trilha',
              onChanged: (value) {
                setState(() {
                  store.value = 1;
                  _data[0].modified = 1;
                  _data[0].value = value;
                  _data[0].modifiedValue.clear();
                  _data[0].modifiedValue.add(value);
                });
              },
            ),
            title: Text('Trilha'),
            onTap: () {
              setState(() {
                store.value = 1;
                _data[0].modified = 1;
                _data[0].value = 'Trilha';
                _data[0].modifiedValue.clear();
                _data[0].modifiedValue.add(_data[0].value);
              });
            },
          ),
          ListTile(
            leading: Radio(
              groupValue: _data[0].value,
              value: 'Cicloturismo',
              onChanged: (value) {
                setState(() {
                  store.value = 3;
                  _data[0].modified = 3;
                  _data[0].value = value;
                  _data[0].modifiedValue.clear();
                  _data[0].modifiedValue.add(value);
                });
              },
            ),
            title: Text('Cicloturismo'),
            onTap: () {
              setState(() {
                store.value = 3;
                _data[0].modified = 3;
                _data[0].value = 'Cicloturismo';
                _data[0].modifiedValue.clear();
                _data[0].modifiedValue.add(_data[0].value);
              });
            },
          ),
        ],
      ),
      isExpanded: _data[0].isExpanded,
    );
  }

  ExpansionPanel dificuldade() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[6], onTap: (Item item) {
          item.value = null;
        });
      },
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Radio(
              groupValue: _data[6].value,
              value: 'Fácil',
              onChanged: (value) {
                setState(() {
                  _data[6].modified = 1;
                  _data[6].value = value;
                  _data[6].modifiedValue.clear();
                  _data[6].modifiedValue.add(value);
                });
              },
            ),
            title: Text('Fácil'),
            onTap: () {
              setState(() {
                _data[6].modified = 1;
                _data[6].value = 'Fácil';
                _data[6].modifiedValue.clear();
                _data[6].modifiedValue.add(_data[6].value);
              });
            },
          ),
          ListTile(
            leading: Radio(
              groupValue: _data[6].value,
              value: 'Médio',
              onChanged: (value) {
                setState(() {
                  _data[6].modified = 2;
                  _data[6].value = value;
                  _data[6].modifiedValue.clear();
                  _data[6].modifiedValue.add(_data[6].value);
                });
              },
            ),
            title: Text('Médio'),
            onTap: () {
              setState(() {
                _data[6].modified = 2;
                _data[6].value = 'Médio';
                _data[6].modifiedValue.clear();
                _data[6].modifiedValue.add(_data[6].value);
              });
            },
          ),
          ListTile(
            leading: Radio(
              groupValue: _data[6].value,
              value: 'Difícil',
              onChanged: (value) {
                setState(() {
                  _data[6].modified = 3;
                  _data[6].value = value;
                  _data[6].modifiedValue.clear();
                  _data[6].modifiedValue.add(_data[6].value);
                });
              },
            ),
            title: Text('Difícil'),
            onTap: () {
              setState(() {
                _data[6].modified = 3;
                _data[6].value = 'Difícil';
                _data[6].modifiedValue.clear();
                _data[6].modifiedValue.add(_data[6].value);
              });
            },
          ),
          ListTile(
            leading: Radio(
              groupValue: _data[6].value,
              value: 'Muito Difícil',
              onChanged: (value) {
                setState(() {
                  _data[6].modified = 4;
                  _data[6].value = value;
                  _data[6].modifiedValue.clear();
                  _data[6].modifiedValue.add(_data[6].value);
                });
              },
            ),
            title: Text('Muito Difícil'),
            onTap: () {
              setState(() {
                _data[6].modified = 4;
                _data[6].value = 'Muito Difícil';
                _data[6].modifiedValue.clear();
                _data[6].modifiedValue.add(_data[6].value);
              });
            },
          ),
        ],
      ),
      isExpanded: _data[6].isExpanded,
    );
  }

  ExpansionPanel regiao() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[2], onTap: (Item item) {
          item.booleans = [false, false, false, false, false];
        });
      },
      body: Column(
        children: <Widget>[
          tile(2, 0, 'Centro'),
          tile(2, 1, 'Norte'),
          tile(2, 2, 'Sul'),
          tile(2, 3, 'Leste'),
          tile(2, 4, 'Oeste'),
        ],
      ),
      isExpanded: _data[2].isExpanded,
    );
  }

  ExpansionPanel bairro() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[3], onTap: (Item item) {
          item.booleans = [
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false,
            false
          ];
        });
      },
      body: Column(
        children: <Widget>[
          tile(3, 0, 'Adhemar Garcia'),
          tile(3, 1, 'America'),
          tile(3, 2, 'Anita Garibaldi'),
          tile(3, 3, 'Atiradores'),
          tile(3, 4, 'Aventureiro'),
          tile(3, 5, 'Boa Vista'),
          tile(3, 6, 'Boehmerwald'),
          tile(3, 7, 'Bom Retiro'),
          tile(3, 8, 'Bucarein'),
          tile(3, 9, 'Centro'),
          tile(3, 10, 'Comasa'),
          tile(3, 11, 'Costa e Silva'),
          tile(3, 12, 'Dona Francisca'),
          tile(3, 13, 'Espinheiros'),
          tile(3, 14, 'Fatima'),
          tile(3, 15, 'Floresta'),
          tile(3, 16, 'Gloria'),
          tile(3, 17, 'Guanabara'),
          tile(3, 18, 'Iririu'),
          tile(3, 19, 'Itaum'),
          tile(3, 20, 'Itinga'),
          tile(3, 21, 'Jardim Iririu'),
          tile(3, 22, 'Jardim Paraiso'),
          tile(3, 23, 'Jardim Sofia'),
          tile(3, 24, 'Jarivatuba'),
          tile(3, 25, 'Joao Costa'),
          tile(3, 26, 'Morro do Meio'),
          tile(3, 27, 'Nova Brasilia'),
          tile(3, 28, 'Paranaguamirim'),
          tile(3, 29, 'Parque Guarani'),
          tile(3, 30, 'Petropolis'),
          tile(3, 31, 'Pirabeiraba'),
          tile(3, 32, 'Rio Bonito'),
          tile(3, 33, 'Saguaçu'),
          tile(3, 34, 'Santa Catarina'),
          tile(3, 35, 'Santo Antonio'),
          tile(3, 36, 'Sao Marcos'),
          tile(3, 37, 'Ulysses Guimaraes'),
          tile(3, 38, 'Vila Cubatao'),
          tile(3, 39, 'Vila Nova'),
          tile(3, 40, 'Zona Industrial Norte'),
          tile(3, 41, 'Zona Industrial Tupy'),
        ],
      ),
      isExpanded: _data[3].isExpanded,
    );
  }

  ExpansionPanel superficie() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[4], onTap: (Item item) {
          item.booleans = [false, false, false, false, false, false];
        });
      },
      body: Column(
        children: <Widget>[
          tile(4, 0, 'Asfalto'),
          tile(4, 1, 'Cimento'),
          tile(4, 2, 'Chao Batido'),
          tile(4, 3, 'Areia'),
          tile(4, 4, 'Cascalho'),
          tile(4, 5, 'Single Track'),
        ],
      ),
      isExpanded: _data[4].isExpanded,
    );
  }

  ExpansionPanel subtipo() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[1], onTap: (Item item) {
          item.booleans = [false, false, false, false];
        });
      },
      body: Column(
        children: <Widget>[
          tile(1, 0, 'Ciclovia'),
          tile(1, 1, 'Ciclorrota'),
          tile(1, 2, 'Compartilhada'),
          tile(1, 3, 'Ciclofaixa'),
        ],
      ),
      isExpanded: _data[1].isExpanded,
    );
  }

  ExpansionPanel categoria() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[5], onTap: (Item item) {
          item.booleans = [false, false, false, false, false, false];
        });
      },
      body: Column(
        children: <Widget>[
          tile(5, 0, 'Ausencia de Sinalizacao'),
          tile(5, 1, 'Bicicletario'),
          tile(5, 2, 'Buraco ou Falha'),
          tile(5, 3, 'Continuacao/Retomada'),
          tile(5, 4, 'Curva'),
          tile(5, 5, 'Obstaculo na pista'),
          tile(5, 6, 'Parada/Interrupcao'),
          tile(5, 7, 'Sujeira na pista'),
          tile(5, 8, 'Inicio Ciclovia/Trilha'),
          tile(5, 9, 'Fim Ciclovia/Trilha'),
          tile(5, 10, 'Faixa de Seguranca'),
          tile(5, 11, 'Ponto de Onibus'),
          tile(5, 12, 'Ponte'),
          tile(5, 13, 'Mudanca de Lado'),
          tile(5, 14, 'Sinalização'),
          tile(5, 15, 'Subida Íngreme'),
          tile(5, 16, 'Descida Íngreme'),
        ],
      ),
      isExpanded: _data[5].isExpanded,
    );
  }

  CheckboxListTile tile(int bigindex, int index, String title) {
    return CheckboxListTile(
      value: _data[bigindex].booleans[index],
      onChanged: (value) {
        setState(() {
          _data[bigindex].booleans[index] = value;
          _data[bigindex].modified += (value) ? -1 : 1;
          if (value) {
            _data[bigindex].modifiedValue.add(title);
          } else {
            _data[bigindex].modifiedValue.removeWhere((item) => item == title);
          }
        });
      },
      title: Text(title),
    );
  }

  Widget header(Item item, {Function onTap}) {
    return ListTile(
      title: Text(item.expandedValue),
      leading: (item.modified == 0)
          ? Icon(Icons.filter_list)
          : IconButton(
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(maxWidth: 24),
              icon: Icon(
                Icons.clear,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  item.modified = 0;
                  item.modifiedValue.clear();
                  item.isExpanded = false;
                  onTap(item);
                });
              },
            ),
      selected: item.modified != 0 && item.expandedValue != 'Tipo',
      subtitle: (item.modified != 0)
          ? (item.modifiedValue.length == 1)
              ? Text(item.modifiedValue.first)
              // : Text(item.modifiedValue.fold(item.modifiedValue[0],
              //     (previousValue, element) => '$previousValue, $element'))
              : Text(item.modifiedValue
                  .reduce((value, element) => '$value, $element'))
          : null,
      onTap: () {
        setState(() {
          item.isExpanded = !item.isExpanded;
        });
      },
    );
  }
}

List<Item> generateItems() {
  FilterController controller = Modular.get<FilterController>();
  return <Item>[
    Item(
        expandedValue: 'Tipo',
        value: (controller.value == 1)
            ? 'Trilha'
            : (controller.value == 2)
                ? 'Ciclovia'
                : (controller.value == 3)
                    ? 'Cicloturismo'
                    : '',
        modified: controller.value,
        modifiedValue: [
          (controller.value == 1)
              ? 'Trilha'
              : (controller.value == 2)
                  ? 'Ciclovia'
                  : 'Cicloturismo'
        ]),
    Item(
        expandedValue: 'Subtipos',
        modifiedValue: [],
        booleans: [false, false, false, false]),
    Item(
        expandedValue: 'Regiões',
        modifiedValue: [],
        booleans: [false, false, false, false, false]),
    Item(expandedValue: 'Bairros', modifiedValue: [], booleans: [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ]),
    Item(
        expandedValue: 'Superfícies',
        modifiedValue: [],
        booleans: [false, false, false, false, false, false]),
    Item(expandedValue: 'Categorias', modifiedValue: [], booleans: [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ]),
    Item(expandedValue: 'Dificuldade', modifiedValue: []),
    Item(expandedValue: 'Distancia', modifiedValue: []),
  ];
}

class Item {
  Item({
    this.expandedValue,
    this.booleans,
    this.value,
    this.modifiedValue,
    this.modified = 0,
    this.isExpanded = false,
  });

  bool isExpanded;
  int modified;
  String expandedValue;
  List<bool> booleans;
  String value;
  List<String> modifiedValue;
}
