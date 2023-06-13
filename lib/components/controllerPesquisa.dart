// Classe com todos os atributos necessarios para controlar a pesquisa
import 'package:flutter/material.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/pages/alimentacao/tabAlimentacaoController.dart';
import 'package:vfapp/pages/alimentacao/tabAlimentacaoCorrentePage.dart';

class ControllerPesquisa {
  //Componentes da barra de pesquisa
  final TextEditingController controller = new TextEditingController();
  bool filterVisible = false;
  double heightAppBar = 50;
  var focusnode = FocusNode();

  final TickerProviderStateMixin ticker;

  late AnimationController animController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: ticker,
  )..forward();
  late Animation<double> animation = CurvedAnimation(
    parent: animController,
    curve: Curves.fastOutSlowIn,
  );

  late TabAlimentacaoController tabController = TabAlimentacaoController();

  bool isTecladoAtivo = VfApp.configuracao.configuracao.tecladoHabilitado;

  final Function refresh;

  ControllerPesquisa({required this.ticker, required this.refresh});

  void ativaDesativaTeclado(FocusNode foco) {
      foco.unfocus(); // tiro o foco para forcar o usuario a dar um tap no campo e o teclado aparecer. O ideal depois eh automatizar isso
      isTecladoAtivo = !isTecladoAtivo;
      refresh();
  }

}
