import 'dart:convert';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'dart:developer' as developer;

import 'realimentacaoRest.dart';

class AlimentacaoRest {
  Future<http.Response> getResponse(String cdpt, String filtrar) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/getAlimentacaoDTO?cdpt=$cdpt&filtrar=$filtrar');

    developer.log('vou mostrar a url $_url');
    print('vou mostrar a url $_url');

    return http.get(_url).timeout(
      Duration(seconds: 240),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'ErrorTimeout', 4000); // Replace 500 with your http code.
      },
    );
  }

  Future<http.Response> getResponseSetAlimentacao(
      AlimentacaoDTO alimentacaodto) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/setAlimentacaoDTO');
    String _body = jsonEncode(alimentacaodto);

    print('vou mostrar a url $_url');
    print('vou mostrar o body $_body');

    developer.log('vou mostrar a url $_url');
    developer.log('vou mostrar o body $_body');

    return http.post(_url,
        body: _body, headers: {'Content-Type': 'application/json'}).timeout(
      Duration(seconds: 120),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'ErrorTimeout', 4000); // Replace 500 with your http code.
      },
    );
  }

  Future<http.Response> getResponseSetConferencia(
      AlimentacaoDTO alimentacaodto) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/setConferenciaDTO');
    String _body = jsonEncode(alimentacaodto);

    print('vou mostrar a url $_url');
    print('vou mostrar o body $_body');

    developer.log('vou mostrar a url $_url');
    developer.log('vou mostrar o body $_body');

    return http.post(_url,
        body: _body, headers: {'Content-Type': 'application/json'}).timeout(
      Duration(seconds: 120),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'ErrorTimeout', 4000); // Replace 500 with your http code.
      },
    );
  }

  Future<AlimentacaoDTO> setAlimentacaoDTO(
      AlimentacaoDTO alimentacaodto) async {
    final response;
    try {
      print(alimentacaodto);
      response = await getResponseSetAlimentacao(alimentacaodto);
    } on Exception catch (_) {
      throw Exception('Erro conexão setAlimentacao');
    }
    developer.log('response ${response.body}');
    print('response ${response.body}');
    if (response.statusCode == 200) {
      AlimentacaoDTO retorno =
          AlimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load setAlimentacao');
    }
  }

  Future<AlimentacaoDTO> setConferenciaDTO(
      AlimentacaoDTO alimentacaodto) async {
    final response;
    try {
      response = await getResponseSetConferencia(alimentacaodto);
    } on Exception catch (_) {
      throw Exception('Erro conexão setConferencia');
    }
    developer.log('response setConferencia ${response.body}');
    print('response ${response.body}');
    if (response.statusCode == 200) {
      AlimentacaoDTO retorno =
          AlimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load setConferencia');
    }
  }

  Future<AlimentacaoDTO> fetchAlimentacaoDTO(
      String cdpt, String filtrar) async {
    final response;

    try {
      response = await getResponse(cdpt, filtrar);
      print('body fetchAlimentacao ${response.body}');
      developer.log('body fetchAlimentacao ${response.body}');
    } on Exception catch (e) {
      developer.log('qual excessao $e');
      print('qual excessao $e');
      throw Exception("Erro na conexão fetchAlimentacaoDTO");
    }
    print('fetchAlimentacaoDTO vou mostrar status code ${response.statusCode}');
    if (response.statusCode == 200) {
      AlimentacaoDTO retorno =
          AlimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load fetchAlimentacao');
    }
  }
}

/* DTO para transferencia de dados do servidor para app
 */
class AlimentacaoDTO {
  final String cdUsr;
  final String cdPt;
  late String cdMapa;
  late bool isSucesso;

  final List<RealimentacaoDTO> alimentacoes;

  AlimentacaoDTO(this.alimentacoes, this.cdUsr, this.cdPt, this.cdMapa);

  factory AlimentacaoDTO.fromJson(Map<String, dynamic> json) {
    //0.15
    if (json == null) {
      // Tratar o caso em que o parâmetro json é nulo
      // Por exemplo, pode retornar um objeto AlimentacaoDTO padrão ou lançar uma exceção
      return AlimentacaoDTO([], '', '', ''); // Substitua os valores padrão conforme necessário
    }

    List<RealimentacaoDTO> alimentacoes = [];
    dynamic alimentacoesAux = json['ompaproList']; // essa tag vem do REST
    if (alimentacoesAux == null)
      alimentacoesAux = json[
          'alimentacoes']; // essa tag vem do dto local salvo em sharedPreferences

    for (dynamic dto in alimentacoesAux) {
      RealimentacaoDTO realimentacao = RealimentacaoDTO(
        cdPt: dto['cdPt'],
        cdMapa: dto['cdMapa'],
        cdPa: dto['cdPa'],
        cdProduto: dto['cdProduto'],
      );
      realimentacao.ordem = dto['ordem'];
      var qtAtual = dto['qtAtual'];
      if (qtAtual == null) qtAtual = dto['qtAlimentada'];

      if (qtAtual == null) qtAtual = 0;

      realimentacao.qtAlimentada = qtAtual.toDouble();
      realimentacao.isSucesso = dto['isSucesso'];
      realimentacao.qtRealimentacoesExecutadas =
          dto['qtrealimentacoesexecutadas'] ?? 0;
      realimentacao.dthrLeitura = dto['dthrLeitura'] != null
          ? DateTime.parse(dto['dthrLeitura'])
          : null;

      alimentacoes.add(realimentacao);
    }
    // bug fix, 0.15, tratar o null
    AlimentacaoDTO retorno = new AlimentacaoDTO(
        alimentacoes,
        json['cdUsr'] ?? "",
        json['cdPt'] ?? "",
        json['cdMapa'] ?? ""
    );

    return retorno;
  }

  Map<String, dynamic> toJson() {
    return {
      'cdUsr': cdUsr,
      'cdPt': cdPt,
      'cdMapa': cdMapa,
      'isSucesso': isSucesso,
      'alimentacoes': alimentacoes.map((i) => i.toJson()).toList(),
    };
  }
}
