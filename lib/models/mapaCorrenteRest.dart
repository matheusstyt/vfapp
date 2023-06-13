import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vfapp/main.dart';

class MapaCorrenteRest {
// Metodo para obter o codigo do mapa corrente do posto
  Future<http.Response> getResponseMapaCorrente(String cdlinha) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/getMapaCorrenteDTO?cdlinha=$cdlinha');

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



  // Fetch do mapa corrente
  Future<MapasDTO> fetchMapaCorrente(String cdlinha) async {
    final response;
    try {
      response = await getResponseMapaCorrente(cdlinha);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }

    if (response.statusCode == 200) {
      MapasDTO retorno = MapasDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load mapa corrente');
    }
  }
}


class MapasDTO {
  final String cdlinha;
  final List<MapaDTO> mapas;


  factory MapasDTO.fromJson(Map<String, dynamic> json) {
    List<MapaDTO> mapas = [];
    dynamic iMapas = json['mapas'];

    for (dynamic iMapa in iMapas) {
      MapaDTO value = MapaDTO.fromJson(iMapa);
      mapas.add(value);
    }

    MapasDTO retorno = MapasDTO(json['cdgt'], mapas);
    return retorno;
  }

  MapasDTO(this.cdlinha, this.mapas);

}



class MapaDTO {
  final String cdpt;
  final String cdmapa;

  MapaDTO(this.cdpt, this.cdmapa);

  factory MapaDTO.fromJson(Map<String, dynamic> json) {
    MapaDTO retorno = MapaDTO(json['cdpt'], json['cdmapa']);
    return retorno;
  }



}