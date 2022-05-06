// const String URL_BASE = "http://192.168.1.8:8080/";
const String URL_BASE = "http://200.19.107.169:43199/";
int checkedStorage;
int checkedTrails;
int admin;

// Filter related constants
const List<String> SUPERFICIES = [
  'Asfalto',
  'Cimento',
  'Chao Batido',
  'Areia',
  'Cascalho',
  'Single Track'
];

const List<String> SUBTIPOS = [
  'Ciclovia',
  'Ciclorrota',
  'Compartilhada',
  'Ciclofaixa'
];

const List<String> REGIOES = ['Centro', 'Norte', 'Sul', 'Leste', 'Oeste'];

const List<String> CATEGORIAS = [
  'Ausencia de Sinalizacao',
  'Bicicletario',
  'Buraco ou Falha',
  'Continuacao/Retomada',
  'Curva',
  'Obstaculo na pista',
  'Parada/Interrupcao',
  'Sujeira na pista',
  'Inicio Ciclovia/Trilha',
  'Fim Ciclovia/Trilha',
  'Faixa de Seguranca',
  'Ponto de Onibus',
  'Ponte',
  'Mudanca de Lado',
  'Sinalização',
  'Subida Íngreme',
  'Descida Íngreme'
];

const List<String> BAIRROS = [
  'Adhemar Garcia',
  'America',
  'Anita Garibaldi',
  'Atiradores',
  'Aventureiro',
  'Boa Vista',
  'Boehmerwald',
  'Bom Retiro',
  'Bucarein',
  'Centro',
  'Comasa',
  'Costa e Silva',
  'Dona Francisca',
  'Espinheiros',
  'Fatima',
  'Floresta',
  'Gloria',
  'Guanabara',
  'Iririu',
  'Itaum',
  'Itinga',
  'Jardim Iririu',
  'Jardim Paraiso',
  'Jardim Sofia',
  'Jarivatuba',
  'Joao Costa',
  'Morro do Meio',
  'Nova Brasilia',
  'Paranaguamirim',
  'Parque Guarani',
  'Petropolis',
  'Pirabeiraba',
  'Rio Bonito',
  'Saguaçu',
  'Santa Catarina',
  'Santo Antonio',
  'Sao Marcos',
  'Ulysses Guimaraes',
  'Vila Cubatao',
  'Vila Nova',
  'Zona Industrial Norte',
  'Zona Industrial Tupy'
];

// Text constants
const String ABOUT_US_P1 =
    'Este aplicativo é um produto gratuito desenvolvido pelo' +
        ' Núcleo de Estudos sobre Mobilidade Sustentável - NEMOBIS. ';

const String ABOUT_US_P2 =
    'O NEMOBIS é um programa de extensão universitária desenvolvido pela ' +
        'Universidade do Estado de Santa Catarina - UDESC, em seu campus na cidade de Joinville/SC. ' +
        'Ele tem por objetivo a promoção de ações que visem incentivar o uso de modos sustentáveis de transporte, ' +
        'tais como a bicicleta.';

const String APP_WEBSITE = 'https://www.udesc.br';
const String APP_EMAIL = 'nemobis.udesc@gmail.com';
const String APP_EMAIL_URL = 'mailto:nemobis.udesc@gmail.com';
const String APP_INSTAGRAM = '@nemobis.udesc';
const String APP_INSTAGRAM_URL = 'http://instagram.com/_u/nemobis.udesc/';
