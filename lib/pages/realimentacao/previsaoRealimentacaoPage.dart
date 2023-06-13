import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vfapp/components/controllerPesquisa.dart';
import 'package:vfapp/components/customCircularProgress.dart';
import 'package:vfapp/components/customListTile.dart';
import 'package:vfapp/components/customListTileSemImagem.dart';
import 'package:vfapp/components/tituloBarPesquisa.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/models/mapaCorrenteRest.dart';
import 'package:vfapp/models/previsaoRealimentacaoRest.dart';
import 'package:vfapp/pages/consultar/tabConsultarAlimentacaoPage.dart';
import 'package:vfapp/pages/errorPage.dart';
import 'package:vfapp/pages/realimentacao/realimentarLinhasPage.dart';
import 'package:vfapp/pages/realimentacao/realimentarPage.dart';
import 'package:vfapp/pages/realimentacao/realimentarPostoPage.dart';

import '../../main.dart';

/* O objetivo dessa classe é apresentar a previsao da realimentacao das materia-primas de toda a linha
 */
class PrevisaoRealimentacaoPage extends StatefulWidget {
  @override
  _PrevisaoRealimentacaoPage createState() {
    return _PrevisaoRealimentacaoPage();
  }
}

class _PrevisaoRealimentacaoPage extends State<PrevisaoRealimentacaoPage>
    with TickerProviderStateMixin {
  late Future<PrevisoesRealimentacaoDTO> futurePrevisoesRealimentacao;
  late PrevisoesRealimentacaoDTO previsoes =
      PrevisoesRealimentacaoDTO(previsoesRealimentacao: []);
  List<PrevisaoRealimentacaoScore> listaScoreRealimentacao = [];
  final ScrollController _scrollController = ScrollController();
  bool timerIniciado = false;
  int vermelhoate = 10;
  int amareloate = 30;
  int segreclista = 300;
  late Timer _timer;
  bool _isRefreshPage = false;

  // Controller pesquisa armazena os atributos necessario para controlar o botão de pesquisa bem como os atributos da pesquisa
  late ControllerPesquisa controllerPesquisa;

  @override
  void initState() {
    super.initState();

    // inicializa o controller da area de pesquisa
    this.controllerPesquisa =
        ControllerPesquisa(refresh: refresh, ticker: this);

    segreclista = VfApp.configuracao.configuracao.segreclista;
    if (previsoes.previsoesRealimentacao.isNotEmpty) {
      listaScoreRealimentacao = analisaMapas(
          previsoes.previsoesRealimentacao, controllerPesquisa.controller.text);
    }
    futurePrevisoesRealimentacao = fetchPrevisoesRealimentacaoDTO(
        VfApp.configuracao.configuracao.linhaSelecionada.cdLinha);

    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void stopTimer() {
    _timer.cancel();
    timerIniciado = false;
  }

  @override
  void startTimer() {
    if (!timerIniciado) {
      _timer = new Timer.periodic(
          Duration(seconds: segreclista), (Timer timer) => _pullRefresh());
      timerIniciado = true;
      print('timer is not active');
    } else if (!_timer.isActive) {
      _timer = new Timer.periodic(
          Duration(seconds: segreclista), (Timer timer) => _pullRefresh());
      print('timer is not active');
    }
  }

  @override
  Widget build(BuildContext context) {
    vermelhoate = VfApp.configuracao.configuracao.vermelhoate;
    amareloate = VfApp.configuracao.configuracao.amareloate;

    print(
        'prvRealimentacaoPage linha 37 $vermelhoate $amareloate $segreclista');
    return VfApp.configuracao.configuracao.lerid == false
        ? Scaffold(
            appBar: AppBar(
              title: Text('VF Realimentação'),
            ),
            body: Text(
                'Previsão é válida apenas para alimentações com Id. Embalagem'))
        : Container(
            child: FutureBuilder<PrevisoesRealimentacaoDTO>(
                future: futurePrevisoesRealimentacao,
                builder: (context, snapshot) {
                  print(
                      'snapshot.hasData ${snapshot.hasData} e .hasErro ${snapshot.hasError}');
                  if (snapshot.hasData) {
                    this.previsoes = snapshot.data!;

                    _isRefreshPage =
                        false; // seto flag informando que o refresh terminou e que o timer podera chamar novamente

                    // startTimer(); alessandre em 12-11-21 nao devemos iniciar o timer nesse momento, pois o setstate chama esse build e o timer nnunca desativa
                    if (previsoes.previsoesRealimentacao.isNotEmpty) {
                      listaScoreRealimentacao = analisaMapas(
                          previsoes.previsoesRealimentacao,
                          controllerPesquisa.controller.text);
                    }
                    // Retorna a tela com a previsao
                    return Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: controllerPesquisa.heightAppBar,
                        title: TituloBarPesquisa(
                          controllerPesquisa: controllerPesquisa,
                          titulo: 'VF Realimentação',
                        ),
                      ),

                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          // Desabilitar timer
                          stopTimer();
                          // Chamar a realimentacao em branco
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => RealimentarPage()))
                              .then((value) {
                            startTimer();
                          });
                        },
                        child: const Icon(Icons.add),
                        heroTag: 'heroTag2',
                        backgroundColor: Colors.green,
                      ),
                      //body
                      body: previsoes.previsoesRealimentacao.isEmpty
                          ? Text(
                              'Sem previsão de realimentação para a linha ${VfApp.configuracao.configuracao.linhaSelecionada.cdLinha}')
                          : RefreshIndicator(
                              onRefresh: _pullRefresh,
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(8),
                                itemCount: listaScoreRealimentacao.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // Abaixo formatar o item com a linha formatada para a tela

                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        child: CustomListTileSemImagem(
                                          cor: Duration(
                                                          seconds: listaScoreRealimentacao[
                                                                  index]
                                                              .prevrealimentacao
                                                              .previsaoTermino)
                                                      .inMinutes <
                                                  vermelhoate
                                              ? Colors.red
                                              : Duration(
                                                                  seconds: listaScoreRealimentacao[
                                                                          index]
                                                                      .prevrealimentacao
                                                                      .previsaoTermino)
                                                              .inMinutes >=
                                                          vermelhoate &&
                                                      Duration(
                                                                  seconds: listaScoreRealimentacao[
                                                                          index]
                                                                      .prevrealimentacao
                                                                      .previsaoTermino)
                                                              .inMinutes <
                                                          amareloate
                                                  ? Colors.amber.shade300
                                                  : Colors.green,
                                          titulo:
                                              '${listaScoreRealimentacao[index].prevrealimentacao.cdPt} - ${listaScoreRealimentacao[index].prevrealimentacao.cdPa}',
                                          subTitulo:
                                              '$index - Esperado ${listaScoreRealimentacao[index].prevrealimentacao.cdProduto} em ${Duration(seconds: listaScoreRealimentacao[index].prevrealimentacao.previsaoTermino).inMinutes}min',
                                          onCustomPressed: () {
                                            stopTimer();

                                            PrevisaoRealimentacaoDTO previsao =
                                                listaScoreRealimentacao[index]
                                                    .prevrealimentacao;

                                            MapaDTO mapadto = MapaDTO(
                                                previsao.cdPt, previsao.cdMapa);

                                            // Chamar a tela de realimentacao com os dados da previsão escolhida
                                            Navigator.of(context)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RealimentarPostoPage(
                                                  mapadto: mapadto,
                                                  cdPa: previsao.cdPa,
                                                  isMostrarAppBar: true,
                                                ),
                                                // RealimentacaoPage(
                                                //   cdpt: previsao.cdPt,
                                                //   cdmapa: previsao.cdMapa,
                                                //   cdpa: previsao.cdPa,
                                                //   cdproduto: previsao.cdProduto,
                                                // ),
                                              ),
                                            )
                                                .then((value) {
                                              startTimer();
                                            });
                                          },
                                        ),
                                      ),
                                      index ==
                                              listaScoreRealimentacao.length - 1
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .blue.shade900),
                                                  ),
                                                  onPressed: () {
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 300));
                                                    SchedulerBinding.instance
                                                        ?.addPostFrameCallback(
                                                            (_) {
                                                      _scrollController.animateTo(
                                                          _scrollController
                                                              .position
                                                              .minScrollExtent,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      400),
                                                          curve: Curves
                                                              .fastOutSlowIn);
                                                    });
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 80,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons
                                                            .arrow_upward_rounded),
                                                        Text(
                                                          'Retornar ao topo',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            )
                                          : Container(),
                                    ],
                                  );
                                },
                              ),
                            ),
                    );
                  }

                  if (snapshot.hasError) {
                    return ErrorPage(
                        title: 'Ocorreu um problema:\n' +
                            Funcoes.formataJsonErro(snapshot.error.toString()));
                  }

                  // Retorna progress bar para indicar que a pesquisa das ops está em execução
                  return CustomCircularProgress();
                }),
          );
  }

  // Chama o rest que retorna a previsao das realimentacoes
  Future<PrevisoesRealimentacaoDTO> fetchPrevisoesRealimentacaoDTO(
      String cdLinha) async {
    PrevisaoRealimentacaoRest rn = new PrevisaoRealimentacaoRest();

    return rn.fetchPrevisoesRealimentacoesDTO(cdLinha);
  }

  // Usado para filtrar a pesquisa
  List<PrevisaoRealimentacaoScore> analisaMapas(
      List<PrevisaoRealimentacaoDTO> previsoesalimentacao, String filtro) {
    List<PrevisaoRealimentacaoScore> previsoescore = [];

    for (PrevisaoRealimentacaoDTO mapaalimentacao in previsoesalimentacao) {
      List<String> values = [];
      List<String> values2 = [];
      String textoMapa = mapaalimentacao.cdPt +
          ' - ' +
          mapaalimentacao.cdPa +
          ' Esperado ' +
          mapaalimentacao.cdProduto +
          ' em ' +
          (Duration(seconds: mapaalimentacao.previsaoTermino).inMinutes)
              .toString() +
          'min' +
          ' ';

      values = filtro.split(" ");
      for (var texto in values) {
        values2.addAll(texto.split(","));
      }

      // Considera o filtro do campo pesquisar para filtrar os pontos de alimentacao
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
        previsoescore
            .add(new PrevisaoRealimentacaoScore(mapaalimentacao, cont));
    }

    // Ordena as previsoes de realimentação com os menores tempos para realimentar
    previsoescore.sort((a, b) =>
        b.prevrealimentacao.previsaoTermino
            .compareTo(a.prevrealimentacao.previsaoTermino) *
        -1);

    return previsoescore;
  }

  Future<void> _pullRefresh() async {
    // Se o refresh estiver sendo executado entao nao devemos executar novamente
    if (!_isRefreshPage) {
      _isRefreshPage = true;
      setState(() {
        futurePrevisoesRealimentacao = fetchPrevisoesRealimentacaoDTO(
            VfApp.configuracao.configuracao.linhaSelecionada.cdLinha);
      });
      await Future.delayed(Duration(seconds: 7));
    }
  }

  // atualiza apenas a GUI. Em geral usado quando o teclado é ativado/desativado
  refresh() {
    setState(() {
      if (previsoes.previsoesRealimentacao.isNotEmpty &&
          controllerPesquisa.controller.text.isNotEmpty) {
        listaScoreRealimentacao = analisaMapas(previsoes.previsoesRealimentacao,
            controllerPesquisa.controller.text);
      }
    });
  }
}

class PrevisaoRealimentacaoScore {
  PrevisaoRealimentacaoDTO prevrealimentacao;
  int score;

  PrevisaoRealimentacaoScore(this.prevrealimentacao, this.score);
}
