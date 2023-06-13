import 'package:flutter/material.dart';

// Classe usada para identificar a necessidade de atualizar a tela de alimentacao
// pois o filtro foi modificado
class TabAlimentacaoController extends ChangeNotifier {
  String filtro = '';

  void atualizaFiltro(String filtro) {
    this.filtro = filtro;
    notifyListeners();
  }
}
