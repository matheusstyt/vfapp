import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vfapp/main.dart';
import 'package:vfapp/models/realimentacaoRest.dart';

class MapaAlimentacaoRest {


  // metodo para retornar o mapa alimentado completo de todos os postos de determinada linha
  Future<http.Response> getResponseMapasGT(String cdgt) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/getMapasGT?cdgt=$cdgt');

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


  // Metodo para obter os mapas disponiveis para determinado posto
  Future<http.Response> getResponseMapas(String cdPt) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/getMapasAlimentacaoDTO?cdpt=$cdPt');

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

  Future<http.Response> getResponseMapasDisponiveisParaLinha(String cdLinha) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/getMapasDisponiveisLinha?cdgt=$cdLinha');

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

  // metodo para obter os pontos de alimentacao de determinado mapa de um posto
  Future<http.Response> getResponseMapa(String cdPt, String cdmapa) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/getMapaAlimentacaoDTO?cdpt=$cdPt&cdmapa=$cdmapa');

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


/*
{
"mapaConferidoParaPT":2103,
"mapaPreConferidoParaPT":2834,
"mapaCorrenteParaPT":0,
"mapaAtual":{"cdMapa":"24K008-0_MODEM_HGU_RTF8115VW_TOP_TL2","idMapa":288},
"mapas":[
	{"cdMapa":"24K000-0_RTA9227W_ASKEY_PN_2_TL2","idMapa":159,"isControlarNivelAlimentacao":true},
	{"cdMapa":"24K000-0_RTA9227W_ASKEY_TL2","idMapa":155,"isControlarNivelAlimentacao":true},
	{"cdMapa":"24K002-0_MODEM_VDSL_RTV9015_BOT_TL2","idMapa":430,"isControlarNivelAlimentacao":true},
	{"cdMapa":"24K002-0_MODEM_VDSL_RTV9015_TOP_TL2","idMapa":456,"isControlarNivelAlimentacao":true},
	{"cdMapa":"24K007-0_MODEM_HGU_RTF8115VW_BOT_TL2","idMapa":214,"isControlarNivelAlimentacao":true},
	{"cdMapa":"24K008-0_MODEM_HGU_RTF8115VW_TOP_TL2","idMapa":579,"isControlarNivelAlimentacao":true}],
"mapaCorrente":{"idMapa":0},
"isMapaCorrenteExclusivo":false}
 */
  Future<MapasAlimentacaoDTO> fetchMapasAlimentacaoDTO(String cdPt) async {
    final response;
    try {
      response = await getResponseMapas(cdPt);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }

    if (response.statusCode == 200) {
      MapasAlimentacaoDTO retorno =
          MapasAlimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load Mapas alimentacao');
    }
  }


  Future<MapasAlimentacaoDTO> fetchMapasDisponiveisLinha(String cdLinha) async {
    final response;
    try {
      response = await getResponseMapasDisponiveisParaLinha(cdLinha);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }

    if (response.statusCode == 200) {
      MapasAlimentacaoDTO retorno =
      MapasAlimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load Mapas alimentacao');
    }
  }

  Future<MapaAlimentacaoDTO> fetchMapaAlimentacaoDTO(
      String cdPt, String cdmapa) async {
    final response;
    try {
      response = await getResponseMapa(cdPt, cdmapa);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }

    if (response.statusCode == 200) {
      MapaAlimentacaoDTO retorno = MapaAlimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load Mapas alimentacao');
    }
  }


  Future<MapasAlimentacaoDTO> fetchMapasGT(String cdmapa, String cdposto) async {
    final response;
    try {
      response = await getResponseMapa(cdposto, cdmapa);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }

    if (response.statusCode == 200) {
      MapasAlimentacaoDTO retorno = MapasAlimentacaoDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load Mapas alimentacao');
    }
  }

}

class MapasAlimentacaoDTO {
  final String cdPt;
  final List<MapaAlimentacaoDTO> mapas;

  MapasAlimentacaoDTO({required this.cdPt, required this.mapas});

  factory MapasAlimentacaoDTO.fromJson(Map<String, dynamic> json) {
    List<MapaAlimentacaoDTO> mapas = [];
    for (dynamic mapa in json['mapas']) {
      mapas.add(MapaAlimentacaoDTO.fromJson(mapa));
    }

    return MapasAlimentacaoDTO(cdPt: json['cdPt'], mapas: mapas);
  }
}

class MapaAlimentacaoDTO {
  final String cdMapa;
  late bool isMapaCarregadoEmMaquina;
  late List<RealimentacaoDTO> pas;

  MapaAlimentacaoDTO(
      {required this.cdMapa, this.isMapaCarregadoEmMaquina = false});

  factory MapaAlimentacaoDTO.fromJson(Map<String, dynamic> json) {
    // Verificar se existem PAs para receber
    List<RealimentacaoDTO> pas = [];

    if (json['pas'] != null) {
      print('pas ${json['pas']}');
      for (dynamic pa in json['pas']) {
        RealimentacaoDTO dto = RealimentacaoDTO.fromJson(pa);
        dto.ordem = pa['ordem'];
        pas.add(dto);
      }
    }

    MapaAlimentacaoDTO retorno = MapaAlimentacaoDTO(
        cdMapa: json['cdMapa'] ?? '',
        isMapaCarregadoEmMaquina: json['isAlimentacaoCorrenteExclusiva']);
    retorno.pas = pas;

    return retorno;
  }
  Map<String, dynamic> toJson() {
    return {
      'cdMapa': cdMapa,
      'isMapaCarregadoEmMaquina': isMapaCarregadoEmMaquina,
      'pas': jsonEncode(pas.map( (i) => i.toJson()).toList()).toString(),
    };
  }
}