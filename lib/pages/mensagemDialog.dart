import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MensagemDialog {
  static void showMensagem(
      BuildContext context, String titulo, String? mensagem) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem!),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showEmConstrucao(BuildContext context) {
    showMensagem(context, 'Opção em construção',
        'Essa funcionalidade será disponibilizada nas próximas versões.');
  }

  static void showPerdaConexao(BuildContext context) {
    showMensagem(context, 'Problema conexão', 'Sem conexão ao servidor ${VfApp.configuracao.configuracao.url}.');
  }

  static void showSimOuNao({
    required BuildContext context,
    required String titulo,
    required String mensagem,
    required Widget continueButton,
    Widget? naoButton
    }) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Não"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(
          mensagem),
      actions: [
        naoButton == null ? cancelButton : naoButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
