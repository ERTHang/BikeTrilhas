import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'filter_controller.dart';
import 'package:biketrilhas_modular/app/shared/utils/session.dart';

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
              _colapseAll(_data);
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
          // Sem necessidade uso de bairro no momento
          // bairro(),
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
    Map<int, String> tipos = {2: 'Ciclovia', 1: 'Trilha', 3: 'Cicloturismo'};
    List<int> keys = tipos.keys.toList();

    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[0], onTap: (Item item) {
          item.value = null;
          store.value = 0;
        });
      },
      body: Column(
        children: List.generate(tipos.length, (int index) {
          String title = tipos[keys[index]];
          return ListTile(
            leading: Radio(
              groupValue: _data[0].value,
              value: title,
              onChanged: (value) {
                setState(() {
                  store.value = keys[index];
                  _data[0].modified = keys[index];
                  _data[0].value = value;
                  _data[0].modifiedValue.clear();
                  _data[0].modifiedValue.add(value);
                });
              },
            ),
            title: Text(title),
            onTap: () {
              setState(() {
                store.value = keys[index];
                _data[0].modified = keys[index];
                _data[0].value = title;
                _data[0].modifiedValue.clear();
                _data[0].modifiedValue.add(_data[0].value);
              });
            },
          );
        }),
      ),
      isExpanded: _data[0].isExpanded,
    );
  }

  ExpansionPanel dificuldade() {
    Map<int, String> dificuldades = {
      1: 'Fácil',
      2: 'Médio',
      3: 'Difícil',
      4: 'Muito difícil',
    };

    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[6], onTap: (Item item) {
          item.value = null;
        });
      },
      body: Column(
        children: List.generate(dificuldades.length, (index) {
          int count = index + 1;
          return ListTile(
            leading: Radio(
              groupValue: _data[6].value,
              value: dificuldades[count],
              onChanged: (value) {
                setState(() {
                  _data[6].modified = count;
                  _data[6].value = value;
                  _data[6].modifiedValue.clear();
                  _data[6].modifiedValue.add(value);
                });
              },
            ),
            title: Text(dificuldades[count]),
            onTap: () {
              setState(() {
                _data[6].modified = count;
                _data[6].value = dificuldades[count];
                _data[6].modifiedValue.clear();
                _data[6].modifiedValue.add(_data[6].value);
              });
            },
          );
        }),
      ),
      isExpanded: _data[6].isExpanded,
    );
  }

  ExpansionPanel regiao() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[2], onTap: (Item item) {
          item.booleans = List.filled(5, false);
        });
      },
      body: Column(
          children: List.generate(REGIOES.length, (index) {
        return tile(2, index, REGIOES[index]);
      })),
      isExpanded: _data[2].isExpanded,
    );
  }

  // NOTE - Como app esta operando em mais cidades, filtro por bairro so
  //        tera utilizade quando tiver filtro por cidades
  // ExpansionPanel bairro() {
  //   return ExpansionPanel(
  //     headerBuilder: (BuildContext context, bool isExpanded) {
  //       return header(_data[3], onTap: (Item item) {
  //         item.booleans = List.generate(42, (_) => false);
  //       });
  //     },
  //     body: Column(
  //       children: List.generate(BAIRROS.length, (index) {
  //         return tile(3, index, BAIRROS[index]);
  //       }),
  //     ),
  //     isExpanded: _data[3].isExpanded,
  //   );
  // }

  ExpansionPanel superficie() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[4], onTap: (Item item) {
          item.booleans = List.filled(6, false);
        });
      },
      body: Column(
          children: List.generate(SUPERFICIES.length, (index) {
        return tile(4, index, SUPERFICIES[index]);
      })),
      isExpanded: _data[4].isExpanded,
    );
  }

  ExpansionPanel subtipo() {
    List<Widget> listaSubtipo = store.value == 2
        ? List.generate(SUBTIPOS.length, (index) {
            return tile(1, index, SUBTIPOS[index]);
          })
        : <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Center(
                  child: Text(" Não há Subtipos para ${_data[0].value}")),
            ),
          ];
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[1], onTap: (Item item) {
          item.booleans = List.filled(4, false);
        });
      },
      body: Column(
        children: listaSubtipo,
      ),
      isExpanded: _data[1].isExpanded,
    );
  }

  ExpansionPanel categoria() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[5], onTap: (Item item) {
          item.booleans = List.filled(17, false);
        });
      },
      body: Column(
        children: List.generate(CATEGORIAS.length, (index) {
          return tile(5, index, CATEGORIAS[index]);
        }),
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

void _colapseAll(List<Item> data) {
  for (var i = 0; i < data.length; i++) {
    data[i].isExpanded = false;
  }
}

List<Item> generateItems() {
  FilterController controller = Modular.get<FilterController>();
  Map<int, String> typeValues = {1: 'Trilha', 2: 'Ciclovia', 3: 'Cicloturismo'};
  String type = typeValues.containsKey(controller.value)
      ? typeValues[controller.value]
      : '';
  if (filterDisposed == true || filterData == null) {
    filterDisposed = false;
    filterData = <Item>[
      Item(
          expandedValue: 'Tipo',
          value: type,
          modified: controller.value,
          modifiedValue: [type]),
      Item(
          expandedValue: 'Subtipos',
          modifiedValue: [],
          booleans: List.generate(4, (_) => false)),
      Item(
          expandedValue: 'Regiões',
          modifiedValue: [],
          booleans: List.generate(5, (_) => false)),
      Item(
          expandedValue: 'Bairros',
          modifiedValue: [],
          booleans: List.generate(42, (_) => false)),
      Item(
          expandedValue: 'Superfícies',
          modifiedValue: [],
          booleans: List.generate(6, (_) => false)),
      Item(
          expandedValue: 'Categorias',
          modifiedValue: [],
          booleans: List.generate(17, (_) => false)),
      Item(expandedValue: 'Dificuldade', modifiedValue: []),
      Item(expandedValue: 'Distancia', modifiedValue: []),
    ];
  }
  return filterData;
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
