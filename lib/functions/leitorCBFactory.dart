
import 'package:flutter/material.dart';
import 'package:vfapp/functions/iLeitorCB.dart';
import 'package:vfapp/functions/leitorCBTiger.dart';
import 'package:vfapp/functions/leitorCBZebra.dart';

class LeitorCBFactory {
  // Abaixo referencia para o controler e submit dos campos text
  late TextEditingController controller;
  late Function onSubmited;


  // Abaixo lista das classes gerenciadoras dos leitores de CB Homologados
  List<ILeitorCB> leitores = [
    LeitorCBZebra(),
    LeitorCBTiger()
  ];

  /* Metodo para inicializar todos os tipos de coletores. No momento ainda não tenho como identificar
  qual o hardware que está rodando o app. Assim, todos estão sendo inicializados. Um deve funcionar.
   */
  void inicializaLeitoresCB() {
    for (ILeitorCB ileitorcb in this.leitores) {
      ileitorcb.inicializaLeitorCB();
    }
  }

  /* Metodo para configurar onde a leitura do CB jogará os valores lidos
   */
  void configurarLeituraCB({required TextEditingController controller, required Function onSubmited}) {
    this.controller = controller;
    this.onSubmited = onSubmited;
  }
}