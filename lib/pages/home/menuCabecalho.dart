import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/pages/selfie/selfiePage.dart';

class MenuCabecalho extends StatefulWidget {
  MenuCabecalho({
    Key? key,
  }) : super(key: key);

  @override
  State<MenuCabecalho> createState() => _MenuCabecalhoState();
}

class _MenuCabecalhoState extends State<MenuCabecalho> {
  String photo = '';

  @override
  initState() {
    super.initState();
    _read('photo', photo);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final cameras = await availableCameras();
            // Get a specific camera from the list of available cameras.
            final firstCamera = cameras.last;
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => TakePictureScreen(
                    camera: firstCamera,
                  )),
            );
          },
          icon: photo != ''
              ? Image.memory(
            base64Decode(photo),
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          )
              : Image.asset('assets/images/selfieButton.png'),
          label: Text(''),
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor: MaterialStateProperty.all(Colors.transparent)),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              'Olá ${VfApp.login.apelido}, escolha uma das opções abaixo',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<String> _read(String texto, String imagem) async {
    final prefs = await SharedPreferences.getInstance();

    // Try reading data from the counter key. If it doesn't exist, return 0.
    String valor = prefs.getString(texto) ?? '';
    print("linha 173 menuPrincipalPage: $valor");
    setState(() {
      imagem = valor;
      photo = valor;
    });
    return valor;
  }
}
