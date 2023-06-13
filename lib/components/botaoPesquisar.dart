// classe para desenhar o botao Pesquisar
import 'package:flutter/material.dart';
import 'package:vfapp/components/controllerPesquisa.dart';

class BotaoPesquisar extends StatelessWidget {
  const BotaoPesquisar({
    Key? key,
    required this.controllerPesquisa,
  }) : super(key: key);

  final ControllerPesquisa controllerPesquisa;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (controllerPesquisa.filterVisible) {
            controllerPesquisa.filterVisible = false;
            controllerPesquisa.heightAppBar = 50;
            controllerPesquisa.controller.text = '';
            controllerPesquisa.tabController.filtro = '';
            controllerPesquisa.refresh();
        } else {
            controllerPesquisa.animController.forward(from: 0.0);
            controllerPesquisa.filterVisible = true;
            controllerPesquisa.heightAppBar = 100;
            controllerPesquisa.refresh();
        }
      },
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      constraints: BoxConstraints(),
      icon: controllerPesquisa.filterVisible
          ? Icon(Icons.arrow_circle_up_outlined)
          : Icon(Icons.search),
    );
  }
}
