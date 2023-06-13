import 'package:flutter/services.dart';
import 'package:vfapp/functions/iLeitorCB.dart';
import 'dart:convert';

import 'package:vfapp/main.dart';


class LeitorCBZebra extends ILeitorCB{
  // As constantes abaixo sao usadas para controlar o scanner ZEBRA que é homologado para
  // essa aplicacao no momento. Caso outros scanners sejam homologados, sugiro a criação de um factory para
  // esse gerenciamento
  static const MethodChannel methodChannel = MethodChannel('br.com.map.vfapp/command');
  static const EventChannel scanChannel = EventChannel('br.com.map.vfapp/scan');

  @override
  void inicializaLeitorCB() {
    // As duas chamadas abaixo são usadas para configuração do scanner da ZEBRA
    // Caso outros scanners sejam homologados sugiro a criacao de um factory
    scanChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _createProfile("DataWedgeFlutterDemo");
  }

  // metodo para criacao de um profile para gerenciamento do leitor Zebra
  Future<void> _createProfile(String profileName) async {
    try {
      await methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
      print('erro na plataforma do leitor');
    }
  }

  // Metodo para envio de comando ao leitor zebra
  Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson =
      jsonEncode({"command": command, "parameter": parameter});

      await methodChannel.invokeMethod('sendDataWedgeCommandStringParameter', argumentAsJson);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  // Esse metodo é executado apos a leitura do CB
  // _controller deve antes ser alterado para indicar para qual campo a leitura sera atribuida
  void _onEvent(event) {
    // Alessandre. Comentei o trecho abaixo pois o setState estava fazendo um refresh em toda a hierarquia de state
    // no momento da leitura, fazendo com que a alimentacaodto fosse limpa
    // setState(() {

    Map barcodeScan = jsonDecode(event);
    print(barcodeScan['data']);
    VfApp.leitorFactory.controller.text = barcodeScan['data'];
    VfApp.leitorFactory.onSubmited();

    // _barcodeString = "Barcode: " + barcodeScan['scanData'];
    // _barcodeSymbology = "Symbology: " + barcodeScan['symbology'];
    // _scanTime = "At: " + barcodeScan['dateTime'];
    // });
  }

  // Esse metodo inicia o feixo de leitura do leitor de codigo de barras
  // em geral nao sera necessario pois o gatilho do leitor eh usado para isso
  /* Esse metodo nao eh usado. Ele serve para ligar o feixe de leitura do CB automaticamente
  void startScan() {
    setState(() {
      _sendDataWedgeCommand(
          "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "START_SCANNING");
    });
  }*/

  // Desativa o feixo de leitura de codigo de barras
  /* Metodo nao utilizado
  void stopScan() {
    setState(() {
      _sendDataWedgeCommand(
          "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER", "STOP_SCANNING");
    });
  }*/

  // Esse metodo é executado caso ocorra algum erro na leitura do CB
  void _onError(Object error) {
    /* Sem funcao no momento
    setState(() {
      //_barcodeString = "Barcode: error";
      // _barcodeSymbology = "Symbology: error";
      // _scanTime = "At: error";
    }); */
  }

}