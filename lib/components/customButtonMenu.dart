import 'package:flutter/material.dart';

typedef VoidNavigate = void Function(String route);

class CustomButtomMenu extends StatelessWidget {
  final String titulo;
  final String subTitulo;
  final String imagem;
  final VoidCallback onCustomPressed;

  const CustomButtomMenu(
      {Key? key,
      required this.titulo,
      required this.subTitulo,
      required this.imagem,
      required this.onCustomPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      width: 130,
      child: FloatingActionButton(
        heroTag: titulo,
        backgroundColor: Colors.white,
        onPressed: () {
          onCustomPressed();
        },
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(titulo,
                  style: TextStyle(
                    color: Color(0xFF1469B8),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(subTitulo,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFFF4752E),
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
