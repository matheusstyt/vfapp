import 'package:flutter/material.dart';
import 'package:vfapp/pages/mensagemDialog.dart';
import 'package:vfapp/pages/configuracaoPage.dart';
import 'package:vfapp/pages/escolherLinhaPage.dart';
import 'package:vfapp/pages/versaoAppPage.dart';

class MenuFlutuanteDoMenuPrincipal extends StatelessWidget {
  const MenuFlutuanteDoMenuPrincipal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: Colors.indigo,
      onSelected: (item) => onSelected(context, item),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Text('Escolher Linha'),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text('Configurações'),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Text('Log de versões'),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text('Logout'),
        ),
      ],
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EscolherLinhaPage()),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ConfiguracaoPage()),
        );
        break;
      case 2:

        Widget continueButton = TextButton(
          child: Text("Sim"),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
        MensagemDialog.showSimOuNao(
            context: context,
            titulo: 'VF Logout',
            mensagem: 'Deseja executar o logout?',
            continueButton: continueButton);
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => VersaoAppPage()),
        );

        break;
    }
  }
}
