import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/save_trilha.dart';
import 'package:flutter/material.dart';

class SavedTrailsPage extends StatelessWidget {
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
              color: Colors.grey[200],
              child: Container(
                padding: EdgeInsets.all(10),
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
                                  height: 50,
                                  child: FlatButton(
                                    splashColor: Colors.grey[400],
                                    child: LayoutBuilder(
                                        builder: (context, constraint) {
                                      return new Icon(
                                        Icons.delete_outline_rounded,
                                        size: constraint.biggest.height,
                                        color: Colors.black45,
                                      );
                                    }),
                                    onPressed: () {
                                      alert(context, 'Em contrução');
                                    },
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  child: FlatButton(
                                    splashColor: Colors.grey[400],
                                    child: LayoutBuilder(
                                        builder: (context, constraint) {
                                      return new Icon(
                                        Icons.location_on_outlined,
                                        size: constraint.biggest.height,
                                        color: Colors.black45,
                                      );
                                    }),
                                    onPressed: () {
                                      alert(context, 'Em contrução');
                                    },
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
}
