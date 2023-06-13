import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vfapp/components/customListTileSemImagem.dart';
import 'package:vfapp/components/customListTileSemImagemDoisBotoes.dart';
import 'package:vfapp/pages/alimentacao/autorizarAlimentacaoPage.dart';

class PasRestantesPage extends StatelessWidget {
  final String cdpt;
  final String cdmapa;
  final List<String> pasRestantes;
  final TextEditingController controlerPosicao;
  final TextEditingController controlerIdEmbalagem;
  final TextEditingController controlerQuantidade;
  final Function refresh;
  final ScrollController scrollController;
  final FocusNode focoIdEmbalagem;
  final Function autorizarAlimentacao;

  const PasRestantesPage(
      {required this.pasRestantes,
        required this.controlerPosicao,
        required this.refresh,
        required this.scrollController,
        required this.controlerIdEmbalagem,
        required this.controlerQuantidade,
        required this.focoIdEmbalagem,
        required this.cdpt,
        required this.cdmapa,
        required this.autorizarAlimentacao});

  @override
  Widget build(BuildContext context) {
    Widget retorno = ListView.builder(
      primary: false,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: pasRestantes.length,
      itemBuilder: (BuildContext context, int index) {
        return CustomListTileSemImagemDoisBotoes(
          titulo: pasRestantes[index],
          subTitulo: '',
          cor: Colors.red,
          mostrarBotaoInicial: true,
          textoBotaoInicial: 'MANUALMENTE',
          onBotaoInicialPressed: () {
            // Solicitar a leitura do cracha para autorizar a alimentacao manual
            Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => AutorizarAlimentacaoPage(
                        cdpa: pasRestantes[index],
                        cdpt: this.cdpt,
                        cdmapa: this.cdmapa,
                        autorizarAlimentacao: autorizarAlimentacao,
                      )),
                );

          },
          onCustomPressed: () {
            selecionarPa(index);
          },
        );
      },
    );

    return retorno;
  }

  // Metodo para selecionar o PA index
  void selecionarPa(int index) {
    controlerPosicao.text = '${pasRestantes[index]}';

    // Limpa o ID e quantidade
    controlerQuantidade.text = '';
    controlerIdEmbalagem.text = '';

    focoIdEmbalagem.requestFocus();

    // apos iniciar o valor de posicao, preciso que ela sofra um ENTER
    // basta chamar o refresh
    refresh();

    // Sobe a tela
    Future.delayed(const Duration(milliseconds: 300));
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn);
    });
  }
}
