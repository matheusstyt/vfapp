import 'dart:convert';

import 'package:vfapp/models/realimentacaoRest.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class HistoricoRest {
  Future<http.Response> getResponse(String cdpt, String cdpa) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/historicoAlimentacao?cdpt=$cdpt&cdpa=$cdpa');
    print('url: $_url');
    return http.get(_url).timeout(
      Duration(seconds: 120),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'ErrorTimeout', 4000); // Replace 500 with your http code.
      },
    );
  }

  Future<MonitorizacoesAlimsDTO> fetchMonitorizacoesAlimsDTO(
      String cdpt, String cdpa) async {
    final response;
    try {
      print('fetching $cdpt $cdpa');
      response = await getResponse(cdpt, cdpa);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }
    print('vou mostrar status code ${response.statusCode}');
    if (response.statusCode == 200) {
      MonitorizacoesAlimsDTO retorno =
          MonitorizacoesAlimsDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load Monitorizacoes Alimentacao DTO');
    }
  }
}

class MonitorizacoesAlimsDTO {
  final String cdPt;
  final String cdMapa;
  final List<MonitorizacaoAlimDTO> monitorizacoes;

  MonitorizacoesAlimsDTO({
    required this.cdPt,
    required this.cdMapa,
    required this.monitorizacoes,
  });

  factory MonitorizacoesAlimsDTO.fromJson(Map<String, dynamic> json) {
    List<MonitorizacaoAlimDTO> listMonitorizacoes = [];

    for (dynamic imonitorizacao in json['ompaproList']) {
      MonitorizacaoAlimDTO monitorizacao = MonitorizacaoAlimDTO(
        cdPt: imonitorizacao['cdPt'],
        cdPa: imonitorizacao['cdPa'],
        cdProduto: imonitorizacao['cdProduto'],
        cdProdutoLido: imonitorizacao['cdProdutoLido'],
        idEmbalagem: imonitorizacao['idEmbalagem'],
        cdMapa: imonitorizacao['cdMapa'],
        qtAlimentada: imonitorizacao['qtAlimentada'],
        qtUsada: imonitorizacao['qtUsada'],
        qtPorPlaca: imonitorizacao['qtPorPlaca'],
        qtAtual: imonitorizacao['qtAtual'],
        cicloPadrao: imonitorizacao['cicloPadrao'],
        previsaoTermino: imonitorizacao['previsaoTermino'],
        qtProdutoRestante: imonitorizacao['qtProdutoRestante'],
        qtCicloRestante: imonitorizacao['qtCicloRestante'],
        tipoAlimentacao: imonitorizacao['tipoAlimentacao'],
        isSucesso: imonitorizacao['isSucesso'],
        dthrLeitura: imonitorizacao['dthrLeitura'],
        alimentador: imonitorizacao['alimentador'],
      );
      listMonitorizacoes.add(monitorizacao);
    }

    MonitorizacoesAlimsDTO monitorizacoesdto = MonitorizacoesAlimsDTO(
        cdPt: json['cdPt'],
        cdMapa: json['cdMapa'],
        monitorizacoes: listMonitorizacoes);

    return monitorizacoesdto;
  }
}

class MonitorizacaoAlimDTO {
  final String cdPt;
  final String cdPa;
  final String cdProduto;
  final String cdProdutoLido;
  final String cdMapa;
  final String idEmbalagem;

  final num qtAlimentada;
  final num qtUsada;
  final num qtPorPlaca;

  final num qtAtual;

  final num cicloPadrao;
  final num previsaoTermino;
  final num qtProdutoRestante;
  final num qtCicloRestante;

  final num tipoAlimentacao;
  final bool isSucesso;
  final String dthrLeitura;
  final String alimentador;

  MonitorizacaoAlimDTO({
    required this.cdPt,
    required this.cdPa,
    required this.cdProduto,
    required this.cdMapa,
    required this.qtAlimentada,
    required this.qtUsada,
    required this.qtPorPlaca,
    required this.qtAtual,
    required this.cicloPadrao,
    required this.previsaoTermino,
    required this.qtProdutoRestante,
    required this.qtCicloRestante,
    required this.tipoAlimentacao,
    required this.isSucesso,
    required this.dthrLeitura,
    required this.alimentador,
    required this.cdProdutoLido,
    required this.idEmbalagem,
  });

  factory MonitorizacaoAlimDTO.fromJson(Map<String, dynamic> json) {
    return MonitorizacaoAlimDTO(
      alimentador: json['alimentador'],
      cdMapa: json['cdMapa'],
      cdPa: json['cdPa'],
      cdProduto: json['cdProduto'],
      cdProdutoLido: json['cdProdutoLido'],
      idEmbalagem: json['idEmbalagem'],
      cdPt: json['cdPt'],
      cicloPadrao: json['cicloPadrao'] ?? 0,
      dthrLeitura: json['dthrLeitura'],
      isSucesso: json['dthrLeitura'],
      previsaoTermino: json['previsaoTermino'] ?? 0,
      qtAlimentada: json['qtAlimentada'] ?? 0,
      qtAtual: json['qtAtual'] ?? 0,
      qtCicloRestante: json['qtCicloRestante'] ?? 0,
      qtPorPlaca: json['qtPorPlaca'] ?? 0,
      qtProdutoRestante: json['qtProdutoRestante'] ?? 0,
      qtUsada: json['qtUsada'] ?? 0,
      tipoAlimentacao: json['tipoAlimentacao'] ?? 0,
    );
  }
}
