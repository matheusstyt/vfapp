import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vfapp/main.dart';
import 'package:vfapp/models/linhasRest.dart';

class OpRest {

  // Metodo para retornar a URL do REST de pesquisa das ops disponiveis para a linha
  Future<http.Response> getResponseGetOps(String cdLinha) {
    Uri _url = Uri.parse('${VfApp.configuracao.configuracao.url}/rest/vf/getOpsGT?cdlinha=$cdLinha');
    return http.get(_url).timeout(
      Duration(seconds: 120),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'ErrorTimeout', 4000); // Replace 500 with your http code.
      },
    );
  }


  // Meotodo para retornar o DTO com as ops disponiveis para a linha
  Future<OpsDTO> fetchOpsDTO(String cdLinha) async {
    final response;
    try {
      response = await getResponseGetOps(cdLinha);
      print('retorno fetchOpsDTO ${response.body}');
    } on Exception catch (_) {
      throw Exception("Erro na conexão em fetchOpsDTO");
    }
    print('retorno getResponseGetOps ${response.statusCode}');
    if (response.statusCode == 200) {
      OpsDTO retorno = OpsDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load fetchOpsDTO');
    }
  }

}


class OpsDTO {
  final String cdLinha;
  late List<OpDTO> ops;
  late OpDTO opdto = OpDTO(nrop: '');

  OpsDTO({required this.cdLinha});

  factory OpsDTO.fromJson(Map<String, dynamic> json) {
    OpsDTO retorno = OpsDTO(cdLinha: json['cdlinha']);

    return retorno;
  }


  Map<String, dynamic> toJson() {
    return {'cdlinha': this.cdLinha};
  }
}

class OpDTO {
  final String nrop;

  late String cdPosto = '';
  late String cdProduto = '';
  late String dsProduto = '';
  late double producaoPlanejada;
  late double producaoLiquida;

  OpDTO({required this.nrop});

  factory OpDTO.fromJson(Map<String, dynamic> json) {
    OpDTO retorno = OpDTO(nrop: json['nrop']);

    return retorno;
  }

  Map<String, dynamic> toJson() {
    return {'nrop': this.nrop};
  }
}