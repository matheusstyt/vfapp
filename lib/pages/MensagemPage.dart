import 'package:flutter/material.dart';

class MensagemPage extends StatelessWidget {
  final String titulo;
  final String mensagem;

  const MensagemPage({Key? key, required this.titulo, required this.mensagem}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.titulo),
      ),
      body: Text(this.mensagem),
    );
  }

}