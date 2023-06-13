import 'package:flutter/material.dart';
import 'package:vfapp/components/customListTileSemImagem.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/alimentacaoRest.dart';
import 'package:vfapp/models/linhasRest.dart';
import 'package:vfapp/models/mapaAlimentacaoRest.dart';
import 'package:vfapp/models/realimentacaoRest.dart';
import 'package:vfapp/pages/alimentacao/historicoAlimentacaoPage.dart';
import 'package:vfapp/pages/errorPage.dart';

class TabConsultarAlimentacaoPage extends StatefulWidget {
  final String cdposto;
  final String mapa;
  final tabConsultaController tcController;

  TabConsultarAlimentacaoPage(
      {Key? key,
      required this.cdposto,
      required this.mapa,
      required this.tcController})
      : super(key: key);

  @override
  TabConsultarAlimentacaoState createState() {
    return TabConsultarAlimentacaoState();
  }
}

class TabConsultarAlimentacaoState extends State<TabConsultarAlimentacaoPage> {
  late MapaAlimentacaoDTO mapaAlimentacaoDTO;
  late List<MapaAlimentacaoScore> mapaalimscore = [];
  late Future<MapaAlimentacaoDTO> futureMapaAlimentacao;

  @override
  void initState() {
    super.initState();
    futureMapaAlimentacao =
        fetchMapaAlimentacaoDTO(widget.cdposto, widget.mapa);

    widget.tcController.addListener(() {
      if (mounted) {
        setState(() {
          if (!mapaAlimentacaoDTO.pas.isEmpty) {
            mapaalimscore = analisaMapas(
                this.mapaAlimentacaoDTO.pas, widget.tcController.filtro);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<MapaAlimentacaoDTO>(
          future: futureMapaAlimentacao,
          builder: (context, snapshot) {
            // O if abaixo é necessário para avaliar qdo o REST finaliza a partir da 2a vez que ele é executado na tela
            if (snapshot.connectionState == ConnectionState.done) {
              // Se tem dados retornados
              if (snapshot.hasData) {
                // Retorna page com a alimentacao
                // Se nao tiver retorno mostrar mensagem avisando
                if (snapshot.data!.pas.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text('Não existe alimentação para esse posto'),
                  );
                }

                this.mapaAlimentacaoDTO = snapshot.data!;
                mapaalimscore = analisaMapas(
                    this.mapaAlimentacaoDTO.pas, widget.tcController.filtro);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Mapa alimentado:\n${this.mapaAlimentacaoDTO.cdMapa}'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: this.mapaalimscore.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Abaixo formatar o item com a linha formatada para a tela
                          return Container(
                            padding: EdgeInsets.all(2),
                            child: CustomListTileSemImagem(
                              cor: Colors.grey,
                              titulo:
                                  'cdPa - ${mapaalimscore[index].mapaalimentacao.cdPa}',
                              subTitulo:
                                  //'Saldo disponível ${mapaAlimentacaoDTO.pas[index].qtAlimentada}',
                                  'Produto - ${mapaalimscore[index].mapaalimentacao.cdProduto}',
                              hasTrailing: false,
                              onCustomPressed: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              // Se tem erro no retorno
              if (snapshot.hasError) {
                print(snapshot.error);
                return ErrorPage(
                  title: 'Ocorreu um problema:\n' +
                      Funcoes.formataJsonErro(snapshot.error.toString()),
                  isMostrarAppBar: false,
                );
              }
            }

            // Retorna a tela de circulo progress
            return Container(
              color: Color(0xFFF3F7FA),
              child: Center(child: const CircularProgressIndicator()),
            );
          }),
    );
  }

  Future<MapaAlimentacaoDTO> fetchMapaAlimentacaoDTO(
      String cdpt, String mapa) async {
    VfApp.configuracao.configuracao.postoSelecionado = PostoDTO(cdPosto: cdpt);
    MapaAlimentacaoRest rn = new MapaAlimentacaoRest();
    return rn.fetchMapaAlimentacaoDTO(cdpt, mapa);
  }
}

bool verificaPesquisa(String query, String itemText) {
  List<String> values = [];
  List<String> values2 = [];
  values = query.split(" ");
  for (var texto in values) {
    values2.addAll(texto.split(","));
  }
  int cont = 0;
  for (var texto in values2) {
    //print("linha 140 tabConsultarAlimentacaoPage ${texto}");
    if (itemText.toLowerCase().contains(texto.toLowerCase())) {
      cont++;
    }
  }
  if (cont == values2.length) {
    return true;
  } else {
    return false;
  }
}

class tabConsultaController extends ChangeNotifier {
  String filtro = '';

  void atualizaFiltro(String filtro) {
    this.filtro = filtro;
    notifyListeners();
  }
}

List<MapaAlimentacaoScore> analisaMapas(
    List<RealimentacaoDTO> mapasalimentacao, String query) {
  List<MapaAlimentacaoScore> mapascore = [];

  for (RealimentacaoDTO mapaalimentacao in mapasalimentacao) {
    List<String> values = [];
    List<String> values2 = [];
    String textoMapa = mapaalimentacao.cdPa + ' ' + mapaalimentacao.cdProduto;

    values = query.split(" ");
    for (var texto in values) {
      values2.addAll(texto.split(","));
    }

    int cont = 0;
    for (var texto in values2) {
      //print("linha 140 tabConsultarAlimentacaoPage ${texto}");
      if (texto == '' && values2.length <= 1) {
        cont++;
      } else if (textoMapa.toLowerCase().contains(texto.toLowerCase()) &&
          texto != '') {
        cont++;
      }
    }
    if (cont > 0)
      mapascore.add(new MapaAlimentacaoScore(mapaalimentacao, cont));
  }

  mapascore.sort((a, b) => b.score.compareTo(a.score));

  return mapascore;
}

class MapaAlimentacaoScore {
  RealimentacaoDTO mapaalimentacao;
  int score;

  MapaAlimentacaoScore(this.mapaalimentacao, this.score);
}
