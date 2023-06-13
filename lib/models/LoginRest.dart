import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vfapp/main.dart';

class LoginRest {
  Future<http.Response> getResponse(String usuario) {
    print('Vou conectar ao servidor ${VfApp.configuracao.configuracao.url}');
    Uri _url = Uri.parse(
        '${VfApp.configuracao.configuracao.url}/rest/vf/isUsuarioAutorizadoLiberarCF?matricula=$usuario');

    return http.get(_url).timeout(
      Duration(seconds: 60),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response('Timeout em ${_url.toString()}',
            4000); // Replace 500 with your http code.
      },
    );
  }

  Future<LoginDTO> fetchLoginDTO(String matricula) async {
    final response;
    try {
      response = await getResponse(matricula);
      print(response.body);
    } on Exception catch (_) {
      throw Exception("Erro na conexão");
    }
    print('vou mostrar status code ${response.statusCode}');
    if (response.statusCode == 200) {
      LoginDTO retorno = LoginDTO.fromJson(jsonDecode(response.body));
      return retorno;
    } else {
      throw Exception('Failed to load Login');
    }
  }
}

class LoginDTO {
  final int idUsuario;
  late String matricula;
  final String apelido;
  final bool isAutorizado;
  final String dthrServidor;
  final String? imagem;

  LoginDTO(
      {required this.idUsuario,
      required this.matricula,
      required this.apelido,
      this.imagem,
      required this.isAutorizado,
      required this.dthrServidor});

  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    LoginDTO retorno = LoginDTO(
        idUsuario: json['idUsuario'],
        matricula: json['matricula'],
        apelido: json['apelido'],
        isAutorizado: json['isAutorizado'],
        dthrServidor: json['dthrServidor']);

    return retorno;
  }
}
