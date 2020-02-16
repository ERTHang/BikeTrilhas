# Documentation

## main

Classe apenas para inicialização do projeto, já indo para a pagina de login.

## Pages

### login_page


Efetua o login do usuário através do login de uma conta google, utilizando dos plugins [firebase_auth]([firebaselink]) 
e [google_sign_in]([googlelink]), mais detalhes podem ser encontrados via comentários dentro da classe.

![Login Image](/images/signin.png)

### map_page

Inclui o mapa rodando no aplicativo utilizando do plugin [google_maps_flutter]([mapslink]), uma appbar contendo o drawer na pasta Components, além de obter a localização do usuário utilizando o plugin [geolocator]([geolink])

![Map Image](/images/map.png)
![drawer Image](/images/drawer.png)

[firebaselink]: https://pub.dev/packages/firebase_auth
[googlelink]: https://pub.dev/packages/google_sign_in
[mapslink]: https://pub.dev/packages/google_maps_flutter
[geolink]: https://pub.dev/packages/geolocator