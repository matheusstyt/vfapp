import 'package:flutter/material.dart';

class FirstCustomListTile extends StatelessWidget {
  final String titulo;
  final String subTitulo;
  final String imagemEsq;
  final VoidCallback onCustomPressed;

  const FirstCustomListTile(
      {Key? key,
      required this.titulo,
      required this.subTitulo,
      required this.imagemEsq,
      required this.onCustomPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
        side: BorderSide(
          color: Color(0xFFFFFFFF),
          width: 1.5,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.orange,
        child: Image.asset(imagemEsq),
      ),
      title: Text(
        titulo,
        style: TextStyle(
          color: Color(0xFF595E61),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        subTitulo,
        style: TextStyle(
          color: Color(0xFFB7B7B7),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        onCustomPressed();
      },
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String titulo;
  final String subTitulo;
  final String imagemEsq;
  final VoidCallback onCustomPressed;

  const CustomListTile(
      {Key? key,
      required this.titulo,
      required this.subTitulo,
      required this.imagemEsq,
      required this.onCustomPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          // color: Color(0xFFE5E1E1),
          width: 0.5,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.orange,
        child: Image.asset(imagemEsq),
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
          color: Color(0xFFB7B7B7),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        onCustomPressed();
      },
    );
  }
}
