import 'package:flutter/material.dart';
import 'package:vfapp/components/customListTile.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/linhasRest.dart';
import 'package:vfapp/models/mapaCorrenteRest.dart';
import 'package:vfapp/pages/conferencia/conferenciaPage.dart';
import 'package:vfapp/pages/errorPage.dart';

class EscolherPostoPage extends StatefulWidget {
  @override
  EscolherPostoPageState createState() {
    return EscolherPostoPageState();
  }
}

class EscolherPostoPageState extends State<EscolherPostoPage> {
  late Future<MapasDTO> futureMapas;

  @override
  void initState() {
    super.initState();

    /* Pesquisar os mapas correntes da linha d*/
    futureMapas = fetchMapaCorrente(
        VfApp.configuracao.configuracao.linhaSelecionada.cdLinha);
  }

  Future<MapasDTO> fetchMapaCorrente(String cdlinha) {
    MapaCorrenteRest rn = new MapaCorrenteRest();
    return rn.fetchMapaCorrente(cdlinha);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MapasDTO>(
        future: futureMapas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                appBar: AppBar(
                  title: Text('VF Conferência'),
                ),
                body: snapshot.data!.mapas.isEmpty
                    ? Text('Sem mapas alimentados')
                    : Column(
                        children: [
                          Text(
                              'Escolher um dos postos abaixo para iniciar conferência'),
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.mapas.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    padding: EdgeInsets.all(10),
                                    child: CustomListTile(
                                      onCustomPressed: () {
                                        // Chamar a conferencia para o posto escolhido
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ConferenciaPage(
                                                      cdpt: snapshot.data!
                                                          .mapas[index].cdpt,
                                                      cdmapa: snapshot.data!
                                                          .mapas[index].cdmapa,
                                                    )));
                                      },
                                      imagemEsq: '',
                                      subTitulo:
                                          snapshot.data!.mapas[index].cdmapa,
                                      titulo: snapshot.data!.mapas[index].cdpt,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
              ),
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
