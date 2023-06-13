import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/components/customButtonMenu.dart';
import 'package:vfapp/components/customListTile.dart';
import 'package:vfapp/pages/home/menuDaEsquerda.dart';
import 'package:vfapp/pages/home/menuCabecalho.dart';
import 'package:vfapp/pages/home/menuFlutuanteDoMenuPrincipal.dart';
import 'package:vfapp/pages/home/menuHorizontal.dart';
import 'package:vfapp/pages/home/menuVertical.dart';
import 'package:vfapp/pages/realimentacao/previsaoRealimentacaoPage.dart';
import 'package:vfapp/pages/selfie/selfiePage.dart';

import '../../main.dart';
import '../configuracaoPage.dart';
import '../escolherLinhaPage.dart';
import '../mensagemDialog.dart';
import 'menuMateriaPrimaPage.dart';

/* Classe principal para porta de entrada a classe de controle de status
 */
class MenuPrincipalPage extends StatefulWidget {
  @override
  MenuPrincipalPageState createState() {
    return new MenuPrincipalPageState();
  }
}

/* Classe secundária para controle de state da pagina principal
 */
class MenuPrincipalPageState extends State<MenuPrincipalPage> {
  /* Metodo para construção da tela do menu principal
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VF Home'),
        actions: [
          Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.white),
                textTheme: TextTheme().apply(bodyColor: Colors.white),
              ),
              child: MenuFlutuanteDoMenuPrincipal()),
        ],
      ),
      drawer: MenuDaEsquerda(),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              MenuCabecalho(),
              MenuHorizontal(),
              MenuVertical(),
            ],
          )),
    );
  }
}





