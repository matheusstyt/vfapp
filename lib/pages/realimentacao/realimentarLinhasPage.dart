import 'package:flutter/material.dart';
import 'package:vfapp/models/mapaCorrenteRest.dart';
import 'package:vfapp/pages/errorPage.dart';
import 'package:vfapp/pages/realimentacao/mensagemSemPostos.dart';
import 'package:vfapp/pages/realimentacao/montagemTabRealimentacaoPage.dart';
import 'package:vfapp/pages/realimentacao/realimentarPostoPage.dart';

class RealimentarLinhasPage extends StatelessWidget {
  final MapasDTO mapasdto;

  const RealimentarLinhasPage({Key? key, required this.mapasdto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return mapasdto.mapas.isEmpty
        ? MensagemSemPostos()
        : MontagemTabRealimentacaoPage(mapasdto: mapasdto);
  }
}

