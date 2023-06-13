import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/models/alimentacaoRest.dart';
import 'package:vfapp/models/mapaAlimentacaoRest.dart';
import 'package:vfapp/pages/errorPage.dart';

/* Essa classe é acionada quando se detecta que existe uma alimentacao pendete e que
é necessario perguntar se o operador deseja dar continuidade a essa pendencia
 */
class RestaurarAlimentacaoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<String?> mapajson = obterConfiguracao('mapa');

    // Retorna a tela com a pegunta se deseja continuar a alimentacao pendente
    return FutureBuilder<String?>(
      future: mapajson,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            print('data = ${snapshot.data!}');
            MapaAlimentacaoDTO mapa =
                MapaAlimentacaoDTO.fromJson(jsonDecode(snapshot.data!));

            return Container(
              child: Column(
                children: [
                  Text(
                      'Alimentação pendente no mapa ${mapa.cdMapa} para o posto ${mapa.pas[0].cdPt}. Deseja continuar alimentando?'),
                ],
              ),
            );
          }
        }

        // Se tem erro no retorno
        if (snapshot.hasError) {
          return ErrorPage(
              title: 'Ocorreu um problema:\n' +
                  Funcoes.formataJsonErro(snapshot.error.toString()));
        }

        return Container(
          color: Color(0xFFF3F7FA),
          child: Center(child: const CircularProgressIndicator()),
        );
      },
    );
  }

  Future<String> obterConfiguracao(String s) async {
    final prefs = await SharedPreferences.getInstance();
    String? retorno;
    if (prefs.containsKey(s)) {
      retorno = prefs.getString(s);
    }
    return retorno!;
  }
}
