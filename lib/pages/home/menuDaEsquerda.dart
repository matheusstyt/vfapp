import 'package:flutter/material.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/pages/versaoAppPage.dart';

class MenuDaEsquerda extends StatelessWidget {
  const MenuDaEsquerda({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        'linhaSelecionada ${VfApp.configuracao.configuracao.linhaSelecionada.toString()}');
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          Container(
            height: 250,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(children: [
                Text('Operador: ${VfApp.login.apelido}'),
                Text(
                    'Linha: ${VfApp.configuracao.configuracao.linhaSelecionada.cdLinha}'),
                Text('Postos: ${VfApp.configuracao.configuracao.linhaSelecionada}'),
                Text('Versão do App ${VersaoAppPage.versao}'),
              ]),
            ),
          ),
          ListTile(
            title: const Text('Ferramentas'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Matéria-prima'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Ordens serviço'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('IHM'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: const Text('Sair'),
            onTap: () {},
          ),
        ]));
  }
}
