import 'package:flutter/material.dart';
import 'package:vfapp/components/controllerPesquisa.dart';
import 'package:vfapp/main.dart';

class AreaPesquisa extends StatelessWidget {
  const AreaPesquisa({
    Key? key,
    required this.controllerPesquisa,
  }) : super(key: key);

  final ControllerPesquisa controllerPesquisa;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controllerPesquisa.filterVisible,
      child: SizeTransition(
        sizeFactor: controllerPesquisa.animation,
        axis: Axis.vertical,
        axisAlignment: -1,
        child: Row(
          children: [
            Expanded(
              child: Focus(
                onFocusChange: (focus) {
                  // Se ganhou foco
                  if (focus) {
                    VfApp.leitorFactory.configurarLeituraCB(onSubmited: pesquisarSubmitted, controller: controllerPesquisa.controller);
                  }
                },
                child: TextField(
                  cursorWidth: 12.0,
                  keyboardType: controllerPesquisa.isTecladoAtivo
                      ? TextInputType.text
                      : TextInputType.none,
                  controller: controllerPesquisa.controller,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  focusNode: controllerPesquisa.focusnode,
                  autofocus: true,
                  onChanged: (value) {
                    controllerPesquisa.tabController.filtro = value;
                  },
                  onSubmitted: (value) {
                    // aqui setState(() {
                    pesquisarSubmitted();
                    // });
                  },
                  decoration: new InputDecoration(
                      prefixIcon: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.transparent),
                          shadowColor: MaterialStateProperty.all(
                              Colors.transparent),
                        ),
                        onPressed: () {
                          controllerPesquisa.tabController.atualizaFiltro(controllerPesquisa.controller.text);
                          controllerPesquisa.refresh();
                        },
                        child: new Icon(Icons.search,
                            color: Colors.white),
                      ),
                      hintText: "Filtrar...",
                      suffixIcon: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          //
                          mainAxisSize: MainAxisSize.min,
                          // added line
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(
                                    Colors.transparent),
                                shadowColor:
                                MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () {
                                controllerPesquisa.controller.text = '';
                                controllerPesquisa.tabController.filtro = '';
                                controllerPesquisa.tabController.atualizaFiltro(controllerPesquisa.controller.text);
                                controllerPesquisa.refresh();
                              },
                              child: Icon(Icons.cancel),
                            ),
                            IconButton(
                              onPressed: () {
                                controllerPesquisa.ativaDesativaTeclado(controllerPesquisa.focusnode);
                              },
                              icon: controllerPesquisa.isTecladoAtivo
                                  ? Icon(Icons.arrow_back)
                                  : Icon(Icons.keyboard),
                            ),
                          ]),
                      hintStyle: new TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pesquisarSubmitted() {
    controllerPesquisa.tabController.atualizaFiltro(controllerPesquisa.controller.text);
    controllerPesquisa.refresh();
  }
}
