import 'package:flutter/material.dart';

class ContagemRealimentacaoController extends ChangeNotifier {
  int contagem = 0;
  String posicao = '';
  String materiaPrima = '';
  double qtdMateriaPrima = 0;
  String cblido = '';
  bool visibilidade = false;
  bool isSucesso = false;

  void aumentaContagem() {
    contagem++;
    notifyListeners();
  }

  void zeraContagem() {
    contagem = 0;
    posicao = '';
    materiaPrima = '';
    qtdMateriaPrima = 0;
    cblido = '';
    if (visibilidade) {
      visibilidade = false;
    }
    notifyListeners();
  }

  void atualizaContagem(String posicao, String materiaPrima,
      String qtdMateriaPrima, bool isSucesso, String cblido) {
    //this.shouldStartAnimation = true;
    contagem++;
    this.posicao = posicao;
    this.materiaPrima = materiaPrima;
    try {
      this.qtdMateriaPrima = double.parse(qtdMateriaPrima);
    } on Exception catch(_) {
      this.qtdMateriaPrima = 0;
    }
    this.cblido = cblido;
    this.isSucesso = isSucesso;
    if (!visibilidade) {
      visibilidade = true;
    }
    notifyListeners();
  }
}
