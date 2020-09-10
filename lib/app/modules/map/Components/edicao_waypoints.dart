import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EdicaoWaypoint extends StatefulWidget {
  @override
  _EdicaoWaypointState createState() => _EdicaoWaypointState();
}

class _EdicaoWaypointState extends State<EdicaoWaypoint> {
  TextEditingController _nameController;
  TextEditingController _descController;
  TextEditingController _catController;
  var _categorias = '';
  final _mapController = Modular.get<MapController>();
  final _infoRepository = Modular.get<InfoRepository>();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: _mapController.modelWaypoint.nome);
    _descController =
        TextEditingController(text: _mapController.modelWaypoint.descricao);
    _catController = TextEditingController();
  }

  exit(DadosWaypointModel m) async {
    await _infoRepository.updateDadosWaypoint(
        m.codwp, m.codt, m.descricao, m.nome, m.categorias);
    bottomSheetWaypoint(m.codwp);
    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    _categorias = '';
    _mapController.modelWaypoint.categorias.forEach((element) {
      if (_categorias == '') {
        _categorias = element;
      } else {
        _categorias = '$_categorias, $element';
      }
      _catController.text = _categorias;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          'Editar Waypoint',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final m = _mapController.modelWaypoint;
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
                  _mapController.modelWaypoint.nome = value;
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
                  _mapController.modelWaypoint.descricao = value;
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
                controller: _catController,
                minLines: 1,
                maxLines: 3,
                onTap: () {
                  _showCatDialog();
                },
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Categorias',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> _showCatDialog() async {
    return showDialog<List<String>>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Categorias'),
          content: SingleChildScrollView(
            child: DialogContent(
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

class DialogContent extends StatefulWidget {
  final MapController mapController;
  final InfoRepository infoRepository;

  const DialogContent({Key key, this.mapController, this.infoRepository})
      : super(key: key);

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  @override
  Widget build(BuildContext context) {
          return ListBody(
            children: List<Widget>.generate(
                (widget.infoRepository.categorias.length),
                (index) => tile((widget.infoRepository.categorias[index].cat_nome)),
          ));
        }

  CheckboxListTile tile(String title) {
    bool bvalue =
        widget.mapController.modelWaypoint.categorias.contains(title);
    return CheckboxListTile(
      title: Text(title),
      value: bvalue,
      onChanged: (value) {
        if (value) {
          setState(() {
            widget.mapController.modelWaypoint.categorias.add(title);
            bvalue = value;
          });
        } else {
          setState(() {
            widget.mapController.modelWaypoint.categorias.remove(title);
            bvalue = value;
          });
        }
      },
    );
  }
}
