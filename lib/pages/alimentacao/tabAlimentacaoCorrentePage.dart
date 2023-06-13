import 'package:flutter/material.dart';
import 'package:vfapp/components/customListTileSemImagem.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/alimentacaoRest.dart';
import 'package:vfapp/models/linhasRest.dart';
import 'package:vfapp/pages/alimentacao/historicoAlimentacaoPage.dart';
import 'package:vfapp/pages/alimentacao/tabAlimentacaoController.dart';
import 'package:vfapp/pages/errorPage.dart';

class TabAlimentacaoCorrentePage extends StatefulWidget {
  final String cdposto;
  final TabAlimentacaoController filtrarController;

  TabAlimentacaoCorrentePage({
    Key? key,
    required this.cdposto,
    required this.filtrarController,
  }) : super(key: key);

  @override
  TabAlimentacaoCorrenteState createState() {
    return TabAlimentacaoCorrenteState();
  }
}

class TabAlimentacaoCorrenteState extends State<TabAlimentacaoCorrentePage> {
  late AlimentacaoDTO alimentacaoDTO;
  late Future<AlimentacaoDTO> futureAlimentacao;

  @override
  void initState() {
    super.initState();
    futureAlimentacao =
        fetchAlimentacaoDTO(widget.cdposto, widget.filtrarController.filtro);

    widget.filtrarController.addListener(() {
      if (mounted) {
        setState(() {
          futureAlimentacao = fetchAlimentacaoDTO(
              widget.cdposto, widget.filtrarController.filtro);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<AlimentacaoDTO>(
          future: futureAlimentacao,
          builder: (context, snapshot) {
            // O if abaixo é necessário para avaliar qdo o REST finaliza a partir da 2a vez que ele é executado na tela
            if (snapshot.connectionState == ConnectionState.done) {
              // Se tem dados retornados
              if (snapshot.hasData) {
                // Retorna page com a alimentacao
                // Se nao tiver retorno mostrar mensagem avisando
                if (snapshot.data!.alimentacoes.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text('Não existe alimentação para esse posto'),
                  );
                }

                // Retorna a lista com as alimentacoes
                this.alimentacaoDTO = snapshot.data!;

                /* Ordena a lista dos PAs na alimentacao */
                this
                    .alimentacaoDTO
                    .alimentacoes
                    .sort((a, b) => a.ordem.compareTo(b.ordem));

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Mapa alimentado:\n${this.alimentacaoDTO.alimentacoes[0].cdMapa}'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: this.alimentacaoDTO.alimentacoes.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Abaixo formatar o item com a linha formatada para a tela
                          return Container(
                            padding: EdgeInsets.all(2),
                            child: CustomListTileSemImagem(
                              // cor: Colors.grey,
                              titulo:
                                  '${alimentacaoDTO.alimentacoes[index].cdPa} - ${alimentacaoDTO.alimentacoes[index].cdProduto}',
                              subTitulo:
                                  '$index - Saldo disponível ${alimentacaoDTO.alimentacoes[index].qtAlimentada}',
                              onCustomPressed: () {
                                // PrevisaoRealimentacaoDTO previsao =
                                // previsoes.previsoesRealimentacao[index];

                                // Chamar a tela de realimentacao com os dados da previsão escolhida
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //       builder: (context) => RealimentacaoPage(
                                //         cdpt: previsao.cdPt,
                                //         cdmapa: previsao.cdMapa,
                                //         cdpa: previsao.cdPa,
                                //         cdproduto: previsao.cdProduto,
                                //       )),
                                // );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HistoricoAlimentacaoPage(
                                            cdpa: alimentacaoDTO
                                                .alimentacoes[index].cdPa,
                                            cdpt: alimentacaoDTO
                                                .alimentacoes[index].cdPt,
                                          )),
                                );
                              },
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

  Future<AlimentacaoDTO> fetchAlimentacaoDTO(
      String cdpt, String filtrar) async {
    AlimentacaoRest rn = new AlimentacaoRest();
    VfApp.configuracao.configuracao.postoSelecionado = PostoDTO(cdPosto: cdpt);
    return rn.fetchAlimentacaoDTO(cdpt, filtrar /*aqui vai entrar o filtrar*/);
  }
}
