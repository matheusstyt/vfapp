import 'package:flutter/material.dart';
import 'package:vfapp/components/areaPesquisa.dart';
import 'package:vfapp/components/botaoPesquisar.dart';
import 'package:vfapp/components/controllerPesquisa.dart';

class TituloBarPesquisa extends StatelessWidget {
  const TituloBarPesquisa({
    Key? key,
    required this.controllerPesquisa,
    required this.titulo,
  }) : super(key: key);

  final ControllerPesquisa controllerPesquisa;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: controllerPesquisa.heightAppBar,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                      constraints: BoxConstraints(),
                    ),
                    Text(titulo),
                  ],
                ),
                BotaoPesquisar(controllerPesquisa: controllerPesquisa,),
              ],
            ),
          ),
          AreaPesquisa(controllerPesquisa: controllerPesquisa, ),
        ],
      ),
    );
  }
}
