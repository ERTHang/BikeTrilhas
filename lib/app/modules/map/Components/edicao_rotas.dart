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
  TextEditingController _baiController;
  TextEditingController _regController;
  String _tipoValue = '';
  String _subtipoValue = '';
  String _difValue = '';
  var _superficies = '';
  var _bairros = '';
  var _regioes = '';
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
    _subtipoValue = _mapController.modelTrilha.subtipo;
    _difValue = _mapController.modelTrilha.dificuldade;
    _supController = TextEditingController();
    _baiController = TextEditingController();
    _regController = TextEditingController();
  }

  exit(DadosTrilhaModel m) async {
    await _infoRepository.updateDadosTrilha(m.codt, m.nome, m.descricao, m.tipo,
        m.dificuldade, m.superficies, m.bairros, m.regioes, m.subtipo);
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

    _bairros = '';
    _mapController.modelTrilha.bairros.forEach((element) {
      if (_bairros == '') {
        _bairros = element;
      } else {
        _bairros = '$_bairros, $element';
      }
      _baiController.text = _bairros;
    });

    _regioes = '';
    _mapController.modelTrilha.regioes.forEach((element) {
      if (_regioes == '') {
        _regioes = element;
      } else {
        _regioes = '$_regioes, $element';
      }
      _regController.text = _regioes;
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
        body: SingleChildScrollView(
          child: Container(
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
                  TextField(
                    controller: _baiController,
                    minLines: 1,
                    maxLines: 3,
                    onTap: () {
                      _showBaiDialog();
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Bairros',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _regController,
                    minLines: 1,
                    maxLines: 3,
                    onTap: () {
                      _showRegDialog();
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Regioes',
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
                  Visibility(
                    child: Center(
                      child: DropdownButton<String>(
                        value: _subtipoValue,
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
                            _subtipoValue = newValue;
                            _mapController.modelTrilha.subtipo = newValue;
                          });
                        },
                        items: List.generate(
                                _infoRepository.subtipos.length,
                                (index) =>
                                    _infoRepository.subtipos[index].subtip_nome)
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    visible: _subtipoValue.isNotEmpty,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<List<String>> _showSupDialog() async {
    return showDialog<List<String>>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Superfícies'),
          content: SingleChildScrollView(
            child: SupContent(
              mapController: _mapController,
              infoRepository: _infoRepository,
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

  Future<List<String>> _showBaiDialog() async {
    return showDialog<List<String>>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bairros'),
          content: SingleChildScrollView(
            child: BaiContent(
              mapController: _mapController,
              infoRepository: _infoRepository,
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

  Future<List<String>> _showRegDialog() async {
    return showDialog<List<String>>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Regioes'),
          content: SingleChildScrollView(
            child: RegContent(
              mapController: _mapController,
              infoRepository: _infoRepository,
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

class SupContent extends StatefulWidget {
  final MapController mapController;
  final InfoRepository infoRepository;

  const SupContent({Key key, this.mapController, this.infoRepository})
      : super(key: key);

  @override
  _SupContentState createState() => _SupContentState();
}

class _SupContentState extends State<SupContent> {
  @override
  Widget build(BuildContext context) {
    return ListBody(
        children: List<Widget>.generate(
      widget.infoRepository.superficies.length,
      (index) => tile((widget.infoRepository.superficies[index].sup_nome)),
    ));
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

class BaiContent extends StatefulWidget {
  final MapController mapController;
  final InfoRepository infoRepository;

  const BaiContent({Key key, this.mapController, this.infoRepository})
      : super(key: key);

  @override
  _BaiContentState createState() => _BaiContentState();
}

class _BaiContentState extends State<BaiContent> {
  final InfoRepository infoRepository = Modular.get();

  @override
  Widget build(BuildContext context) {
    return ListBody(
        children: List<Widget>.generate(
      widget.infoRepository.bairros.length,
      (index) => tile((widget.infoRepository.bairros[index].bai_nome)),
    ));
  }

  CheckboxListTile tile(String title) {
    bool bvalue = widget.mapController.modelTrilha.bairros.contains(title);
    return CheckboxListTile(
      title: Text(title),
      value: bvalue,
      onChanged: (value) {
        if (value) {
          setState(() {
            widget.mapController.modelTrilha.bairros.add(title);
            bvalue = value;
          });
        } else {
          setState(() {
            widget.mapController.modelTrilha.bairros.remove(title);
            bvalue = value;
          });
        }
      },
    );
  }
}

class RegContent extends StatefulWidget {
  final MapController mapController;
  final InfoRepository infoRepository;

  const RegContent({Key key, this.mapController, this.infoRepository})
      : super(key: key);

  @override
  _RegContentState createState() => _RegContentState();
}

class _RegContentState extends State<RegContent> {
  final InfoRepository infoRepository = Modular.get();

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: List<Widget>.generate(widget.infoRepository.regioes.length,
          (index) => tile(widget.infoRepository.regioes[index].reg_nome)),
    );
  }

  CheckboxListTile tile(String title) {
    bool bvalue = widget.mapController.modelTrilha.regioes.contains(title);
    return CheckboxListTile(
      title: Text(title),
      value: bvalue,
      onChanged: (value) {
        if (value) {
          setState(() {
            widget.mapController.modelTrilha.regioes.add(title);
            bvalue = value;
          });
        } else {
          setState(() {
            widget.mapController.modelTrilha.regioes.remove(title);
            bvalue = value;
          });
        }
      },
    );
  }
}
