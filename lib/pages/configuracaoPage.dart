import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/pages/mensagemDialog.dart';

import 'home/singleton.dart';

class ConfiguracaoPage extends StatefulWidget {
  @override
  _ConfiguracaoPage createState() {
    return _ConfiguracaoPage();
  }
}

class _ConfiguracaoPage extends State<ConfiguracaoPage> {
  final _formKey = GlobalKey<FormState>();
  final _controlerUrl = TextEditingController();
  final _controlerUrlProtheus = TextEditingController();
  final _controlerCdFase = TextEditingController();
  final _controlerVermelhoAte = TextEditingController();
  final _controlerAmareloAte = TextEditingController();
  final _controlerSegRecLista = TextEditingController();
  bool temaBrightness =
      VfApp.configuracao.configuracao.brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    // Inicializa a GUI com valores do DTO
    _controlerUrl.text = VfApp.configuracao.configuracao.url;
    _controlerUrlProtheus.text = VfApp.configuracao.configuracao.urlProtheus;
    _controlerCdFase.text = VfApp.configuracao.configuracao.cdgtFase;
    _controlerVermelhoAte.text =
        VfApp.configuracao.configuracao.vermelhoate.toString();
    _controlerAmareloAte.text =
        VfApp.configuracao.configuracao.amareloate.toString();
    _controlerSegRecLista.text =
        VfApp.configuracao.configuracao.segreclista.toString();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('VF Configurações'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 40),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controlerUrl,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'URL Conexão com servidor',
                          hintText:
                              'A Url deve apontar para o servidor do sistema'),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informar uma URL do servidor.';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(5),
                  //         border: Border.all(
                  //             style: BorderStyle.solid,
                  //             width: 1,
                  //             color: Colors.white.withAlpha(100))),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text('Habilitar validação ERP'),
                  //           Switch(
                  //             value: VfApp.configuracao.configuracao.habilitarValidacaoERP,
                  //             onChanged: (value) {
                  //               setState(() {
                  //                 VfApp.configuracao.configuracao.habilitarValidacaoERP = value;
                  //               });
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: VfApp.configuracao.configuracao.habilitarValidacaoERP,
                      controller: _controlerUrlProtheus,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'URL Conexão para validações ERP',
                          hintText:
                              'A Url deve apontar para o servidor ERP'),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informar uma URL do servidor ERP.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controlerCdFase,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Fase da produção',
                          hintText:
                              'Será usada para obter todas as linhas da fase'),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informar um valor para a fase';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              style: BorderStyle.solid,
                              width: 1,
                              color: Colors.white.withAlpha(100))),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Modo Escuro'),
                            Switch(
                              value: VfApp.tController.brightness ==
                                  Brightness.dark,
                              onChanged: (value) {
                                setState(() {
                                  VfApp.configuracao.configuracao.brightness =
                                      value;
                                  VfApp.tController.atualizaBrightness(value);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              style: BorderStyle.solid,
                              width: 1,
                              color: Colors.white.withAlpha(100))),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ler ID embalagem'),
                            Switch(
                              value: VfApp.configuracao.configuracao.lerid,
                              onChanged: (value) {
                                setState(() {
                                  VfApp.configuracao.configuracao.lerid = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              style: BorderStyle.solid,
                              width: 1,
                              color: Colors.white.withAlpha(100))),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Teclado virtual sempre habilitado'),
                            Switch(
                              value: VfApp.configuracao.configuracao.tecladoHabilitado,
                              onChanged: (value) {
                                setState(() {
                                  VfApp.configuracao.configuracao.tecladoHabilitado = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              style: BorderStyle.solid,
                              width: 1,
                              color: Colors.white.withAlpha(100))),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Preenchimento automático Posição'),
                            Switch(
                              value: VfApp.configuracao.configuracao.posicaoautomatica,
                              onChanged: (value) {
                                setState(() {
                                  VfApp.configuracao.configuracao.posicaoautomatica = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              style: BorderStyle.solid,
                              width: 1,
                              color: Colors.white.withAlpha(100))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Limite de Tempo Previsão Realimentação\n(Em minutos)',
                              textAlign: TextAlign.center,
                            ),
                            Container(height: 20),
                            Row(
                              children: [
                                Expanded(flex: 1, child: Text('Vermelho')),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextFormField(
                                      enabled: VfApp.configuracao.configuracao.lerid,
                                      controller: _controlerVermelhoAte,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'de 0 até:',
                                          hintText: 'Número de minutos'),
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Informar um valor para a fase';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(flex: 2, child: Text('Amarelo')),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextFormField(
                                      enabled: VfApp.configuracao.configuracao.lerid,
                                      controller: _controlerVermelhoAte,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'de:',
                                          hintText: 'Número de minutos'),
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Informar um valor para a fase';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextFormField(
                                      enabled: VfApp.configuracao.configuracao.lerid,
                                      controller: _controlerAmareloAte,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'até:',
                                          hintText: 'Número de minutos'),
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Informar um valor para a fase';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Intervalo Recarregar Lista de Previsão:'),
                            )),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextFormField(
                              enabled: VfApp.configuracao.configuracao.lerid,
                              controller: _controlerSegRecLista,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Tempo em segundos:',
                                  hintText: 'Número de segundos'),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Informar um valor para o tempo';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Salvando configuração')),
                        );

                        // Altera configuracao local e salva
                        VfApp.configuracao.configuracao.url =
                            _controlerUrl.text;
                        VfApp.configuracao.configuracao.urlProtheus =
                            _controlerUrlProtheus.text;
                        VfApp.configuracao.configuracao.cdgtFase =
                            _controlerCdFase.text;
                        VfApp.configuracao.configuracao.vermelhoate =
                            int.parse(_controlerVermelhoAte.text);
                        VfApp.configuracao.configuracao.amareloate =
                            int.parse(_controlerAmareloAte.text);
                        VfApp.configuracao.configuracao.segreclista =
                            int.parse(_controlerSegRecLista.text);
                        VfApp.configuracao.salvarConfiguracao().then((value) async
                        {
                          MensagemDialog.showMensagem(context, 'Configuração', 'Configuração salva com sucesso.');
                        }).onError((error, stackTrace) async {
                          MensagemDialog.showMensagem(context, 'Configuração', 'Configuração não salvou.\n${error.toString()}');
                        });
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
