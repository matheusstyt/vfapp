import 'package:flutter/material.dart';
import 'package:vfapp/components/customListTile.dart';
import 'package:vfapp/pages/ihmop/trocarOpPage.dart';

class MenuIHMPage extends StatefulWidget {
  @override
  MenuIHMState createState() {
    return MenuIHMState();
  }
}

class MenuIHMState extends State<MenuIHMPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('VF IHM'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                MenuVerticalIHM(),
              ],
            )));
  }
}

class MenuVerticalIHM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: CustomListTile(
            titulo: 'Troca OP',
            subTitulo: 'Permiter trocar a OP para a linha de produção',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (context) => TrocarOpPage()),
              // );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: CustomListTile(
            titulo: 'Corrigir paradas',
            subTitulo: 'Corrigir última parada ou anteriores',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (context) => TrocaOPPage()),
              // );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: CustomListTile(
            titulo: 'Login/Logout operadores',
            subTitulo: 'Permiter realizar o login ou logout do operador na linha',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (context) => TrocaOPPage()),
              // );
            },
          ),
        ),
      ],
    );
  }
}
