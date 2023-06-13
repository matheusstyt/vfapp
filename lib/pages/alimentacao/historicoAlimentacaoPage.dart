import 'package:flutter/material.dart';
import 'package:vfapp/components/customHistAlimentacaoItem.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/models/historicoRest.dart';
import 'package:vfapp/pages/errorPage.dart';

class HistoricoAlimentacaoPage extends StatefulWidget {
  final String cdpt;
  final String cdpa;

  const HistoricoAlimentacaoPage({
    Key? key,
    required this.cdpa,
    required this.cdpt,
  }) : super(key: key);

  @override
  _HistoricoAlimentacaoPageState createState() =>
      _HistoricoAlimentacaoPageState();
}

class _HistoricoAlimentacaoPageState extends State<HistoricoAlimentacaoPage> {
  late Future<MonitorizacoesAlimsDTO> futureMonitorizacoes;
  late MonitorizacoesAlimsDTO monitorizacoesdto;

  @override
  void initState() {
    super.initState();
    futureMonitorizacoes = fetchHistorico(widget.cdpt, widget.cdpa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('VF Histórico'),
      ),
      body: FutureBuilder<MonitorizacoesAlimsDTO>(
        future: futureMonitorizacoes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            this.monitorizacoesdto = snapshot.data!;

            /*this.monitorizacoesdto.monitorizacoes.add(MonitorizacaoAlimDTO(
                  cdPt: 'cdPt',
                  cdPa: 'cdPa',
                  cdProduto: 'cdProduto',
                  cdMapa: 'cdMapa',
                  qtAlimentada: 0,
                  qtUsada: 0,
                  qtPorPlaca: 0,
                  qtAtual: 0,
                  cicloPadrao: 0,
                  previsaoTermino: 0,
                  qtProdutoRestante: 0,
                  qtCicloRestante: 0,
                  tipoAlimentacao: 0,
                  isSucesso: true,
                  dthrLeitura: 'dthrLeitura',
                  alimentador: 'alimentador'));*/

            print("linha 63 historicoAlimentacao ${monitorizacoesdto.cdPt}");
            return Container(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: monitorizacoesdto.monitorizacoes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(0),
                    child: CustomHistAlimentacaoItem(
                        monAlimentacaoDTO:
                            monitorizacoesdto.monitorizacoes[index]),
                  );
                },
              ),
            );
          }
          if (snapshot.hasError) {
            // Chamar tela de erro
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
        },
      ),
    );
  }

  Future<MonitorizacoesAlimsDTO> fetchHistorico(String cdpt, String cdpa) {
    HistoricoRest rn = new HistoricoRest();
    return rn.fetchMonitorizacoesAlimsDTO(cdpt, cdpa);
  }
}
