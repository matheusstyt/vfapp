import 'package:flutter/material.dart';
import 'package:vfapp/components/customAppBar.dart';
import 'package:vfapp/components/customCircularProgress.dart';
import 'package:vfapp/components/customListTile.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/models/opRest.dart';
import 'package:vfapp/pages/errorPage.dart';

class TrocarOpPage extends StatefulWidget {
  @override
  TrocarOpState createState() {
    return TrocarOpState();
  }
}

/* A classe deve apresentar as ops carregadas atualmente na linha
e mostrar uma lista com as proximas OPs disponiveis para serem carregadas
 */
class TrocarOpState extends State<TrocarOpPage> {
  late Future<OpsDTO> futureOps;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<OpsDTO>(
        future: futureOps,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: CustomAppBar(titulo: 'VF - Trocar OP'),
              body: Column(
                children: [
                  Text('Linha ${snapshot.data!.cdLinha}'),
                  Text('OP Atual ${snapshot.data!.opdto.nrop}'),
                  ListView.builder(
                      itemCount: snapshot.data!.ops.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: CustomListTile(
                            titulo: snapshot.data!.ops[index].cdPosto,
                            subTitulo: snapshot.data!.ops[index].nrop,
                            imagemEsq: 'assets/images/selfieButton.png',
                            onCustomPressed: () {
                              // Executa a troca da OP escolhida

                              // Aguardar o evento ser processado

                              // Retorna a tela anterior
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }),
                ],
              ),
            );
          }

          // verifica se ocorreu algum erro
          if (snapshot.hasError) {
            return ErrorPage(
                title: 'Ocorreu um problema:\n' +
                    Funcoes.formataJsonErro(snapshot.error.toString()));
          }

          // Retorna progress bar para indicar que a pesquisa das ops está em execução
          return CustomCircularProgress();
        },
      ),
    );
  }
}
