import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/models/alimentacaoRest.dart';
import 'package:vfapp/models/validadeProdutoRest.dart';
import 'package:vfapp/pages/errorPage.dart';

class ConsultarValidadeProdutoPage extends StatefulWidget {
  final String cdProduto;
  final String cDtHr;

  const ConsultarValidadeProdutoPage(
      {Key? key, required this.cdProduto, required this.cDtHr})
      : super(key: key);

  @override
  ConsultarValidadeProdutoPageState createState() {
    return ConsultarValidadeProdutoPageState();
  }
}

class ConsultarValidadeProdutoPageState
    extends State<ConsultarValidadeProdutoPage> {
  late Future<ValidadeProdutoDTO> futureValidade;

  @override
  void initState() {
    super.initState();
    futureValidade = fetchValidadeProduto(widget.cdProduto, widget.cDtHr);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ValidadeProdutoDTO>(
        future: futureValidade,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final ValidadeProdutoDTO validade = snapshot.data!;

              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                      'Validade: ${getDataFormatada(validade.dataValidade)}'),
                ),
                body: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Column(children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Nova consulta'),
                        ),
                      ]),
                    )),
              );
            }
          }

          // Se tem erro no retorno
          if (snapshot.hasError) {
            return ErrorPage(
                title: 'Ocorreu um problema:\n' +
                    Funcoes.formataJsonErro(snapshot.error.toString()));
          }

          return Container(
            color: Color(0xFFF3F7FA),
            child: Center(child: const CircularProgressIndicator()),
          );
        });
  }

  String getDataFormatada(String dtHrYYYYMMDDHHMMSS) {
    String retorno = "";

    final y = dtHrYYYYMMDDHHMMSS.substring(0, 4);
    final m = dtHrYYYYMMDDHHMMSS.substring(4, 6);
    final d = dtHrYYYYMMDDHHMMSS.substring(6, 8);

    final h = dtHrYYYYMMDDHHMMSS.substring(8, 10);
    final mi = dtHrYYYYMMDDHHMMSS.substring(10, 12);
    final s = dtHrYYYYMMDDHHMMSS.substring(12, 14);

    retorno = "$y-$m-$d $h:$mi:$s";

    return retorno;
  }

  Future<ValidadeProdutoDTO> fetchValidadeProduto(
      String cdProduto, String cDtHr) {
    // formatar cData e cHora
    DateTime dthr = DateTime.parse(cDtHr);

    final y = dthr.year.toString().padLeft(4, '0');
    final m = dthr.month.toString().padLeft(2, '0');
    final d = dthr.day.toString().padLeft(2, '0');

    final h = dthr.hour.toString().padLeft(2, '0');
    final mi = dthr.minute.toString().padLeft(2, '0');
    final s = dthr.second.toString().padLeft(2, '0');

    String cData = "$y$m$d";
    String cHora = "$h:$mi:$s";

    ValidadeProdutoRest rn = ValidadeProdutoRest();
    return rn.fetchValidadeDTO(cdProduto, cData, cHora);
  }
}
