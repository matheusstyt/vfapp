
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/functions/leitorCBFactory.dart';
import 'package:vfapp/pages/loginPage.dart';
import 'models/configuracao.dart';
import 'models/loginRest.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  runApp(VfApp());
}

class VfApp extends StatefulWidget {
  static ConfiguracaoApp configuracao = new ConfiguracaoApp();
  static ThemeController tController = new ThemeController();
  static bool isInitialized = false;
  static LoginDTO login = new LoginDTO(
      apelido: '',
      dthrServidor: '',
      idUsuario: 0,
      isAutorizado: false,
      matricula: '');

  // Abaixo atributo de gerenciamento do hardware que realiza a leitura do codigo d ebarras
  static LeitorCBFactory leitorFactory = LeitorCBFactory();

  @override
  State<VfApp> createState() => _VfAppState();
}

class _VfAppState extends State<VfApp> {



  @override
  void initState() {
    super.initState();

    /* o theme controller eh usado para modificar o tema entre claro e escuro  */
    VfApp.tController.addListener(() {
      setState(() {});
    });

    VfApp.leitorFactory.inicializaLeitoresCB();
  }

  @override
  Widget build(BuildContext context) {
    // Ler as configuracoes do app. Url do servidor REST, ate o momento.

    if (!VfApp.isInitialized) {
      VfApp.configuracao.lerConfiguracao().then((value) {
        VfApp.tController
            .atualizaBrightness(VfApp.configuracao.configuracao.brightness);
        VfApp.isInitialized = true;
        print("linha 45 brightness " +
            (VfApp.configuracao.configuracao.brightness).toString());
      }).onError((error, stackTrace) {
        print("erro na configuracao $error");
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VF Login',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        brightness: VfApp.tController.brightness,
      ),
      home: LoginPage(title: 'VF Login'),
      routes: {},
    );
  }

}

class ThemeController extends ChangeNotifier {
  Brightness brightness = Brightness.dark;

  void atualizaBrightness(bool tema) {
    this.brightness = tema ? Brightness.dark : Brightness.light;
    notifyListeners();
  }
}
