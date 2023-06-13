import 'package:flutter/material.dart';
import 'package:vfapp/components/customListTile.dart';
import 'package:vfapp/pages/realimentacao/previsaoRealimentacaoPage.dart';

class MenuVertical extends StatelessWidget {
  const MenuVertical({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: CustomListTile(
            titulo: 'Previsão Realimentação',
            subTitulo: 'Apresenta as próximas realimentações a serem feitas',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => PrevisaoRealimentacaoPage()),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          // width: MediaQuery.of(context).size.width - 22,
          //color: Colors.white,
          child: CustomListTile(
            titulo: 'Serviços na ferramenta',
            subTitulo: 'Apresenta a previsão das manutenções nas ferramentas',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {},
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          // width: MediaQuery.of(context).size.width - 22,
          //color: Colors.white,
          child: CustomListTile(
            titulo: 'Trocar OP',
            subTitulo: 'Permite trocar a OP para a linha de produção',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {},
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          // width: MediaQuery.of(context).size.width - 22,
          //color: Colors.white,
          child: CustomListTile(
            titulo: 'Informar parada',
            subTitulo: 'Permite informar o motivo da última parada da linha',
            imagemEsq: 'assets/images/selfieButton.png',
            onCustomPressed: () {},
          ),
        ),
      ],
    );
  }
}
