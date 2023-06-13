import 'package:flutter/material.dart';

class CustomListTileSemImagemDoisBotoes extends StatelessWidget {
  final String titulo;
  final String subTitulo;
  final VoidCallback onCustomPressed;
  final VoidCallback onBotaoInicialPressed;
  bool hasTrailing;
  bool mostrarBotaoInicial;
  late Color cor;
  late String textoBotaoInicial;

  CustomListTileSemImagemDoisBotoes({
    Key? key,
    required this.titulo,
    required this.subTitulo,
    required this.onCustomPressed,
    this.cor = Colors.white,
    this.hasTrailing = true,
    this.textoBotaoInicial = '',
    this.mostrarBotaoInicial = true,
    required this.onBotaoInicialPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: cor == Colors.white ? null : cor, // com null garanto que vai funcionar dark e claro
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xFFE5E1E1),
          width: 0.5,
        ),
      ),
      title: Text(
        titulo,
        style: TextStyle(
          // color: Color(0xFF595E61),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        subTitulo,
        style: TextStyle(
          // color: Color(0xFF090909),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: mostrarBotaoInicial,
              child: TextButton(
                  onPressed: () {
                    onBotaoInicialPressed();
                  },
                  child: Text(textoBotaoInicial,
                    style: TextStyle(
                      // color: Color(0xFF595E61),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )),
          ),
          Visibility(
            visible: hasTrailing,
            child: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      onTap: () {
        onCustomPressed();
      },

    );
  }
}
