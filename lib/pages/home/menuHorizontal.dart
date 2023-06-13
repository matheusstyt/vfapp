import 'package:flutter/material.dart';
import 'package:vfapp/components/customButtonMenu.dart';
import 'package:vfapp/pages/home/menuIHMPage.dart';
import 'package:vfapp/pages/home/menuMateriaPrimaPage.dart';

class MenuHorizontal extends StatelessWidget {
  const MenuHorizontal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 150,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        CustomButtomMenu(
          titulo: 'Ferramentas',
          subTitulo: 'Realiza a movimentação ferramentas',
          imagem: 'assets/images/ferramenta48x48.png',
          onCustomPressed: () {
            Navigator.of(context).pushNamed('/menuCNH');
          },
        ),
        CustomButtomMenu(
          titulo: 'Materias-prima',
          subTitulo: 'Realiza alimentação, realimentação, conferência',
          imagem: 'assets/images/ferramenta48x48.png',
          onCustomPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MenuMateriaPrimaPage()),
            );
          },
        ),
        CustomButtomMenu(
          titulo: 'Ordens de serviço',
          subTitulo: 'Serviços de limpezas, validação das ferramentas',
          imagem: 'assets/images/ferramenta48x48.png',
          onCustomPressed: () {
            Navigator.of(context).pushNamed('/menuCNH');
          },
        ),
        CustomButtomMenu(
          titulo: 'IHM',
          subTitulo: 'Troca de OP, apontamentos de paradas, operadores',
          imagem: 'assets/images/ferramenta48x48.png',
          onCustomPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MenuIHMPage()),
            );
          },
        ),
      ]),
    );
  }
}
