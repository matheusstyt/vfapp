import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/components/customListTile.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/pages/mensagemDialog.dart';
import 'package:vfapp/pages/alimentacao/alimentacaoCorrentePage.dart';
import 'package:vfapp/pages/alimentacao/restaurarAlimentacaoPage.dart';
import 'package:vfapp/pages/conferencia/escolherPostoPage.dart';
import 'package:vfapp/pages/consultar/consultarEscolherMapaPage.dart';
import 'package:vfapp/pages/consultar/consultarMapaAlimentadoPage.dart';
import 'package:vfapp/pages/consultar/consultarValidadeProdutoForm.dart';
import 'package:vfapp/pages/errorPage.dart';
import 'package:vfapp/pages/mensagemPage.dart';
import 'package:vfapp/pages/realimentacao/previsaoRealimentacaoPage.dart';
import 'package:vfapp/pages/realimentacao/realimentarPage.dart';

class MenuMateriaPrimaPage extends StatefulWidget {
  @override
  MenuMateriaPrimaState createState() {
    return MenuMateriaPrimaState();
  }
}

class MenuMateriaPrimaState extends State<MenuMateriaPrimaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VF Materia-prima'),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MenuVerticalMateriaPrima(),
            ],
          )),
    );
  }
}

class MenuVerticalMateriaPrima extends StatelessWidget {
  const MenuVerticalMateriaPrima({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: CustomListTile(
            titulo: 'Previsão Realimentação',
            subTitulo: 'Apresenta as próximas realimentações a serem feitas',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => PrevisaoRealimentacaoPage()),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          // width: MediaQuery.of(context).size.width - 22,
          //color: Colors.white,
          child: CustomListTile(
            titulo: 'Alimentação',
            subTitulo: 'Apresenta alimentação atual da linha',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              analisarAlimentacaoPendente(context);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          // width: MediaQuery.of(context).size.width - 22,
          //color: Colors.white,
          child: CustomListTile(
            titulo: 'Realimentação',
            subTitulo: 'Permite realimentar um ponto de alimentação',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RealimentarPage()),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          // width: MediaQuery.of(context).size.width - 22,
          //color: Colors.white,
          child: CustomListTile(
            titulo: 'Conferir',
            subTitulo:
                'Confere os pontos de alimentação de uma mapa de alimentação',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              // Chamar a escolha do posto que sera conferido
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EscolherPostoPage()),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          // width: MediaQuery.of(context).size.width - 22,
          //color: Colors.white,
          child: CustomListTile(
            titulo: 'Consultar materia-prima',
            subTitulo:
                'Permite encontrar onde uma materia-prima deve ser usada e vice-versa',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ConsultarEscolherMapaPage()),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          // width: MediaQuery.of(context).size.width - 22,
          //color: Colors.white,
          child: CustomListTile(
            titulo: 'Consultar validade dos produtos',
            subTitulo:
                'Apresenta a data de validade de um produto com base na data e hora de abertura da embalagem',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => VfApp.configuracao.configuracao.habilitarValidacaoERP ? ConsultarValidadeProdutoForm() : MensagemPage(titulo: 'Consulta desabilitada', mensagem: 'Habilitar essa consulta na configuração do app apenas se houver esse recurso no ERP',)),
              );
            },
          ),
        ),
      ],
    );
  }

  /* Metodo responsavel em analisar se existe alguma alimentacao pendente. Se existir directionar
  para tela adequada
   */
  Future<void> analisarAlimentacaoPendente(BuildContext context) async {
    // alessandre comentei o trecho abaixo pois nao tive tempo de preparar o restaurar alimentacao pendente
    // final prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey('alimentacao')) {
    //   Navigator.of(context).push(
    //       MaterialPageRoute(
    //           builder: (context) => RestaurarAlimentacaoPage()) );
    // } else {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AlimentacaoCorrentePage()));
    // }
  }
}
