import 'package:biketrilhas_modular/app/shared/info/dados_trilha_model.dart';
import 'package:biketrilhas_modular/app/shared/info/dados_waypoint_model.dart';
import 'package:biketrilhas_modular/app/shared/info/info_repository.dart';
import 'package:biketrilhas_modular/app/shared/storage/shared_prefs.dart';
import 'package:biketrilhas_modular/app/shared/utils/functions.dart';
import 'package:flutter/material.dart';

//codigosTrilhasSalvas irá guardar valores inteiros dos códigos das trilhas salvas
List codigosTrilhasSalvas = [];
List<DadosTrilhaModel> dadosTrilhasModel = [];
//Usado na lógica de verificar se alguma trilha foi salva e não está em memória local
int incrementadorTrilhasNovas = 0;
SharedPrefs sharedPrefs = SharedPrefs();

class SaveTrilha {
  int codigo;
  String nome;
  double comprimento;
  double desnivel;
  String tipo;
  String dificuldade;
  List<String> bairros;
  List<String> regioes;
  List<String> superficies;

  SaveTrilha(
    context,
    this.codigo,
    this.nome,
    this.comprimento,
    this.desnivel,
    this.tipo,
    this.dificuldade,
    this.bairros,
    this.regioes,
    this.superficies,
  ) {
    salvar(context, codigo, nome, comprimento, desnivel, tipo, dificuldade,
        bairros, regioes, superficies);
  }
}

Map<String, dynamic> toJson(nome, comprimento, desnivel, tipo, dificuldade,
        bairros, regioes, superficies) =>
    {
      'nome': nome,
      'comprimento': comprimento,
      'desnivel': desnivel,
      'tipo': tipo,
      'dificuldade': dificuldade,
      'bairros': bairros,
      'regioes': regioes,
      'superficies': superficies
    };

//Função para salvar trilha em memória local
salvar(context, codigo, nome, comprimento, desnivel, tipo, dificuldade, bairros,
    regioes, superficies) async {
  if (await isOnline()) {
    if (codigosTrilhasSalvas.contains(codigo)) {
      alert(context, 'Trilha já foi salva!');
    } else {
      sharedPrefs.save(
          codigo.toString(),
          toJson(nome, comprimento, desnivel, tipo, dificuldade, bairros,
              regioes, superficies));
      codigosTrilhasSalvas.add(codigo);
      incrementadorTrilhasNovas += 1;
      await SharedPrefs().save('codigosSalvos', codigosTrilhasSalvas);
      alert(context, 'Trilha salva com sucesso!');
    }
  } else {
    if (codigosTrilhasSalvas.contains(codigo)) {
      alert(context, 'Trilha já foi salva!');
    } else {
      alert(context, 'Sem conexão para salvar!');
    }
  }
}

//Função que busca trilhas salvas em memória local (com alerta)
getPrefs(context, {alerta: false}) async {
  if (await sharedPrefs.haveKey('codigosSalvos') == false) {
    await SharedPrefs().save('codigosSalvos', codigosTrilhasSalvas);
  } else {
    if (codigosTrilhasSalvas.isEmpty || incrementadorTrilhasNovas != 0) {
      codigosTrilhasSalvas = await SharedPrefs().read('codigosSalvos');
      incrementadorTrilhasNovas = 0;
      if (alerta == true) {
        alert(context, 'Busca realizada com sucesso!');
      }
    } else {
      //Irá retornar a mesma lista, sem necessidade de ler todos os codigos novamente
      if (alerta == true) {
        await alert(context, 'Não foram salvas novas trilhas!');
      }
    }
  }
}

//Função deletar trilha da memória local
deleteTrilha(codt) async {
  codigosTrilhasSalvas.remove(codt);
  await sharedPrefs.remove(codt.toString());
  await SharedPrefs().save('codigosSalvos', codigosTrilhasSalvas);
}

//Função que busca trilhas salvas em memória local (sem alerta)
getPrefNoAlert() async {
  if (await sharedPrefs.haveKey('codigosSalvos') == false) {
    await SharedPrefs().save('codigosSalvos', codigosTrilhasSalvas);
  } else {
    if (codigosTrilhasSalvas.isEmpty || incrementadorTrilhasNovas != 0) {
      codigosTrilhasSalvas = await SharedPrefs().read('codigosSalvos');
      incrementadorTrilhasNovas = 0;
    }
  }
}

//Função que converte todas as trilhas salvas em DadosTrilhaModel
allToDadosTrilhaModel() async {
  if (codigosTrilhasSalvas.length != dadosTrilhasModel.length) {
    if (codigosTrilhasSalvas.length > dadosTrilhasModel.length) {
      for (int i = dadosTrilhasModel.length;
          i < codigosTrilhasSalvas.length;
          i++) {
        Map<String, dynamic> mapa =
            await sharedPrefs.read(codigosTrilhasSalvas[i].toString());
        DadosTrilhaModel trilha = DadosTrilhaModel(
            codigosTrilhasSalvas[i],
            mapa['nome'],
            mapa['descricao'],
            mapa['comprimento'],
            mapa['desnivel'],
            mapa['tipo']);
        dadosTrilhasModel.add(trilha);
      }
    } else if (codigosTrilhasSalvas.length < dadosTrilhasModel.length) {
      dadosTrilhasModel = [];
      for (int i = 0; i < codigosTrilhasSalvas.length; i++) {
        Map<String, dynamic> mapa =
            await sharedPrefs.read(codigosTrilhasSalvas[i].toString());
        DadosTrilhaModel trilha = DadosTrilhaModel(
            codigosTrilhasSalvas[i],
            mapa['nome'],
            mapa['descricao'],
            mapa['comprimento'],
            mapa['desnivel'],
            mapa['tipo']);
        dadosTrilhasModel.add(trilha);
      }
    }
  }
}

//********Alertas*********/
alertaInfosTrilha(codigo, context) async {
  await getPrefs(context);
  if (codigosTrilhasSalvas.contains(codigo)) {
    var aux = await sharedPrefs.read(codigo.toString());
    alert(context,
        'Nome: ${aux["nome"]}\nComprimento: ${aux["comprimento"]} Km\nDesnivel: ${aux["desnivel"]}');
  } else {
    alert(context, 'Trilha não disponível!\nSalve antes de buscar os dados!');
  }
}

alert(BuildContext context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Trilha"),
          content: Text(
            msg,
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      );
    },
  );
}
