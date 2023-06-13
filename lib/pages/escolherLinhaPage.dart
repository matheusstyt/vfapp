import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vfapp/components/customListTile.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/linhasRest.dart';

import 'errorPage.dart';
import 'mensagemDialog.dart';

/* Classe para montagem da tela de escolha da linha que será trabalhada pelo coletor
A classe é stateful pois recebe dados do REST.
 */
class EscolherLinhaPage extends StatefulWidget {
  @override
  _EscolherLinhaPage createState() {
    return _EscolherLinhaPage();
  }
}

class _EscolherLinhaPage extends State<EscolherLinhaPage> {
  late Future<LinhasDTO> futureLinhas;
  late List<LinhaItem> linhasItem = [];

  @override
  void initState() {
    super.initState();
    futureLinhas = fetchLinhasDTO(VfApp.configuracao.configuracao.cdgtFase);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LinhasDTO>(
        future: futureLinhas,
        builder: (context, snapshot) {
          // Se chegou dados e ainda não inicializamos o buffer com o recebimento, entao receber dados
          print('retorno se tem data ${snapshot.hasData}');
          if (snapshot.hasData) {
            // Atualiza a lista das linhas em memoria
            for (LinhaDTO l in snapshot.data!.linhas) {
              LinhaItem linhaItem = new LinhaItem(linha: l);
              linhasItem.add(linhaItem);
            }

            return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Scaffold(
                    appBar: AppBar(
                      // Here we take the value from the MyHomePage object that was created by
                      // the App.build method, and use it to set our appbar title.
                      title: Text('VF Escolher Linha'),
                    ),
                    body: linhasItem.isEmpty
                        ? Text(
                            'Sem linhas para a fase ${VfApp.configuracao.configuracao.cdgtFase}')
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: linhasItem.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Abaixo formatar o item com a linha formatada para a tela
                              return Container(
                                padding: EdgeInsets.all(10),
                                child: CustomListTile(
                                  titulo: this.linhasItem[index].linha.cdLinha,
                                  subTitulo:
                                      this.linhasItem[index].linha.toString(),
                                  imagemEsq: 'assets/images/selfieButton.png',
                                  onCustomPressed: () {
                                    // Salva a linha escolhida na configuracao do sistema
                                    VfApp.configuracao.configuracao
                                            .linhaSelecionada =
                                        this.linhasItem[index].linha;
                                    VfApp.configuracao.configuracao
                                            .postoSelecionado =
                                        this.linhasItem[index].linha.postos[0];
                                    VfApp.configuracao.salvarConfiguracao();
                                    // Retorna a tela anterior
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            })));
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

// Metodo para acionar o recebimento futuro do REST com a lista das linhas de determinada fase do processo
  Future<LinhasDTO> fetchLinhasDTO(String cdgtFase) {
    LinhasRest rest = LinhasRest();
    return rest.fetchLinhasDTO(cdgtFase);
  }
}

/* Essa classe representa o item Linha na tela
 */
class LinhaItem {
  late bool isExpanded;
  late LinhaDTO linha;

  LinhaItem({this.isExpanded: false, required this.linha});
}
