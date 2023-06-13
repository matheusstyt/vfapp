import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vfapp/models/loginRest.dart';
import 'package:vfapp/pages/configuracaoPage.dart';
import 'package:vfapp/pages/home/menuPrincipalPage.dart';
import 'package:vfapp/pages/versaoAppPage.dart';

import '../main.dart';
import 'mensagemDialog.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controlerLogin = TextEditingController();
  final _focoLogin = FocusNode();
  bool isLoading = false;
  bool isTecladoAtivo = VfApp.configuracao.configuracao.tecladoHabilitado;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: [
            Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.white),
                  textTheme: TextTheme().apply(bodyColor: Colors.white),
                ),
                child: MenuFlutuanteDoLogin()),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 60.0, bottom: 50),
                  child: Center(
                    child: Container(
                        child: Image.asset('assets/images/logomap.png')),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      VfApp.leitorFactory.configurarLeituraCB(
                          controller: _controlerLogin,
                          onSubmited: loginSubmitted);
                    },
                    child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorWidth: 12.0,
                      keyboardType: isTecladoAtivo
                          ? TextInputType.text
                          : TextInputType.none,
                      onTap: () {
                        _controlerLogin.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _controlerLogin.text.length);
                      },
                      autofocus: true,
                      onSubmitted: (value) {
                        loginSubmitted();
                      },
                      controller: _controlerLogin,
                      focusNode: _focoLogin,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isTecladoAtivo = !isTecladoAtivo;
                                _focoLogin
                                    .unfocus(); // tiro o foco para forcar o usuario a dar um tap no campo e o teclado aparecer. O ideal depois eh automatizar isso
                              });
                            },
                            icon: isTecladoAtivo
                                ? Icon(Icons.arrow_back)
                                : Icon(Icons.keyboard),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Ler o crachá',
                          hintText: 'Ler o código de barras do crachá'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: !isLoading
                    ? Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            _botaoLogin(context);
                          },
                          child: Text(
                            'Entrar',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginSubmitted() {
    setState(() {
      isLoading = true;
    });
    _botaoLogin(context);
  }

  void _botaoLogin(BuildContext context) {
    // Verifica se foi didgitado algum valor
    if (_controlerLogin.text.isEmpty) {
      MensagemDialog.showMensagem(
          context, 'Login VF', 'Ler um valor válido no campo Login');
      setState(() {
        isLoading = false;
      });

      return;
    }

    // Verificar o webservice
    LoginRest rn = new LoginRest();
    Future<LoginDTO> logindto = rn.fetchLoginDTO(_controlerLogin.text);
    logindto.then((value) async {
      try {
        if (value != null && value.isAutorizado != null && value.isAutorizado) {
          value.matricula =
              _controlerLogin.text; // gambi para evitar de mudar o REST
          VfApp.login = value; // Salva o login para uso futuo
          _controlerLogin.text = ''; // limpa valor digitado

          // Desconfigura a leitura do codigo de barras
          VfApp.leitorFactory.configurarLeituraCB(
              controller: TextEditingController(), onSubmited: () {});
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => MenuPrincipalPage()));
        } else {
          MensagemDialog.showMensagem(
              context, 'Login VF', 'Sem direito de acesso.');
        }
      } on Exception catch (_) {
        MensagemDialog.showMensagem(
            context, 'Login VF', 'Usuário desconhecido.');
      }
      setState(() {
        isLoading = false;
      });
    });

    // Trata excessao
    logindto.catchError((onError) {
      MensagemDialog.showPerdaConexao(context);
      setState(() {
        isLoading = false;
      });
    });
  }
}

class MenuFlutuanteDoLogin extends StatelessWidget {
  const MenuFlutuanteDoLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: Colors.indigo,
      onSelected: (item) => onSelected(context, item),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Text('Configurações'),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text('Log de versões'),
        ),
      ],
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ConfiguracaoPage()),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => VersaoAppPage()),
        );
        break;
    }
  }
}
