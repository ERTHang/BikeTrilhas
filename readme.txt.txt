Nesta versão, foi feito o merge com as branchs release e requia

Foi passado a chave release.jks e local.properties da ultima versão 
do app (verão para a playstore) feita pelo Endrew

Nesta versão, a aba de editar uma trilha, está funcionando depois da modificação no arquivo
./lib/app/modules/Components/edição_trilhas na parte dos subtipos
*****
                  Visibility(
                    child: Center(
                      child: DropdownButton<String>(
                        value: 'Ciclovia',
                        hint: Text(
                          'Subtipo',
                          style: TextStyle(color: Colors.red),
                        ),
                        // disabledHint: Text('Subtipo'),
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
			...
*****
Com isso, trilhas e cicloturismo não podem mudar de tipo, apenas a ciclovia pode mudar para 
ciclorota, compartilhada e ciclofaixa