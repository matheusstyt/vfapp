import 'package:flutter/material.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/mapaCorrenteRest.dart';
import 'package:vfapp/pages/errorPage.dart';
import 'package:vfapp/pages/realimentacao/realimentarLinhasPage.dart';

class RealimentarPage extends StatefulWidget {
  @override
  RealimentarPageState createState() {
    return RealimentarPageState();
  }
}

class RealimentarPageState extends State<RealimentarPage> {
  late Future<MapasDTO> futureMapas;

  Future<MapasDTO> fetchMapaCorrente(String cdlinha) {
    MapaCorrenteRest rn = new MapaCorrenteRest();
    return rn.fetchMapaCorrente(cdlinha);
  }

  @override
  void initState() {
    super.initState();

    /* Pesquisar os mapas correntes da linha d*/
    futureMapas = fetchMapaCorrente(
        VfApp.configuracao.configuracao.linhaSelecionada.cdLinha);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MapasDTO>(
        future: futureMapas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RealimentarLinhasPage(
              mapasdto: snapshot.data!,
            );
          }

          // Avalia se ocorreu algum erro
          if (snapshot.hasError) {
            return ErrorPage(
                title: 'Ocorreu um problema:\n' +
                    Funcoes.formataJsonErro(snapshot.error.toString()));
          }

          // Retorna a tela de circulo progress
          return Container(
            color: Color(0xFFF3F7FA),
            child: Center(child: const CircularProgressIndicator()),
          );
        });
  }
}
