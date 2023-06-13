import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/models/alimentacaoRest.dart';
import 'package:vfapp/pages/mensagemDialog.dart';
import 'package:vfapp/pages/errorPage.dart';

class AlimentacaoConcluidaPage extends StatefulWidget {
  final AlimentacaoDTO alimentacaodto;

  const AlimentacaoConcluidaPage({Key? key, required this.alimentacaodto})
      : super(key: key);

  @override
  AlimentacaoConcluidaPageState createState() {
    return AlimentacaoConcluidaPageState();
  }
}

class AlimentacaoConcluidaPageState extends State<AlimentacaoConcluidaPage> {
  late Future<AlimentacaoDTO> futureAlimentacao;

  @override
  void initState() {
    super.initState();
    futureAlimentacao = setAlimentacao(widget.alimentacaodto);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AlimentacaoDTO>(
        future: futureAlimentacao,
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
                  title: Text('Alimentação SUCESSO'),
                ),
                body: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(children: [
                      Text('Alimentação concluída com sucesso.'),
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

  Future<AlimentacaoDTO> setAlimentacao(AlimentacaoDTO alimentacaodto) {
    AlimentacaoRest rn = new AlimentacaoRest();
    Future<AlimentacaoDTO> resposta = rn.setAlimentacaoDTO(alimentacaodto);
    return resposta;
  }
}
