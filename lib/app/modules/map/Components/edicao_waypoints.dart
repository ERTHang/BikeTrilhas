import 'dart:io';

import 'package:biketrilhas_modular/app/modules/map/Components/bottom_sheets.dart';
import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:biketrilhas_modular/app/modules/usertrails/usertrails_controller.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/trilhas/trilha_repository.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';

class EdicaoWaypoint extends StatefulWidget {
  final EditMode editMode;

  const EdicaoWaypoint({Key key, this.editMode}) : super(key: key);

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
  final _trilhaRepository = Modular.get<TrilhaRepository>();
  final _usertrailsController = Modular.get<UsertrailsController>();
  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: _mapController.modelWaypoint.nome);
    _descController =
        TextEditingController(text: _mapController.modelWaypoint.descricao);
    _catController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    if (_mapController.modelWaypoint.categorias == null) {
      _mapController.modelWaypoint.categorias = [];
    }
    if (_mapController.modelWaypoint.descricao == null) {
      _mapController.modelWaypoint.descricao = '';
    }
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
          m.codwp = mapController.nextCodWp();
          saida(m);
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
              imagesBox(mapController.modelWaypoint.imagens, context,
                  widget.editMode),
            ],
          ),
        ),
      ),
    );
  }
//s
  saida(DadosWaypointModel m) async {
    var pos = await Geolocator.getCurrentPosition();
    //EDITAR
    if (widget.editMode == EditMode.UPDATE) {
      await _infoRepository.updateDadosWaypoint(
          m.codwp, m.codt, m.descricao, m.nome, m.categorias);
      bottomSheetWaypoint(m.codwp);
      Modular.to.pop();
    } else {
      //Se o waypoint esta sob gravação
      if (mapController.followTrail != null) {
        mapController.followTrailWaypoints.add(m);
        mapController.newWaypoint.codigo = m.codwp;
        mapController.followTrail.waypoints.add(mapController.newWaypoint);
        mapController.newWaypoint = null;
        Modular.to.popUntil((route) => route.isFirst);
        //Tirando Foto sem Gravar
      } else if (await isOnline() == false &&
          mapController.followTrail == null) {
          //AQUI
        
          //TESTAR
        mapController.followTrailWaypoints.add(m);
        mapController.followTrail =
            TrilhaModel(mapController.nextCodt(), 'MarkerOnly');
        mapController.followTrail.polylineCoordinates
            .add([LatLng(pos.latitude, pos.longitude)]);
        mapController.createdTrails.add(mapController.followTrail);
        mapController.newWaypoint.codigo = m.codwp;
        mapController.createdTrails.last.waypoints
            .add(mapController.newWaypoint);
        mapController.trilhaRepository.saveRecordedWaypoint(m);  
        mapController.trilhaRepository
            .saveRecordedTrail(mapController.followTrail)
            .then((value) {
          Modular.to.pushReplacementNamed('/usertrail');
        });
      } else if (await isOnline()) {
        //Waypoint sem trilha
        int codt = await _showTrilhasDialog();
        if (codt != -1) {
          await _showLoadDialog(m, codt);
                mapController.trilhaRepository.deleteRecordedWaypoint(m.codwp);
                mapController.trilhaRepository.deleteRecordedTrail(mapController.newWaypoint.codigo);
                 alertEdit(context, "Waypoint salvo com sucesso");
                 mapController.state();               
                 _usertrailsController.state();
        }
      }
    }
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

  Future<void> _showLoadDialog(DadosWaypointModel dadoswp, int codt) async {
    Future<bool> uploadSuccess = _infoRepository.uploadWaypoint(
        mapController.newWaypoint, dadoswp, codt);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Carregando'),
          content: SingleChildScrollView(
              child: FutureBuilder(
            future: uploadSuccess,
            builder: (BuildContext _, AsyncSnapshot<bool> snapshot) {
              Widget child = Center(
                child: CircularProgressIndicator(),
              );
              if (snapshot.hasData) {
                if (snapshot.data) {
                  Modular.to.pop();
                } else {
                  child = Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                }
              }
              return child;
            },
          )),
        );
      },
    );
  }

  Future<int> _showTrilhasDialog() async {
    int _selectedIndex;
    List<TrilhaModel> trilhasproximas;
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Selecione uma trilha'),
            content: SingleChildScrollView(
                child: FutureBuilder(
                    future: _infoRepository
                        .getTrilhasProximas(_mapController.newWaypoint.posicao),
                    builder:
                        (BuildContext _, AsyncSnapshot<List<int>> snapshot) {
                      Widget child;
                      if (snapshot.hasData) {
                        if (snapshot.data.isNotEmpty) {
                          trilhasproximas = mapController.trilhas.value
                              .where((element) =>
                                  snapshot.data.contains(element.codt))
                              .toList();
                          child = ListBody(
                              children: List<Widget>.generate(
                                  snapshot.data.length,
                                  (index) => ListTile(
                                        title: Text(
                                          trilhasproximas[index].nome,
                                          style: TextStyle(
                                              color: (index == _selectedIndex)
                                                  ? Colors.blue
                                                  : Colors.black),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = index;
                                          });
                                        },
                                      )));
                        } else {
                          child = Text("Não há nenhuma trilha próxima");
                        }
                      } else {
                        child = Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return child;
                    })),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop(-1);
                  });
                },
              ),
              FlatButton(
                child: Text('Salvar'),
                onPressed: () {
                  setState(() {
                    Navigator.of(context)
                        .pop(trilhasproximas[_selectedIndex].codt);
                  });
                },
              ),
            ],
          );
        });
      },
    );
  }
}

Widget imagesBox(List<String> images, context, EditMode editMode) {
  return Container(
      child: FutureBuilder<bool>(
    future: isOnline(),
    builder: (BuildContext _, AsyncSnapshot<bool> snapshot) {
      Widget child;
      if (snapshot.hasData) {
        if (snapshot.data && editMode != EditMode.ADD) {
          child = Visibility(
              visible: images.length >= 1,
              maintainState: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Row(
                        children: mapController.modelWaypoint.imagens
                            .map((e) => GestureDetector(
                                  child: Hero(
                                    tag: e,
                                    child: CachedNetworkImage(
                                      imageUrl: e,
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: mapController
                                            .scaffoldState.currentContext,
                                        builder: (_) {
                                          return SimpleDialog(
                                            contentPadding: EdgeInsets.all(0),
                                            children: <Widget>[
                                              Container(
                                                child: Stack(
                                                  children: <Widget>[
                                                    PhotoView(
                                                      imageProvider:
                                                          CachedNetworkImageProvider(
                                                              e),
                                                      minScale:
                                                          PhotoViewComputedScale
                                                              .covered,
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      right: 5,
                                                      child: IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                    ),
                                                  ],
                                                  fit: StackFit.expand,
                                                ),
                                                height: MediaQuery.of(
                                                            mapController
                                                                .scaffoldState
                                                                .currentContext)
                                                        .size
                                                        .height *
                                                    0.7,
                                                width: MediaQuery.of(
                                                            mapController
                                                                .scaffoldState
                                                                .currentContext)
                                                        .size
                                                        .width *
                                                    0.7,
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ))
                            .toList()),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.blue,
                        )),
                  ],
                ),
              ));
        } else {
          child = Visibility(
              visible: images.length >= 1,
              maintainState: false,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Row(
                        children: mapController.modelWaypoint.imagens
                            .map((e) => GestureDetector(
                                  child: Hero(
                                    tag: e,
                                    child: Image.file(
                                      File(mapController
                                          .modelWaypoint.imagens[0]),
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: mapController
                                            .scaffoldState.currentContext,
                                        builder: (_) {
                                          return SimpleDialog(
                                            contentPadding: EdgeInsets.all(0),
                                            children: <Widget>[
                                              Container(
                                                child: Stack(
                                                  children: <Widget>[
                                                    PhotoView(
                                                      imageProvider: FileImage(
                                                          File(mapController
                                                              .modelWaypoint
                                                              .imagens[0])),
                                                      minScale:
                                                          PhotoViewComputedScale
                                                              .covered,
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      right: 5,
                                                      child: IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                    ),
                                                  ],
                                                  fit: StackFit.expand,
                                                ),
                                                height: MediaQuery.of(
                                                            mapController
                                                                .scaffoldState
                                                                .currentContext)
                                                        .size
                                                        .height *
                                                    0.7,
                                                width: MediaQuery.of(
                                                            mapController
                                                                .scaffoldState
                                                                .currentContext)
                                                        .size
                                                        .width *
                                                    0.7,
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ))
                            .toList()),
                    // IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(
                    //       Icons.add_a_photo,
                    //       color: Colors.blue,
                    //     )),
                  ],
                ),
              ));
        }
      } else {
        child = Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ));
      }
      return child;
    },
  ));
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
    bool bvalue = widget.mapController.modelWaypoint.categorias.contains(title);
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

alertEdit(BuildContext context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Sucesso"),
          content: Text(
            msg,
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Modular.to.popUntil((route) => route.isFirst);
                })
          ],
        ),
      );
    },
  );
}
