import 'package:flutter/material.dart';
import 'package:vfapp/pages/errorPage.dart';

class MensagemSemPostos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ErrorPage(
      title: 'Sem postos para a linha',
      isMostrarAppBar: true,
    );
  }
}

