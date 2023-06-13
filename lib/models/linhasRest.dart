import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vfapp/models/opRest.dart';

import '../main.dart';

class LinhasRest {
  Future<http.Response> getResponse(String cdFase) {
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/pesquisarGtdeUmFaseQueTenhaPts?cdfase=$cdFase');

    print('vou mostrar a url');
    print(_url);
    return http.get(_url).timeout(
      Duration(seconds: 120),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'ErrorTimeout', 4000); // Replace 500 with your http code.
      },
    );
  }

  Future<LinhasDTO> fetchLinhasDTO(String cdFase) async {
    final response;
    try {
      response = await getResponse(cdFase);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }
    print('vou mostrar status code ${response.statusCode}');
    if (response.statusCode == 200) {
      LinhasDTO retorno = LinhasDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load Linhas');
    }
  }
}

class LinhasDTO {
  final List<LinhaDTO> linhas;

  LinhasDTO({required this.linhas});

  factory LinhasDTO.fromJson(Map<String, dynamic> json) {
    List<LinhaDTO> linhas = [];
    for (dynamic iGt in json['gts']) {
      LinhaDTO linha = LinhaDTO.fromJson(iGt);
      linhas.add(linha);
    }
    LinhasDTO retorno = LinhasDTO(linhas: linhas);

    return retorno;
  }

  Map<String, dynamic> toJson() {
    return {'linhas': linhas};
  }
}

class LinhaDTO {
  final String cdLinha;
  final List<PostoDTO> postos;

  LinhaDTO({required this.cdLinha, required this.postos});

  factory LinhaDTO.fromJson(Map<String, dynamic> json) {
    List<PostoDTO> postos = [];
    dynamic iGt = json['gt'];

    for (dynamic iPt in iGt['omPts']) {
      PostoDTO value = PostoDTO(cdPosto: iPt['cdPt']);
      postos.add(value);
    }

    LinhaDTO retorno = LinhaDTO(cdLinha: iGt['cdGt'], postos: postos);

    return retorno;
  }

  @override
  String toString() {
    String retorno = '';
    for (PostoDTO posto in this.postos) {
      if (posto.cdPosto != null) retorno += posto.cdPosto + ' ';
    }
    return retorno;
  }

  Map<String, dynamic> toJson() {
    return {
      'gt': {'cdGt': this.cdLinha, 'omPts': this.postos},
    };
  }
}

class PostoDTO {
  late String cdPosto = '';
  late String cdMapa = '';
  late OpDTO opdto = OpDTO(nrop: '');

  PostoDTO({required this.cdPosto});

  factory PostoDTO.fromJson(Map<String, dynamic> json) {
    PostoDTO retorno = PostoDTO(cdPosto: json['cdPt']);

    return retorno;
  }

  Map<String, dynamic> toJson() {
    return {'cdPt': this.cdPosto};
  }
}
