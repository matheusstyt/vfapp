import 'package:flutter/material.dart';
import 'package:vfapp/models/linhasRest.dart';
import 'package:vfapp/models/mapaCorrenteRest.dart';
import 'package:vfapp/models/realimentacaoRest.dart';
import 'package:vfapp/pages/mensagemDialog.dart';
import 'package:vfapp/pages/realimentacao/realimentarForm.dart';

import '../../main.dart';

class RealimentarPostoPage extends StatefulWidget {
  final MapaDTO mapadto;
  late String cdPa;
  late String reelId;
  late String cdProduto;
  late double quantidade;
  late bool isSucesso;
  late bool isSalvar;

  late bool isMostrarAppBar;

  RealimentarPostoPage({Key? key, required this.mapadto, this.cdProduto = '', this.cdPa = '', this.reelId = '', this.quantidade = 0, this.isSalvar = false, this.isSucesso = false, this.isMostrarAppBar = false}) : super(key: key);

  @override
  RealimentarPostoPageState createState() {
    return RealimentarPostoPageState(mapadto, cdPa, cdProduto, reelId, quantidade, isSalvar, isSucesso);
  }

}

class RealimentarPostoPageState extends State<RealimentarPostoPage> {
  final MapaDTO mapadto;
  late String cdpa;
  late String cdproduto;
  late String reelid;
  late double quantidade;
  late bool isSucessoRealimentar;
  late bool isSalvar;

  late Future<RealimentacaoDTO> futurePosicao;

  RealimentarPostoPageState(this.mapadto, this.cdpa, this.cdproduto, this.reelid, this.quantidade, this.isSalvar, this.isSucessoRealimentar);


  @override
  void initState() {
    super.initState();
    /* Pesquisar os mapas correntes da linha d*/
    futurePosicao = fetchRealimentacaoDTO(mapadto, cdpa, cdproduto, reelid, quantidade, isSalvar, isSucessoRealimentar);
  }

  void refreshRest() {
    setState(() {
      futurePosicao = fetchRealimentacaoDTO(mapadto, cdpa, cdproduto, reelid, quantidade, isSalvar, isSucessoRealimentar);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build realimentarPostoPage');
    return FutureBuilder<RealimentacaoDTO>(
        future: futurePosicao,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('hasData.true e a posicao recebida é ${snapshot.data!.cdPa}');
            return RealimentarForm(realimentarPostoPageState: this, mapadto: mapadto, realimentacaoDTO: snapshot.data!, isMostrarAppBar: widget.isMostrarAppBar,);
          }

          // Retorna a tela de circulo progress
          return Container(
            color: Color(0xFFF3F7FA),
            child: Center(child: const CircularProgressIndicator()),
          );

        },
    );
  }


  Future<RealimentacaoDTO> fetchRealimentacaoDTO(MapaDTO mapadto, String cdpa, String cdproduto, String reelid, double quantidade, bool isSalvar, bool isSucesso) async {
    RealimentacaoRest rn = new RealimentacaoRest();

    // Existem 2 situacoes para obtencao dos dados para realimentacao. A 1a nao foi escolhida nenhuma previsao realimentacao
    // a 2a foi escolhida uma previsao
    VfApp.configuracao.configuracao.postoSelecionado = PostoDTO(cdPosto: mapadto.cdpt);

    if (cdpa.isNotEmpty && reelid.isEmpty && isSalvar == false) {
      return rn.fetchRealimentacaoDTO(mapadto.cdpt, mapadto.cdmapa, cdpa);
    } else if (isSalvar) {
      rn.setRealimentacaoDTO(mapadto.cdpt, mapadto.cdmapa, cdpa, cdproduto, reelid, quantidade, isSucesso, VfApp.login.matricula);
      cdpa = '';
      cdproduto = '';
      reelid = '';
      quantidade = 0;

      this.cdpa = '';
      this.cdproduto = '';
      this.reelid = '';
      this.quantidade = 0;
      this.isSalvar = false;

      if (isSucesso) {
        MensagemDialog.showMensagem(context, 'Realimentação SUCESSO', 'Realimentação registrada');
      }
    }

    RealimentacaoDTO retorno = RealimentacaoDTO(
        cdPt: mapadto.cdpt, cdMapa: mapadto.cdmapa, cdPa: cdpa, cdProduto: cdproduto);

    retorno.reelId = reelid;
    retorno.qtAlimentada = quantidade;

    return await retorno;
  }

}