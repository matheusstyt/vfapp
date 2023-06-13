import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const CustomAppBar({required this.titulo});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100, // Set this height
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF2B2246)),
      title: Text(
        titulo,
        style: TextStyle(
          color: Color(0xFF2B2246),
        ),
      ),
    );
  }
}
// ? exemplo
//appBar: CustomAppBar(texto: 'Seu texto aqui'),