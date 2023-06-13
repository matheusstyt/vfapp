import 'package:flutter/material.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/alimentacaoRest.dart';
import 'package:vfapp/models/mapaAlimentacaoRest.dart';
import 'package:vfapp/models/realimentacaoRest.dart';
import 'package:vfapp/pages/alimentacao/alimentacaoForm.dart';
import 'package:vfapp/pages/conferencia/conferenciaForm.dart';
import 'package:vfapp/pages/errorPage.dart';

class ConferenciaPage extends StatefulWidget {
  final String cdpt;
  final String cdmapa;

  late List<RealimentacaoDTO> alimentacoes = [];
  late AlimentacaoDTO alimentacaoDTO;

  ConferenciaPage({Key? key, required this.cdpt, required this.cdmapa})
      : super(key: key) {
    print('limpando a alimentacaodto');
    alimentacaoDTO = AlimentacaoDTO(alimentacoes, VfApp.login.matricula, cdpt,
        ''); // contem a alimentacao corrente com os PAs ja alimentados.

    alimentacaoDTO.isSucesso = true; // por enquanto eh true
  }

  @override
  ConferenciaPageState createState() {
    return ConferenciaPageState();
  }
}

class ConferenciaPageState extends State<ConferenciaPage> {
  late Future<MapaAlimentacaoDTO> futureMapaAlimentacao;

  @override
  void initState() {
    super.initState();
    futureMapaAlimentacao = fetchMapaAlimentacao(widget.cdpt, widget.cdmapa);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MapaAlimentacaoDTO>(
      future: futureMapaAlimentacao,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            // Chamar o formulario para alimentacao
            widget.alimentacaoDTO.cdMapa = snapshot.data!.cdMapa;

            /* Ordena a lista dos PAs na alimentacao */
            snapshot.data!.pas.sort((a, b) => a.ordem.compareTo(b.ordem));

            return ConferenciaForm(
              cdpt: widget.cdpt,
              mapaalimentacaodto: snapshot.data!,
              alimentacaoDTO: widget.alimentacaoDTO,
            );
          }

          // Se tem erro no retorno
          if (snapshot.hasError) {
            return ErrorPage(
                title: 'Ocorreu um problema:\n' +
                    Funcoes.formataJsonErro(snapshot.error.toString()));
          }
        }
        return Container(
          color: Color(0xFFF3F7FA),
          child: Center(child: const CircularProgressIndicator()),
        );
      },
    );
  }

  Future<MapaAlimentacaoDTO> fetchMapaAlimentacao(String cdpt, String cdmapa) {
    MapaAlimentacaoRest rn = new MapaAlimentacaoRest();
    return rn.fetchMapaAlimentacaoDTO(cdpt, cdmapa);
  }
}
