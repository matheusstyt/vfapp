import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String title;
  late bool isMostrarAppBar = true;

  ErrorPage({Key? key, required this.title, this.isMostrarAppBar = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.isMostrarAppBar
          ? AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text('VF Error'),
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/1_NoConnection.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.14,
            //left: MediaQuery.of(context).size.width * 0.115,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.98,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Text(
                  title,
                  maxLines: 8,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
