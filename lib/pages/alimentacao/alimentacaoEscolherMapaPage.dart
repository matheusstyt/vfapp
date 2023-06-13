import 'package:flutter/material.dart';
import 'package:vfapp/components/customListTileSemImagem.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/mapaAlimentacaoRest.dart';
import 'package:vfapp/pages/alimentacao/alimentacaoPage.dart';
import 'package:vfapp/pages/errorPage.dart';

class AlimentacaoEscolherMapaPage extends StatefulWidget {
  @override
  AlimentacaoEscolherMapaState createState() {
    return AlimentacaoEscolherMapaState();
  }
}

class AlimentacaoEscolherMapaState extends State<AlimentacaoEscolherMapaPage>
    with TickerProviderStateMixin {
  late MapasAlimentacaoDTO mapasAlimentacaoDTO =
      MapasAlimentacaoDTO(cdPt: '', mapas: []);
  late Future<MapasAlimentacaoDTO> futureMapasAlimentacao;
  late List<MapaAlimentacaoScore> mapasAlimentacao = [];

  //Componentes da barra de pesquisa
  final TextEditingController _controller = new TextEditingController();
  bool filterVisible = false;
  double heightAppBar = 50;

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

  @override
  void initState() {
    super.initState();
    futureMapasAlimentacao = fetchMapasAlimentacao(
        VfApp.configuracao.configuracao.postoSelecionado.cdPosto);

    if (!mapasAlimentacaoDTO.mapas.isEmpty) {
      mapasAlimentacao = analisaMapas(mapasAlimentacaoDTO.mapas,
          _controller.text, mapasAlimentacaoDTO.cdPt);
    }
    print(
        'escolhendo o mapa para o pt ${VfApp.configuracao.configuracao.postoSelecionado.cdPosto}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Text('VF Escolher Mapa'),
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
                              if (!mapasAlimentacaoDTO.mapas.isEmpty) {
                                mapasAlimentacao = analisaMapas(
                                    mapasAlimentacaoDTO.mapas,
                                    _controller.text,
                                    mapasAlimentacaoDTO.cdPt);
                              }
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
                          onChanged: (value) {
                            setState(() {
                              if (!mapasAlimentacaoDTO.mapas.isEmpty) {
                                mapasAlimentacao = analisaMapas(
                                    mapasAlimentacaoDTO.mapas,
                                    _controller.text,
                                    mapasAlimentacaoDTO.cdPt);
                              }
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
                                  //
                                  setState(() {});
                                },
                                child:
                                    new Icon(Icons.search, color: Colors.white),
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
                                    if (!mapasAlimentacaoDTO.mapas.isEmpty) {
                                      mapasAlimentacao = analisaMapas(
                                          mapasAlimentacaoDTO.mapas,
                                          _controller.text,
                                          mapasAlimentacaoDTO.cdPt);
                                    }
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
      ),
      body: FutureBuilder<MapasAlimentacaoDTO>(
          future: futureMapasAlimentacao,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                mapasAlimentacaoDTO = snapshot.data!;
                if (!mapasAlimentacaoDTO.mapas.isEmpty) {
                  mapasAlimentacao = analisaMapas(mapasAlimentacaoDTO.mapas,
                      _controller.text, mapasAlimentacaoDTO.cdPt);
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: mapasAlimentacao.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        CustomListTileSemImagem(
                          // cor: mapasAlimentacao[index]
                          //         .mapaalimentacao
                          //         .isMapaCarregadoEmMaquina
                          //     ? Colors.green
                          //     : Colors.black,
                          titulo:
                              'Mapa ${mapasAlimentacao[index].mapaalimentacao.cdMapa}',
                          subTitulo: 'para o posto ${snapshot.data!.cdPt}',
                          onCustomPressed: () {
                            // Chamar a tela de ALIMENTACAO
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => AlimentacaoPage(
                                        cdpt: snapshot.data!.cdPt,
                                        cdmapa: mapasAlimentacao[index]
                                            .mapaalimentacao
                                            .cdMapa)))
                                .then((value) {});
                          },
                        ),
                      ],
                    );
                  },
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
            }
            return Container(
              color: Color(0xFFF3F7FA),
              child: Center(child: const CircularProgressIndicator()),
            );
          }),
    );
  }

  bool verificaPesquisa(String query, String itemText) {
    List<String> values = [];
    values = query.split(" ");
    int cont = 0;
    for (var texto in values) {
      if (itemText.toLowerCase().contains(texto.toLowerCase())) {
        cont++;
      }
    }
    if (cont == values.length) {
      return true;
    } else {
      return false;
    }
  }

  List<MapaAlimentacaoScore> analisaMapas(
      List<MapaAlimentacaoDTO> mapasalimentacao, String query, String posto) {
    List<MapaAlimentacaoScore> mapascore = [];

    for (MapaAlimentacaoDTO mapaalimentacao in mapasalimentacao) {
      List<String> values = [];
      List<String> values2 = [];
      String textoMapa = mapaalimentacao.cdMapa + ' ' + posto;

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

  Future<MapasAlimentacaoDTO> fetchMapasAlimentacao(String cdposto) {
    MapaAlimentacaoRest rn = MapaAlimentacaoRest();
    return rn.fetchMapasAlimentacaoDTO(cdposto);
  }
}

class MapaAlimentacaoScore {
  MapaAlimentacaoDTO mapaalimentacao;
  int score;

  MapaAlimentacaoScore(this.mapaalimentacao, this.score);
}
