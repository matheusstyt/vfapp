import 'package:flutter/material.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/linhasRest.dart';
import 'package:vfapp/pages/alimentacao/alimentacaoEscolherMapaPage.dart';
import 'package:vfapp/pages/alimentacao/tabAlimentacaoCorrentePage.dart';
import 'package:vfapp/pages/consultar/tabConsultarAlimentacaoPage.dart';

/* Classe para apresentaco da alimentacao corrente de cada maquin
aqui construir a tela da alimentacao. Com + para comecar uma nova.
      mostrar a corrente, ao selecionar apresentar o historico.
      order por PA
  permitir chavear entre maquinas.
  Ao escolher alimentacao apresentar o historico das realimentacoes
 */
class ConsultarAlimentacaoPage extends StatefulWidget {
  final String mapa;

  const ConsultarAlimentacaoPage({
    Key? key,
    required this.mapa,
  }) : super(key: key);

  @override
  ConsultarAlimentacaoState createState() {
    return ConsultarAlimentacaoState();
  }
}

class ConsultarAlimentacaoState extends State<ConsultarAlimentacaoPage>
    with TickerProviderStateMixin {
  late List<Widget> tabsTitulos = [];
  late List<TabConsultarAlimentacaoPage> tabsConteudo = [];
  late int indiceTabInicial = 0;

  //Componentes da barra de pesquisa
  final TextEditingController _controller = new TextEditingController();
  bool filterVisible = false;
  double heightAppBar = 50;
  var focusnode = FocusNode();
  late tabConsultaController tabController = tabConsultaController();

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  late AnimationController _animController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late Animation<double> _animation = CurvedAnimation(
    parent: _animController,
    curve: Curves.fastOutSlowIn,
  );

  late Icon fabIcon = Icon(Icons.add);

  @override
  void initState() {
    super.initState();

    for (PostoDTO posto
        in VfApp.configuracao.configuracao.linhaSelecionada.postos) {
      // Inicializa titulo do tab
      tabsTitulos.add(Container(
          padding: EdgeInsets.all(8.0), child: Text('${posto.cdPosto}')));
      // Inicializa conteudo do tab
      tabsConteudo.add(TabConsultarAlimentacaoPage(
        cdposto: posto.cdPosto,
        mapa: widget.mapa,
        tcController: tabController,
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
          toolbarHeight: heightAppBar,
          title: Container(
            height: heightAppBar,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                            constraints: BoxConstraints(),
                          ),
                          Text('VF Consulta'),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          //
                          if (filterVisible) {
                            setState(() {
                              filterVisible = false;
                              heightAppBar = 50;
                              setState(() {
                                _controller.text = '';
                                tabController.atualizaFiltro(_controller.text);
                              });
                            });
                          } else {
                            setState(() {
                              _animController.forward(from: 0.0);
                              filterVisible = true;
                              heightAppBar = 100;
                            });
                          }
                        },
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: filterVisible,
                  child: SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    axisAlignment: -1,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: new TextStyle(
                              color: Colors.white,
                            ),
                            focusNode: focusnode,
                            onChanged: (value) {
                              tabController.atualizaFiltro(value);
                            },
                            onSubmitted: (value) {
                              setState(() {
                                tabController.atualizaFiltro(_controller.text);
                              });
                            },
                            decoration: new InputDecoration(
                                prefixIcon: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      tabController
                                          .atualizaFiltro(_controller.text);
                                    });
                                  },
                                  child: new Icon(Icons.search,
                                      color: Colors.white),
                                ),
                                hintText: "Filtrar...",
                                suffixIcon: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _controller.text = '';
                                      tabController
                                          .atualizaFiltro(_controller.text);
                                    });
                                  },
                                  child: Icon(Icons.cancel),
                                ),
                                hintStyle: new TextStyle(color: Colors.white)),
                            //onChanged: searchOperation,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
        body: TabBarView(
          children: tabsConteudo,
        ),
      ),
    );
  }
}
