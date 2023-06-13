import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/models/alimentacaoRest.dart';
import 'package:vfapp/pages/mensagemDialog.dart';
import 'package:vfapp/pages/errorPage.dart';

class ConferenciaConcluidaPage extends StatefulWidget {
  final AlimentacaoDTO alimentacaodto;

  const ConferenciaConcluidaPage({Key? key, required this.alimentacaodto})
      : super(key: key);

  @override
  ConferenciaConcluidaPageState createState() {
    return ConferenciaConcluidaPageState();
  }
}

class ConferenciaConcluidaPageState extends State<ConferenciaConcluidaPage> {
  late Future<AlimentacaoDTO> futureConferencia;

  @override
  void initState() {
    super.initState();
    futureConferencia = setConferencia(widget.alimentacaodto);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AlimentacaoDTO>(
        future: futureConferencia,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              /* Como a alimentacao foi salva com sucesso, então apagar a alimentacao em
              memoria
               */
              excluirAlimentacaoMemoria();

              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('Conferência SUCESSO'),
                ),
                body: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(children: [
                      Text('Conferência concluída com sucesso.'),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('OK'))
                    ])),
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

  Future<void> excluirAlimentacaoMemoria() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('alimentacao');
    prefs.remove('mapa');
  }

  Future<AlimentacaoDTO> setConferencia(AlimentacaoDTO alimentacaodto) {
    AlimentacaoRest rn = new AlimentacaoRest();
    Future<AlimentacaoDTO> resposta = rn.setConferenciaDTO(alimentacaodto);
    return resposta;
  }
}
