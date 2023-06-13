import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vfapp/components/customFieldCF.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/validadeProdutoRest.dart';
import 'package:vfapp/pages/mensagemDialog.dart';
import 'package:vfapp/pages/consultar/consultarValidadeProdutoPage.dart';

/* 
  O objetivo dessa classe é permitir a consulta da validade de um produto com base na data e horas informadas
 */
class ConsultarValidadeProdutoForm extends StatefulWidget {
  late ValidadeProdutoDTO validadedto;
  final ScrollController _scrollController = ScrollController();

  /*
  ConsultarValidadeProdutoPage(
      {Key? key,
      required this.mapaalimentacaodto,
      required this.cdpt,
      required this.alimentacaoDTO})
      : super(key: key);
  */

  @override
  ConsultarValidadeProdutoFormState createState() {
    validadedto = ValidadeProdutoDTO(
        codpro: '',
        dataValidade:
            ''); // usado apenas para inicializar o dto qdo nao tiver nenhuma posicao lida

    return ConsultarValidadeProdutoFormState();
  }
}

class ConsultarValidadeProdutoFormState
    extends State<ConsultarValidadeProdutoForm> {
  final _formKey = GlobalKey<FormState>();
  final _controlerCB = TextEditingController();
  final _controlerDtHr = TextEditingController();

  final FocusNode _focoDtHr = FocusNode();
  final FocusNode _focoProduto = FocusNode();

  late bool isTecladoAtivo = VfApp.configuracao.configuracao.tecladoHabilitado;

  @override
  void initState() {
    super.initState();

    _focoProduto.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VF Consulta validade')),
      body: SingleChildScrollView(
        controller: widget._scrollController,
        padding: EdgeInsets.only(top: 10),
        child: FocusScope(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                CustomFieldCF(
                  controller: _controlerCB,
                  isTecladoAtivo: isTecladoAtivo,
                  foco: _focoProduto,
                  ativaDesativaTeclado: ativaDesativaTeclado,
                  botaoSubmitted: idProdutoSubmitted,
                  tituloText: 'Produto',
                  tituloHint: 'Ler código de barras contendo o produto',
                ),
                CustomFieldCF(
                  controller: _controlerDtHr,
                  isTecladoAtivo: isTecladoAtivo,
                  foco: _focoDtHr,
                  ativaDesativaTeclado: ativaDesativaTeclado,
                  botaoSubmitted: dataHoraSubmitted,
                  tituloText: 'Data e hora',
                  tituloHint: 'Formato AAAA-MM-DD HH:MI:SS',
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          botaoConsultar();
                        },
                        child: const Text('Consultar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _controlerCB.text = '';
                          _controlerDtHr.text = '';
                          _focoProduto.requestFocus();
                        },
                        child: const Text('Limpar'),
                      ),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Metodo para reexecutar o build
  void refresh() {
    setState(() {});
  }

  bool getIsTecladoAtivo() {
    return isTecladoAtivo;
  }

  void inverterTecladoAtivo() {
    isTecladoAtivo = !isTecladoAtivo;
  }

  void ativaDesativaTeclado(FocusNode foco) {
    setState(() {
      foco.unfocus(); // tiro o foco para forcar o usuario a dar um tap no campo e o teclado aparecer. O ideal depois eh automatizar isso
      isTecladoAtivo = !isTecladoAtivo;
    });
  }

  idProdutoSubmitted() {
    // Verifidar se produto foi informado
    if (isProdutoValido()) {
      // atribuir data/hora para
      var formatoData = DateFormat('yyyy-MM-dd HH:mm:ss');
      _controlerDtHr.text = formatoData.format(DateTime.now());
      _focoDtHr.requestFocus();
    }
  }

  String obtemProduto(String value) {
    String cdProdutoEncontrado = '';

    int posicao = value.indexOf(",");

    if (posicao == -1) {
      cdProdutoEncontrado = value;
    } else {
      cdProdutoEncontrado = value.substring(0, posicao - 1).trim();
    }

    return cdProdutoEncontrado;
  }

  bool isProdutoValido() {
    bool retorno = false;

    String cdProdutoEncontrado = obtemProduto(_controlerCB.text);

    // Verifidar se produto foi informado
    if (cdProdutoEncontrado.isEmpty) {
      MensagemDialog.showMensagem(context, 'Produto não informado', '');

      _controlerCB.text = '';
      _focoProduto.requestFocus();

      retorno = false;
    } else {
      retorno = true;
    }

    return retorno;
  }

  dataHoraSubmitted() {
    String cDtHr = _controlerDtHr.text;

    // verificar se a data foi informada
    if (cDtHr.isEmpty) {
      MensagemDialog.showMensagem(context, 'Data/hora não informado', '');

      _controlerDtHr.text = '';
      _focoDtHr.requestFocus();

      return;
    }

    // verificar se data/hora é valida
    if (!isValidDate(cDtHr)) {
      MensagemDialog.showMensagem(context, 'Formato de data/hora inválido', '');

      _controlerDtHr.text = '';
      _focoDtHr.requestFocus();

      return;
    }
  }

  bool isValidDate(String input) {
    try {
      final date = DateTime.parse(input);
      final originalFormatString = toOriginalFormatString(date);
      return input == originalFormatString;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');

    final h = dateTime.hour.toString().padLeft(2, '0');
    final mi = dateTime.minute.toString().padLeft(2, '0');
    final s = dateTime.second.toString().padLeft(2, '0');

    return "$y-$m-$d $h:$mi:$s";
  }

  void botaoConsultar() {
    if (!isProdutoValido()) {
      return;
    }

    dataHoraSubmitted();
    if (_controlerDtHr.text == '') {
      return;
    }

    // chamar web service
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ConsultarValidadeProdutoPage(
              cdProduto: obtemProduto(_controlerCB.text),
              cDtHr: _controlerDtHr.text)),
    );
  }
}
