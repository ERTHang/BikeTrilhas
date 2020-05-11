# BikeTrilhas

Projeto em desenvolvimento pelos alunos da Udesc/CCT, Endrew Rafael e Thiago Pimenta junto ao coordenador do grupo NEMOBIS Fabiano Baldo

## Explicação Modular Pattern

### Controller
Os controllers são classes onde estão contidas as variáveis do aplicativo, assim como funções que serão chamadas pelas páginas, para modificar eles será necessário efetuar o passo de execução 5.

### flutter_modular
Ele se concentra em criar módulos para dividir melhor o aplicativo, tendo um módulo principal [app_module](/lib/app/app_module.dart) que possui duas coisas importantes para nós:
* Routers: São as rotas dos outros módulos ou páginas do aplicativo, imagine como em um website, www.site.com levaria à rota inicial, também conhecida como '/', www.site.com/pagina levaria a uma pagina, www.site.com/modulo/pagina levaria à uma pagina roteada dentro de um modulo
* Binds: aqui é você coloca as dependências das rotas presentes neste módulo, isto é os controllers que poderão ser utilizados detro de todo o módulo, por exemplo, se a página 2 necessita de uma variável que foi obtida na pagina 1, ela irá chamar o controller da página 1 desde que ele esteja nos binds.

Um guia bom sobre ele pode ser encontrado no canal flutterando nesta playlist [aqui](https://www.youtube.com/watch?v=v3U1Ot97Fks&list=PLlBnICoI-g-dCE_JiJd7bJnEYbigkX7pq&index=1).

## Passos para execução

1. Flutter instalado e configurado: [Install Flutter](https://flutter.dev/docs/get-started/install)
2. Dispositivo ou emulador conectado ao computador
3. Baixar o zip [aqui](https://codeload.github.com/ERTHang/BikeTrilhas/zip/master?token=AMNCW6STIDNQKXIP6PJBVK26JCJAM) ou executar no terminal :
```bash
git clone https://github.com/ERTHang/BikeTrilhas.git
```
4. Abrir a pasta com Android Studio/ Visual Studio Code, ajuda para os comandos podem ser encontradas em: 
* [Android Studio](https://flutter.dev/docs/development/tools/android-studio)
* [VSCode](https://flutter.dev/docs/development/tools/vs-code)
5. Os códigos .g.dart foram gerados por uma extensão chamada mobx, se for modificar qualquer coisa nos controllers será necessário rodar o código:
```bash
pub run build_runner watch
```
ou instalar a extensão do vscode 'flutter_mobx' e clicar no botão build_runner watch no canto inferior direito
6. (Opcional) Para o Modular Pattern foi utilizado o cli slidy, ele ajuda na hora de criar novos módulos e páginas, instalação e comandos estão neste [repositório](https://github.com/Flutterando/slidy)
