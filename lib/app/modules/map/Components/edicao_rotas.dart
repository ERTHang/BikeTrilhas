import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EdicaoRotas extends StatefulWidget {
  @override
  _EdicaoRotasState createState() => _EdicaoRotasState();
}

class _EdicaoRotasState extends State<EdicaoRotas> {
  TextEditingController _nameController;
  TextEditingController _descController;
  TextEditingController _supController;
  String _tipoValue = '';
  String _difValue = '';
  var _superficies = '';
  final _mapController = Modular.get<MapController>();
  final _infoRepository = Modular.get<InfoRepository>();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: _mapController.modelTrilha.nome);
    _descController =
        TextEditingController(text: _mapController.modelTrilha.descricao);
    _tipoValue = _mapController.modelTrilha.tipo;
    _difValue = _mapController.modelTrilha.dificuldade;
    _supController = TextEditingController();
  }

  exit(DadosTrilhaModel m) async {
    await _infoRepository.updateDadosTrilha(m.codt, m.nome, m.descricao, m.tipo, m.dificuldade, m.superficies);
    bottomSheetTrilha(m.codt);
    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    _superficies = '';
    _mapController.modelTrilha.superficies.forEach((element) {
      if (_superficies == '') {
        _superficies = element;
      } else {
        _superficies = '$_superficies, $element';
      }
      _supController.text = _superficies;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Editar Rota',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final m = _mapController.modelTrilha;
          exit(m);
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.values[4],
            children: [
              TextField(
                controller: _nameController,
                onChanged: (value) {
                  _mapController.modelTrilha.nome = value;
                },
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              TextField(
                controller: _descController,
                onChanged: (value) {
                  _mapController.modelTrilha.descricao = value;
                },
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              TextField(
                controller: _supController,
                minLines: 1,
                maxLines: 3,
                onTap: () {
                  _showSupDialog();
                },
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Superfícies',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: _tipoValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _tipoValue = newValue;
                        _mapController.modelTrilha.tipo = newValue;
                      });
                    },
                    items: <String>['Ciclovia', 'Trilha', 'Cicloturismo']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: _difValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _difValue = newValue;
                        _mapController.modelTrilha.dificuldade = newValue;
                      });
                    },
                    items: <String>[
                      'Facil',
                      'Medio',
                      'Dificil',
                      'Muito Dificil'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> _showSupDialog() async {
    return showDialog<List<String>>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Superfícies'),
          content: SingleChildScrollView(
            child: DialogContent(
              mapController: _mapController,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Salvar'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class DialogContent extends StatefulWidget {
  final MapController mapController;

  const DialogContent({Key key, this.mapController}) : super(key: key);

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: <Widget>[
        tile('Asfalto'),
        tile('Cimento'),
        tile('Chão Batido'),
        tile('Areia'),
        tile('Cascalho'),
        tile('Single Track'),
      ],
    );
  }

  CheckboxListTile tile(String title) {
    bool bvalue = widget.mapController.modelTrilha.superficies.contains(title);
    return CheckboxListTile(
      title: Text(title),
      value: bvalue,
      onChanged: (value) {
        if (value) {
          setState(() {
            widget.mapController.modelTrilha.superficies.add(title);
            bvalue = value;
          });
        } else {
          setState(() {
            widget.mapController.modelTrilha.superficies.remove(title);
            bvalue = value;
          });
        }
      },
    );
  }
}