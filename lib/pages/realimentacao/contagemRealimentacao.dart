import 'package:flutter/material.dart';
import 'package:vfapp/pages/realimentacao/contagemRealimentacaoController.dart';

class ContagemRealimentacao extends StatefulWidget {
  int contagem = 0;
  String posicao = '';
  String materiaPrima = '';
  String cblido = '';
  double qtdMateriaPrima = 0;
  bool isSucesso = false;
  bool visibilidade = false;
  final ContagemRealimentacaoController controller;

  ContagemRealimentacao({Key? key, required this.controller}) : super(key: key);

  @override
  _ContagemRealimentacaoState createState() => _ContagemRealimentacaoState();
}

class _ContagemRealimentacaoState extends State<ContagemRealimentacao> {
  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        widget.contagem = widget.controller.contagem;
        widget.posicao = widget.controller.posicao;
        widget.materiaPrima = widget.controller.materiaPrima;
        widget.qtdMateriaPrima = widget.controller.qtdMateriaPrima;
        widget.cblido = widget.controller.cblido;
        widget.visibilidade = widget.controller.visibilidade;
        widget.isSucesso = widget.controller.isSucesso;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visibilidade,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Column(
          children: [
            Text(
                'Realimentação realizada com ${widget.isSucesso ? 'sucesso' : 'falha'}.'),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Contagem Realimentações'),
                Text('${widget.contagem}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ultima Posicao Alimentada'),
                Text('${widget.posicao}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Matéria Prima'),
                Text('${widget.materiaPrima}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantidade de Matéria Prima'),
                Text('${widget.qtdMateriaPrima}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Leitura'),
                Text('${widget.cblido}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
