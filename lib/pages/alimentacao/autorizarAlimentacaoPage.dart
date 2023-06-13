
import 'package:flutter/material.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/LoginRest.dart';
import 'package:vfapp/pages/mensagemDialog.dart';

class AutorizarAlimentacaoPage extends StatefulWidget {
  final String cdpt;
  final String cdmapa;
  final String cdpa;
  final Function autorizarAlimentacao;

  const AutorizarAlimentacaoPage({Key? key, required this.cdpa, required this.autorizarAlimentacao, required this.cdpt, required this.cdmapa}) : super(key: key);

  @override
  AutorizarAlimentacaoPageState createState() {
    return AutorizarAlimentacaoPageState();
  }
}


class AutorizarAlimentacaoPageState extends State<AutorizarAlimentacaoPage> {
  final _controller = TextEditingController();
  final _foco = FocusNode();
  late bool isTecladoAtivo = VfApp.configuracao.configuracao.tecladoHabilitado;
  late bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('VF Autorização Alimentação'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('Posto ${widget.cdpt} - Mapa ${widget.cdmapa} - PA ${widget.cdpa}'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      VfApp.leitorFactory.configurarLeituraCB(controller: _controller, onSubmited: autorizaSubmitted);
                    },
                    child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorWidth: 12.0,
                      keyboardType: isTecladoAtivo ? TextInputType.text : TextInputType.none,
                      onTap: () {
                        _controller.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _controller.text.length);
                      },
                      autofocus: true,
                      onSubmitted: (value) {
                        autorizaSubmitted();
                      },
                      controller: _controller,
                      focusNode: _foco,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isTecladoAtivo = !isTecladoAtivo;
                                _foco.unfocus(); // tiro o foco para forcar o usuario a dar um tap no campo e o teclado aparecer. O ideal depois eh automatizar isso
                              });
                            },
                            icon: isTecladoAtivo ? Icon(Icons.arrow_back): Icon(Icons.keyboard),
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
                child: !isLoading ? Container(
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
                      _botaoAutorizar(context);
                    },
                    child: Text(
                      'Autorizar alimentação',
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

  autorizaSubmitted() {
    setState(() {
      isLoading = true;
    });
    _botaoAutorizar(context);
  }

  void _botaoAutorizar(BuildContext context) {
    // Verifica se foi didgitado algum valor
    if (_controller.text.isEmpty) {
      MensagemDialog.showMensagem(context, 'Autorizar Alimentação', 'Ler o crachá de autorização');
      setState(() {
        isLoading = false;
      });

      return;
    }


    // Verificar o webservice
    LoginRest rn = new LoginRest();
    Future<LoginDTO> logindto = rn.fetchLoginDTO(_controller.text);
    logindto.then((value) async {
      try {
        if (value != null && value.isAutorizado != null && value.isAutorizado) {
          value.matricula = _controller.text; // gambi para evitar de mudar o REST
          _controller.text = ''; // limpa valor digitado

          // Desconfigura a leitura do codigo de barras
          VfApp.leitorFactory.configurarLeituraCB(controller: TextEditingController(), onSubmited:  (){});

          // Aqui devemos efetivar a alimentacao manualmente
          widget.autorizarAlimentacao(widget.cdpa, _controller.text);
          Navigator.pop(context);

        } else {
          MensagemDialog.showMensagem(context, 'Autorizar Alimentação', 'Sem direito de autorizar alimentação.');
        }
      } on Exception catch (_) {
        MensagemDialog.showMensagem(context, 'Autorizar Alimentação', 'Usuário desconhecido.');
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