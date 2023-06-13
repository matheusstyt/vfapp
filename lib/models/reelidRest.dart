import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vfapp/main.dart';

class ReelidRest {

  Future<http.Response> getResponse(String reelid) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/getReelidDTO?id=$reelid');

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



  Future<ReelidDTO> fetchReelidDTO(String reelid) async {
    final response;
    try {
      response = await getResponse(reelid);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }
    print('vou mostrar status code ${response.statusCode}');
    if (response.statusCode == 200) {
      ReelidDTO retorno =
      ReelidDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load fetchReelid');
    }
  }

}

class ReelidDTO {
  final String reelid;
  final double saldo;

  ReelidDTO(this.reelid, this.saldo);

  factory ReelidDTO.fromJson(Map<String, dynamic> json) {
    return ReelidDTO(json['reelid'], json['saldo']);
  }


}