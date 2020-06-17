import 'package:biketrilhas_modular/app/shared/drawer/drawer_page.dart';
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
          title: Text('Filtros'),
          centerTitle: true,
        ),
        drawer: DrawerPage(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              controller.filtrar(_data, controller);
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
          dificuldade(),
          regiao(),
          bairro(),
          superficie(),
          //categoria()
        ]);
  }

  ExpansionPanel tipo() {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return header(_data[0], onTap: (Item item) {
          item.value = null;
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
                  _data[0].modified = 2;
                  _data[0].value = value;
                });
              },
            ),
            title: Text('Ciclovia'),
            onTap: () {
              setState(() {
                _data[0].modified = 2;
                _data[0].value = 'Ciclovia';
              });
            },
          ),
          ListTile(
            leading: Radio(
              groupValue: _data[0].value,
              value: 'Trilha',
              onChanged: (value) {
                setState(() {
                  _data[0].modified = 1;
                  _data[0].value = value;
                });
              },
            ),
            title: Text('Trilha'),
            onTap: () {
              setState(() {
                _data[0].modified = 1;
                _data[0].value = 'Trilha';
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
        return header(_data[1], onTap: (Item item) {
          item.value = null;
        });
      },
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Radio(
              groupValue: _data[1].value,
              value: 'Fácil',
              onChanged: (value) {
                setState(() {
                  _data[1].modified = 1;
                  _data[1].value = value;
                });
              },
            ),
            title: Text('Fácil'),
            onTap: () {
              setState(() {
                _data[1].modified = 1;
                _data[1].value = 'Fácil';
              });
            },
          ),
          ListTile(
            leading: Radio(
              groupValue: _data[1].value,
              value: 'Médio',
              onChanged: (value) {
                setState(() {
                  _data[1].modified = 2;
                  _data[1].value = value;
                });
              },
            ),
            title: Text('Médio'),
            onTap: () {
              setState(() {
                _data[1].modified = 2;
                _data[1].value = 'Médio';
              });
            },
          ),
          ListTile(
            leading: Radio(
              groupValue: _data[1].value,
              value: 'Difícil',
              onChanged: (value) {
                setState(() {
                  _data[1].modified = 3;
                  _data[1].value = value;
                });
              },
            ),
            title: Text('Difícil'),
            onTap: () {
              setState(() {
                _data[1].modified = 3;
                _data[1].value = 'Difícil';
              });
            },
          ),
          ListTile(
            leading: Radio(
              groupValue: _data[1].value,
              value: 'Muito Difícil',
              onChanged: (value) {
                setState(() {
                  _data[1].modified = 4;
                  _data[1].value = value;
                });
              },
            ),
            title: Text('Muito Difícil'),
            onTap: () {
              setState(() {
                _data[1].modified = 4;
                _data[1].value = 'Muito Difícil';
              });
            },
          ),
        ],
      ),
      isExpanded: _data[1].isExpanded,
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
              icon: Icon(
                Icons.clear,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  item.modified = 0;
                  onTap(item);
                });
              },
            ),
      selected: item.modified != 0,
      subtitle: (item.modified != 0) ? Text('Modificado') : null,
      onTap: () {
        setState(() {
          item.isExpanded = !item.isExpanded;
        });
      },
    );
  }
}

List<Item> generateItems() {
  return <Item>[
    Item(expandedValue: 'Tipo'),
    Item(expandedValue: 'Dificuldade'),
    Item(
        expandedValue: 'Regiões',
        booleans: [false, false, false, false, false]),
    Item(expandedValue: 'Bairros', booleans: [
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
        booleans: [false, false, false, false, false, false]),
    Item(expandedValue: 'Categorias', booleans: [
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
  ];
}

class Item {
  Item({
    this.expandedValue,
    this.booleans,
    this.value,
    this.modified = 0,
    this.isExpanded = false,
  });

  bool isExpanded;
  int modified;
  String expandedValue;
  List<bool> booleans;
  String value;
}
