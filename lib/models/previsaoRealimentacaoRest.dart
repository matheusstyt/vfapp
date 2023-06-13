import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vfapp/main.dart';

class PrevisaoRealimentacaoRest {
  Future<http.Response> getResponse(String cdgt) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/getMonitorizacaoAlimComFiltro?cdgt=$cdgt');

    print('vou mostrar a url $_url');
    return http.get(_url).timeout(
      Duration(seconds: 60),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'ErrorTimeout', 4000); // Replace 500 with your http code.
      },
    );
  }

  Future<PrevisoesRealimentacaoDTO> fetchPrevisoesRealimentacoesDTO(
      String cdgt) async {
    final response;
    try {
      response = await getResponse(cdgt);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }
    print('vou mostrar status code ${response.statusCode}');
    if (response.statusCode == 200) {
      PrevisoesRealimentacaoDTO retorno =
          PrevisoesRealimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load Previsoes Realimentacao');
    }
  }
}

class PrevisoesRealimentacaoDTO {
  final List<PrevisaoRealimentacaoDTO> previsoesRealimentacao;

  PrevisoesRealimentacaoDTO({required this.previsoesRealimentacao});

  factory PrevisoesRealimentacaoDTO.fromJson(Map<String, dynamic> json) {
    List<PrevisaoRealimentacaoDTO> previsoes = [];
    for (dynamic iPrevisao in json['ompaproList']) {

      PrevisaoRealimentacaoDTO previsao = PrevisaoRealimentacaoDTO(
          cdPt: iPrevisao['cdPt'],
          cdPa: iPrevisao['cdPa'],
          cdProduto: iPrevisao['cdProduto'],
          cdMapa: iPrevisao['cdMapa'],
          qtAlimentada: iPrevisao['qtAlimentada'],
          qtUsada: iPrevisao['qtUsada'].toInt(),
          qtPorPlaca: iPrevisao['qtPorPlaca'].toDouble(),
          qtAtual: iPrevisao['qtAtual'].toInt(),
          cicloPadrao: iPrevisao['cicloPadrao'],
          previsaoTermino: iPrevisao['previsaoTermino'],
          qtProdutoRestante: iPrevisao['qtProdutoRestante'],
          qtCicloRestante: iPrevisao['qtCicloRestante']);
      previsoes.add(previsao);
    }
    PrevisoesRealimentacaoDTO retorno =
        PrevisoesRealimentacaoDTO(previsoesRealimentacao: previsoes);

    return retorno;
  }
}

/* Classe para recebimento dos dados da previsao de realimentacao

 */
class PrevisaoRealimentacaoDTO {
  final String cdPt;
  final String cdPa;
  final String cdProduto;
  final String cdMapa;

  final int qtAlimentada;
  final int qtUsada;
  final double qtPorPlaca;

  final int qtAtual;

  final double cicloPadrao;
  final int previsaoTermino;
  final int qtProdutoRestante;
  final int qtCicloRestante;

  PrevisaoRealimentacaoDTO(
      {required this.cdPt,
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
      required this.qtCicloRestante});

  factory PrevisaoRealimentacaoDTO.fromJson(Map<String, dynamic> json) {
    return PrevisaoRealimentacaoDTO(
        cdPt: json['cdPt'],
        cdPa: json['cdPa'],
        cdProduto: json['cdProduto'],
        cdMapa: json['cdMapa'],
        qtAlimentada: json['qtAlimentada'],
        qtUsada: json['qtUsada'],
        qtPorPlaca: json['qtPorPlaca'],
        qtAtual: json['qtAtual'],
        cicloPadrao: json['cicloPadrao'],
        previsaoTermino: json['previsaoTermino'],
        qtProdutoRestante: json['qtProdutoRestante'],
        qtCicloRestante: json['qtCicloRestante']);
  }
}
