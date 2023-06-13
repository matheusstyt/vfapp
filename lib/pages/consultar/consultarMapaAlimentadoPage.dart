import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vfapp/components/customFieldCF.dart';
import 'package:vfapp/components/customListTileSemImagem.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/mapaAlimentacaoRest.dart';
import 'package:vfapp/models/realimentacaoRest.dart';
import 'package:vfapp/pages/consultar/tabConsultarAlimentacaoPage.dart';
import 'package:vfapp/pages/errorPage.dart';
import 'package:vfapp/pages/somVibracao.dart';

class ConsultarMapaAlimentadoPage extends StatefulWidget {
  final String posto;
  final String mapa;

  const ConsultarMapaAlimentadoPage(
      {Key? key, required this.mapa, required this.posto})
      : super(key: key);

  @override
  ConsultarMapaAlimentadoState createState() {
    return ConsultarMapaAlimentadoState();
  }
}

/* Inicialmente essa classe deve carregar todos os mapas alimentados na linha selecionada
e permitir pesquisar nesses mapas o que for lido no campo Consultar
 */
class ConsultarMapaAlimentadoState extends State<ConsultarMapaAlimentadoPage> {
  late List<RealimentacaoDTO> listaPAs = [];
  late List<RealimentacaoDTO> listaPAsFiltrada = [];

  late Future<MapaAlimentacaoDTO> futureMapasAlimentacao;

  late String ultimoFiltro = '';

  final TextEditingController controllerConsulta = TextEditingController();
  final FocusNode focoConsulta = FocusNode();
  late bool isTecladoAtivo = VfApp.configuracao.configuracao.tecladoHabilitado;

  @override
  void initState() {
    super.initState();

    futureMapasAlimentacao = fetchMapasAlimentacao(widget.mapa, widget.posto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VF Consulta'),
      ),
      body: FutureBuilder<MapaAlimentacaoDTO>(
          future: futureMapasAlimentacao,
          builder: (context, snapshot) {
            if (snapshot.hasData && this.listaPAs.isEmpty) {
              // Inicializ retorno do fetch em um vetor e nao se pesquisa mais no REST
              this.listaPAs.addAll(snapshot.data!.pas);
              // inicializa a lista filtrada com todos os PAs
              this.listaPAsFiltrada.addAll(this.listaPAs);
            }
            // se os dados existirem nos mapas entao entrar no if
            if (this.listaPAs.isNotEmpty) {
              return Column(
                children: [
                  Text(
                      'Ler um código de barras para consultar o mapa ${widget.mapa} no posto ${widget.posto}'),
                  CustomFieldCF(
                    isAutoFocus: true,
                    controller: controllerConsulta,
                    isTecladoAtivo: isTecladoAtivo,
                    foco: focoConsulta,
                    ativaDesativaTeclado: ativaDesativaTeclado,
                    tituloText: 'Ler qualquer CB',
                    botaoSubmitted: consultaSubmitted,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            consultaSubmitted();
                          },
                          child: const Text('Consultar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controllerConsulta.text = '';
                            focoConsulta.requestFocus();
                            this.listaPAsFiltrada.clear();
                            this.listaPAsFiltrada.addAll(this.listaPAs);
                          },
                          child: const Text('Limpar'),
                        ),
                      ]),
                  Text('Filtro: ${ultimoFiltro}'),
                  Expanded(
                    child: this.listaPAsFiltrada.isEmpty
                        ? Text('Não encontraou NADA do filtro.')
                        : ListView.builder(
                            itemCount: this.listaPAsFiltrada.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CustomListTileSemImagem(
                                titulo:
                                    'Posto ${listaPAsFiltrada[index].cdPt} - Mapa ${listaPAsFiltrada[index].cdMapa}',
                                subTitulo:
                                    'Posição ${listaPAsFiltrada[index].cdPa} - Materia-prima ${listaPAsFiltrada[index].cdProduto}',
                                onCustomPressed: () {},
                                hasTrailing: false,
                              );
                            }),
                  ),
                ],
              );
            }

            // Se tem erro no retorno
            if (snapshot.hasError) {
              return ErrorPage(
                title: 'Ocorreu um problema:\n' +
                    Funcoes.formataJsonErro(snapshot.error.toString()),
                isMostrarAppBar: false,
              );
            }

            return Container(
              color: Color(0xFFF3F7FA),
              child: Center(child: const CircularProgressIndicator()),
            );
          }),
    );
  }

  // metodo que ativa ou desativa o teclado conforme selecao na GUI pelo usuario
  void ativaDesativaTeclado(FocusNode foco) {
    setState(() {
      foco.unfocus(); // tiro o foco para forcar o usuario a dar um tap no campo e o teclado aparecer. O ideal depois eh automatizar isso
      isTecladoAtivo = !isTecladoAtivo;
    });
  }

  // metodo executado quando a consulta tiver que ser executada
  // n o caso deve haver um filtro das informações dos mapas atualmente em memoria
  void consultaSubmitted() {
    if (controllerConsulta.text.isNotEmpty) {
      this.ultimoFiltro = controllerConsulta.text;
      this.listaPAsFiltrada.clear();
      for (RealimentacaoDTO dto in this.listaPAs) {
        if (isMatch(dto, controllerConsulta.text)) {
          this.listaPAsFiltrada.add(dto);
        }
      }
      setState(() {});
      controllerConsulta.text = '';
      focoConsulta.requestFocus();

      // Beep e vibracao indicando sucesso
      SomVibracao.beepSucesso();
    }
  }

  Future<MapaAlimentacaoDTO> fetchMapasAlimentacao(
      String cdmapa, String cdposto) {
    MapaAlimentacaoRest rn = MapaAlimentacaoRest();
    return rn.fetchMapaAlimentacaoDTO(cdposto, cdmapa);
  }

  bool isMatch(RealimentacaoDTO dto, String text) {
    bool retorno = false;

    // se for um produto valido, entao retornar true
    if (dto.cdProduto.contains(text) || text.contains(dto.cdProduto)) {
      print('1.match ${dto.cdProduto} com $text}');
      retorno = true;
    }

// trecho comentado pelo matheus galdino. problema do CF era :
// Se não achar pelo cdProduto, busque pelo PA.
//  08/06/2023

//    if (dto.cdPa.contains(text) || text.contains(dto.cdPa)) {
//      print('2.match ${dto.cdPa} com $text}');
//      retorno = true;
//    }

    return retorno;
  }
}
