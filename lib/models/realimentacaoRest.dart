import 'dart:convert';

import 'package:http/http.dart' as http;

import '../main.dart';

/* Classe responsável em tratar os REST referentes a realimentação
 */
class RealimentacaoRest {



  // Metodo para montar o resopnse de getRealimentacaoDTO
  Future<http.Response> getResponse(
      String cdPt, String cdMapa, String cdPa) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/getRealimentacaoDTO?cdpt=$cdPt&cdmapa=$cdMapa&cdpa=$cdPa');

    print('vou mostrar a url');
    print(_url);
    return http.get(_url).timeout(
      Duration(seconds: 8),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'ErrorTimeout', 4000); // Replace 500 with your http code.
      },
    );
  }

  // Metodo para montar o response de setRealimentacaoDTO
  Future<http.Response> getResponseSalvar(
      String cdpt,
      String cdmapa,
      String cdpa,
      String cdproduto,
      String cblido,
      double quantidade,
      bool isSucesso,
      String login) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/setRealimentacaoDTO?cdpt=$cdpt&cdmapa=$cdmapa&cdpa=$cdpa&cdproduto=$cdproduto&cblido=$cblido&quantidade=$quantidade&sucesso=$isSucesso&login=$login');

    print('vou mostrar a url $_url');
    return http.get(_url).timeout(Duration(seconds: 10), onTimeout: () {
      return http.Response('ErrorTimeout', 4000);
    });
  }





  /* Metodo para obter os dados base para efetivar a realimentacao
   */
  Future<RealimentacaoDTO> fetchRealimentacaoDTO(
      String cdPt, String cdMapa, String cdPa) async {
    final response;
    try {
      response = await getResponse(cdPt, cdMapa, cdPa);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }
    print('vou mostrar status code ${response.statusCode}');
    if (response.statusCode == 200) {
      RealimentacaoDTO retorno =
          RealimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load Linhas');
    }
  }

  /* Metodo para salvar a realimentacao
   */
  Future<RealimentacaoDTO> setRealimentacaoDTO(
      String cdpt,
      String cdmapa,
      String cdpa,
      String cdproduto,
      String cblido,
      double quantidade,
      bool isSucesso,
      String login) async {
    final response;
    try {
      response = await getResponseSalvar(
          cdpt, cdmapa, cdpa, cdproduto, cblido, quantidade, isSucesso, login);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro conexão");
    }
    print('vou mostrar status code ${response.statusCode}');
    if (response.statusCode == 200) {
      RealimentacaoDTO retorno =
          RealimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else
      throw Exception('Falhou o setRealimentacaoDTO');
  }
}

/* DTO com os dados para realizar uma realimentacao

 */
class RealimentacaoDTO {
  // Abaixo campos esperados
  late String cdPt;
  late String cdMapa;
  late String cdPa;
  late String cdProduto;
  late int ordem = 0;
  late List<String> cdProdutoAlternativo = [];

  // Abaixo campos realizados
  late String cdProdutoLido = '';
  late String reelId = '';
  late double qtAlimentada = 0;

  late int qtRealimentacoesExecutadas = 0;
  late String status ='';
  late String title = '';
  late String detail = '';

  late bool isSucesso = false; // se true foi alimentado com sucesso
  DateTime? dthrLeitura;

  RealimentacaoDTO(
      {required this.cdPt,
      required this.cdMapa,
      this.cdPa = '',
      this.cdProduto = ''});

  factory RealimentacaoDTO.fromJson(Map<String, dynamic> json) {
    RealimentacaoDTO retorno;

    // Avaliar se o status veio diferente de 200
    String status = json['status'];
    if (status.compareTo('300') == 0) {
      retorno =
          new RealimentacaoDTO(cdPt: '', cdMapa: '', cdPa: '', cdProduto: '');
      retorno.status = '300';
      retorno.title = json['title'];
      retorno.qtRealimentacoesExecutadas++;
      return retorno;
    } else if (status.compareTo('200') != 0) {
      throw Exception(json['title']);
    }

    retorno = new RealimentacaoDTO(
        cdPt: json['cdPt'] ?? '',
        cdMapa: json['cdMapa'] ?? '',
        cdPa: json['cdPa'] ?? '',
        cdProduto: json['cdProduto'] ?? '');


    List<dynamic> lista = json['cdProdutoAlternativo'];
    retorno.cdProdutoAlternativo = lista.cast<String>();

    retorno.dthrLeitura = json['dthrLeitura'];
    return retorno;
  }


  Map<String, dynamic> toJson() {
    return {
      'cdPt': cdPt,
      'cdMapa': cdMapa,
      'cdPa': cdPa,
      'cdProduto': cdProduto,
      'cdProdutoAlternativo': cdProdutoAlternativo,
      'cdProdutoLido': cdProdutoLido,
      'reelId': reelId,
      'qtAlimentada': qtAlimentada,
      'qtRealimentacoesExecutadas': qtRealimentacoesExecutadas,
      'status': status,
      'title': title,
      'detail': detail,
      'isSucesso': isSucesso,
      'dthrLeitura': dthrLeitura != null ? dthrLeitura?.toIso8601String() : '',
    };
  }

}
