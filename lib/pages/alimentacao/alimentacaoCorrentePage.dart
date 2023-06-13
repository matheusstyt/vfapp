import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vfapp/components/controllerPesquisa.dart';
import 'package:vfapp/components/tituloBarPesquisa.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/linhasRest.dart';
import 'package:vfapp/pages/alimentacao/alimentacaoEscolherMapaPage.dart';
import 'package:vfapp/pages/alimentacao/tabAlimentacaoCorrentePage.dart';

/* Classe para apresentaco da alimentacao corrente de cada maquin
aqui construir a tela da alimentacao. Com + para comecar uma nova.
      mostrar a corrente, ao selecionar apresentar o historico.
      order por PA
  permitir chavear entre maquinas.
  Ao escolher alimentacao apresentar o historico das realimentacoes
 */
class AlimentacaoCorrentePage extends StatefulWidget {
  @override
  AlimentacaoCorrenteState createState() {
    return AlimentacaoCorrenteState();
  }
}

class AlimentacaoCorrenteState extends State<AlimentacaoCorrentePage> with TickerProviderStateMixin {
  late List<Widget> tabsTitulos = [];
  late List<TabAlimentacaoCorrentePage> tabsConteudo = [];
  late int indiceTabInicial = 0;

  // Controller pesquisa armazena os atributos necessario para controlar o botão de pesquisa bem como os atributos da pesquisa
  late ControllerPesquisa controllerPesquisa;


  @override
  void initState() {
    super.initState();

    this.controllerPesquisa = ControllerPesquisa(
        refresh: refresh,
        ticker: this);

    for (PostoDTO posto
        in VfApp.configuracao.configuracao.linhaSelecionada.postos) {
      // Inicializa titulo do tab
      tabsTitulos.add(Container(
          padding: EdgeInsets.all(8.0), child: Text('${posto.cdPosto}')));
      // Inicializa conteudo do tab
      tabsConteudo.add(TabAlimentacaoCorrentePage(
        cdposto: posto.cdPosto,
        filtrarController: controllerPesquisa.tabController,
      ));

      // Encontra o indice do tab que será selecionado na entrada da interface
      if (posto.cdPosto ==
          VfApp.configuracao.configuracao.postoSelecionado.cdPosto) {
        indiceTabInicial = tabsConteudo.length - 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: this.tabsConteudo.length,
      initialIndex: this.indiceTabInicial,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: controllerPesquisa.heightAppBar,
          title: TituloBarPesquisa(controllerPesquisa: controllerPesquisa, titulo: 'VF Alimentação',),
          bottom: TabBar(
              isScrollable: true,
              onTap: (index) {
                // Atualiza a referencia do posto selecionado na configuracao
                VfApp.configuracao.configuracao.postoSelecionado =
                    PostoDTO(cdPosto: tabsConteudo[index].cdposto);
                VfApp.configuracao.salvarConfiguracao();
                print(
                    'posto selecionado ${VfApp.configuracao.configuracao.postoSelecionado.cdPosto}');
              },
              tabs: tabsTitulos),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Chamar a realimentacao em branco
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => AlimentacaoEscolherMapaPage()))
                .then((value) {});
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: TabBarView(
          children: tabsConteudo,
        ),
      ),
    );
  }

  void refresh() {
    setState(() {

    });
  }
}




