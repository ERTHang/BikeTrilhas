import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:flutter/material.dart';

class SavedTrailsPage extends StatefulWidget {
  @override
  _SavedTrailsPageState createState() => _SavedTrailsPageState();
}

class _SavedTrailsPageState extends State<SavedTrailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trilhas Salvas',
          style: TextStyle(fontFamily: 'Rancho', fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    List<DadosTrilhaModel> lista = dadosTrilhasModel;

    if (lista.length == 0) {
      return Center(
        child: Container(
          child: Text('Não há trilhas salvas!'),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: lista != null ? lista.length : 0,
          itemBuilder: (context, index) {
            DadosTrilhaModel c = lista[index];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.grey[200],
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Nome: ${c.nome}', style: textStyle()),
                    SizedBox(height: 5),
                    Text('Comprimento: ${c.comprimento} KM',
                        style: textStyle()),
                    SizedBox(height: 5),
                    Text('Desnivel: ${c.desnivel} m', style: textStyle()),
                    SizedBox(height: 5),
                    Text('tipo: ${c.tipo}', style: textStyle()),
                    ButtonBarTheme(
                      data: ButtonBarTheme.of(context),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonBar(
                              children: <Widget>[
                                Container(
                                  height: 45,
                                  child: FlatButton(
                                    splashColor: Colors.grey[400],
                                    child: LayoutBuilder(
                                        builder: (context, constraint) {
                                      return MaterialButton(
                                        shape: CircleBorder(),
                                        child: new Icon(
                                          Icons.delete_outline_rounded,
                                          size: constraint.biggest.height,
                                          color: Colors.black45,
                                        ),
                                        onPressed: () async {
                                          await removerTrilhaMsg(
                                              'Deseja excluir a trilha ${c.nome}?',
                                              c.codt);
                                        },
                                      );
                                    }),
                                    onPressed: () {},
                                  ),
                                ),
                                Container(
                                  height: 45,
                                  child: FlatButton(
                                    splashColor: Colors.grey[400],
                                    child: LayoutBuilder(
                                        builder: (context, constraint) {
                                      return MaterialButton(
                                        shape: CircleBorder(),
                                        child: new Icon(
                                          Icons.location_on_outlined,
                                          size: constraint.biggest.height,
                                          color: Colors.black45,
                                        ),
                                        onPressed: () {
                                          alert(context, 'Em construção');
                                        },
                                      );
                                    }),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  textStyle() {
    return TextStyle(fontWeight: FontWeight.normal, fontSize: 15);
  }

  removerTrilhaMsg(msg, codt) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Remover"),
            content: Text(
              msg,
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('VOLTAR'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('OK'),
                  onPressed: () async {
                    await deleteTrilha(codt);
                    await allToDadosTrilhaModel();
                    Navigator.pop(context);
                    setState(() {});
                  }),
            ],
          ),
        );
      },
    );
  }
}
