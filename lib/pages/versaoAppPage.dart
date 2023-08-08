import 'package:flutter/material.dart';
import 'package:vfapp/components/customListTile.dart';

class VersaoAppPage extends StatelessWidget {
  static String versao = 'V0.15';

  late List<String> logVersoes = [];

  VersaoAppPage() {
    inicializaLogVersoes();
  }

/* Log de versoes
0.15 - 2023-08-07 - Erro na rotina da alimentação, retornava nulo onde era string.
0.14 - 2023-07-20 - Problema na rotina, da leitura do QR code na consulta de Materia Prima.
0.13 - 2022-06-20 - Habilita configuração sequencial e uso de mascara para obtenção da quantidade
0.12 - 2022-03-10 - inclusao de configuracao para habilitar teclado virtual como padrão
0.11 - 2022-01-25 - Flex solicitou que se as informações das etiquetas esteiverem consistentes, a confirmação deve ser automática (alimenção/realimentação)
0.10 - 2022-01-25 - estava aguardando confirmação apenas no último item
0.9 - 2022-01-25 - a finalização da alimentação não deve ser automática. Vai aguardar o acionamento do botão que finaliza a alimentação
0.8 - 2022-01-25 - as colunas 2 e 7 do QR Code representarão sempre a quantidade a ser alimenta/realimentada e a data de validade
0.7 - 2022-01-19 - nas rotinas de alimentação e realimentação: a quantidade será preenchida automaticamente com a quantidade informada na etiqueta lida
0.6 - 2022-01-17 - consulta de validade de produto considerando eventual leitura de código de barras (primeiro valor antes da vírgula é o código do produto)
0.5 - 2022-01-14 - verificação de validade do lote do produto na alimentação, realimentação e conferência e consulta para testar validade de um produto
0.3 - 2021-12-17 - alteração da consulta permitindo escolher o mapa
0.2 - 2021-12-14 - troca da palavra FALHOU por ERRADA solicitação do operador. Correção da consulta materia-prima quando nao existe match, adaptacao para Inventus
0,1 - 2021-12-13 - primeira versao com todos os recursos do CF implementados.
 */
  void inicializaLogVersoes() {
    logVersoes.add(
        '0.15 - 2023-08-07 - Erro na rotina da alimentação, retornava nulo onde era string');
    logVersoes.add(
        '0.14 - 2023-07-20 - Problema na rotina, da leitura do QR code na consulta de Materia Prima');
    logVersoes.add(
        '0.13 - 2022-06-20 - Inclusão de configuração para habilitar alimentação sequencial');
    logVersoes.add(
        '0.12 - 2022-03-10 - Inclusão de configuração para habilitar o teclado virtual como padrão');
    logVersoes.add(
        '0.11 - 2022-01-25 - Flex solicitou que se as informações das etiquetas esteiverem consistentes, a confirmação deve ser automática (alimenção/realimentação)');
    logVersoes.add(
        '0.10 - 2022-01-25 - estava aguardando confirmação apenas no último item');
    logVersoes.add(
        '0.9 - 2022-01-25 - a finalização da alimentação não deve ser automática. Vai aguardar o acionamento do botão que finaliza a alimentação');
    logVersoes.add(
        '0.8 - 2022-01-25 - as colunas 2 e 7 do QR Code representarão sempre a quantidade a ser alimenta/realimentada e a data de validade');
    logVersoes.add(
        '0.7 - 2022-01-19 - nas rotinas de alimentação e realimentação: a quantidade será preenchida automaticamente com a quantidade informada na etiqueta lida');
    logVersoes.add(
        '0.6 - 2022-01-17 - consulta de validade de produto considerando eventual leitura de código de barras (primeiro valor antes da vírgula é o código do produto)');
    logVersoes.add(
        '0.5 - 2022-01-14 - verificação de validade do lote do produto na alimentação, realimentação e conferência e consulta para testar validade de um produto');
    logVersoes.add(
        '0.3 - 2021-12-17 - alteração na consulta permitindo escolher o mapa');
    logVersoes.add(
        '0.2 - 2021-12-14 - troca da palavra FALHOU por ERRADA solicitação do cliente. Correção da consulta materia-prima quando nao existe match, adaptacao para não leitura do Id Embalagem');
    logVersoes.add(
        '0.1 - 2021-12-13 - primeira versao com todos os recursos do CF implementados. ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VF - Versões'),
      ),
      body: ListView.builder(
          itemCount: logVersoes.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.all(10),
              child: CustomListTile(
                titulo: this.logVersoes[index],
                subTitulo: '',
                imagemEsq: '',
                onCustomPressed: () {},
              ),
            );
          }),
    );
  }
}
