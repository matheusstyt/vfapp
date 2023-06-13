import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vfapp/main.dart';

class ValidadeProdutoRest {
  Future<http.Response> getResponse(String codpro, String cData, String cHora) {
    print(
        'Vou conectar ao servidor ${VfApp.configuracao.configuracao.urlProtheus}');
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.urlProtheus}/getValid/$codpro?cData=$cData&cHora=$cHora');

    return http.get(_url).timeout(
      Duration(seconds: 60),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response('Timeout em ${_url.toString()}',
            4000); // Replace 500 with your http code.
      },
    );
  }

  Future<ValidadeProdutoDTO> fetchValidadeDTO(
      String codpro, String cData, String cHora) async {
    final response;
    try {
      response = await getResponse(codpro, cData, cHora);
      print(response.body);
    } catch (e) {
      throw Exception("Erro na conexão: " + e.toString());
    }

    print('vou mostrar status code ${response.statusCode}');
    if (response.statusCode == 200) {
      ValidadeProdutoDTO retorno =
          ValidadeProdutoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }
}

class ValidadeProdutoDTO {
  final String codpro;
  final String dataValidade;

  ValidadeProdutoDTO({required this.codpro, required this.dataValidade});

  factory ValidadeProdutoDTO.fromJson(Map<String, dynamic> json) {
    ValidadeProdutoDTO retorno = ValidadeProdutoDTO(
        codpro: json['codpro'], dataValidade: json['dataValidade']);

    return retorno;
  }
}
