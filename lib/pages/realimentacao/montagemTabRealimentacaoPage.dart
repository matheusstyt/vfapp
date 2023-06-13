
import 'package:flutter/material.dart';
import 'package:vfapp/models/mapaCorrenteRest.dart';
import 'package:vfapp/pages/realimentacao/realimentarPostoPage.dart';

class MontagemTabRealimentacaoPage extends StatelessWidget {
  const MontagemTabRealimentacaoPage({
    Key? key,
    required this.mapasdto,
  }) : super(key: key);

  final MapasDTO mapasdto;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: mapasdto.mapas.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Realimentar VF'),
          bottom: TabBar(
            isScrollable: true,
            tabs: obtemTitulosTabs(mapasdto),
            onTap: (index) {},
          ),
        ),
        body: TabBarView(
          children: obtemConteudoTabs(mapasdto),
        ),
      ),
    );
  }

  // Metodo deve retornar os Widgets para as tabs
  List<Text> obtemTitulosTabs(MapasDTO mapasdto) {
    List<Text> titulosTabs = [];

    for (MapaDTO mapadto in mapasdto.mapas) {
      titulosTabs.add(Text(mapadto.cdpt));
    }

    return titulosTabs;
  }

  // Metodo para retornar o conteudo do tab
  List<RealimentarPostoPage> obtemConteudoTabs(MapasDTO mapasdto) {
    List<RealimentarPostoPage> tabs = [];

    for (MapaDTO mapadto in mapasdto.mapas) {
      tabs.add(RealimentarPostoPage(mapadto: mapadto,));
    }

    return tabs;
  }
}



