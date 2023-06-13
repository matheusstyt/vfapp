import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vfapp/components/customFieldCF.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/mapaCorrenteRest.dart';
import 'package:vfapp/models/realimentacaoRest.dart';
import 'package:vfapp/pages/mensagemDialog.dart';
import 'package:vfapp/pages/realimentacao/realimentarPostoPage.dart';

class RealimentarForm extends StatefulWidget {
  final RealimentarPostoPageState realimentarPostoPageState;
  final MapaDTO mapadto;
  late RealimentacaoDTO realimentacaoDTO;
  late bool isMostrarAppBar;

  final int SITUACAO_VALIDADE_LOTE_OK = 1;
  final int SITUACAO_VALIDADE_LOTE_INCONSISTENTE = 2;
  final int SITUACAO_VALIDADE_LOTE_DATA_VENCIDA = 3;

  RealimentarForm(
      {Key? key,
      required this.mapadto,
      required this.realimentarPostoPageState,
      required this.realimentacaoDTO,
      this.isMostrarAppBar = false})
      : super(key: key);

  @override
  RealimentarFormState createState() {
    print('createState realimentarForm');

    return RealimentarFormState(
        realimentarPostoPageState, mapadto, isMostrarAppBar);
  }
}

class RealimentarFormState extends State<RealimentarForm> {
  final RealimentarPostoPageState
      realimentarPostoPageState; // uso para atualizar o realimentacaodto e forca novo REST

  late MapaDTO mapadto;

  final controllerPosicao = TextEditingController();
  final controllerMateriaPrimaEsperada = TextEditingController();
  final controllerIdEmbalagem = TextEditingController();
  final controllerQuantidade = TextEditingController();

  final FocusNode focoPosicao = FocusNode();
  final FocusNode focomateriaPrimaEsperada = FocusNode();
  final FocusNode focoIdEmbalagem = FocusNode();
  final FocusNode focoQuantidade = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool isTecladoAtivo = VfApp.configuracao.configuracao.tecladoHabilitado;

  bool isMostrarAppBar;

  RealimentarFormState(
      this.realimentarPostoPageState, this.mapadto, this.isMostrarAppBar);

  @override
  Widget build(BuildContext context) {
    // Limpa os campos pois serao atualizados
    controllerPosicao.text = '';
    controllerMateriaPrimaEsperada.text = '';
    controllerIdEmbalagem.text = '';
    focoPosicao.requestFocus();

    // Vou inicializar os controller com os valores do realimentacaoDTO e conforme valores recebidos vou setar o foco
    if (widget.realimentacaoDTO.cdPa.isNotEmpty) {
      controllerPosicao.text = widget.realimentacaoDTO.cdPa;
      focomateriaPrimaEsperada.requestFocus();
    }
    if (widget.realimentacaoDTO.cdProduto.isNotEmpty) {
      controllerMateriaPrimaEsperada.text = widget.realimentacaoDTO.cdProduto;
      focoIdEmbalagem.requestFocus();
    }
    if (widget.realimentacaoDTO.reelId.isNotEmpty) {
      controllerIdEmbalagem.text = widget.realimentacaoDTO.reelId;
      focoQuantidade.requestFocus();
    }

    // Se veio a quantidade, entao a alimentacao foi salva, entao limpar turdo
    if (widget.realimentacaoDTO.qtAlimentada > 0 ||
        controllerQuantidade.text.isNotEmpty) {
      limparFormulario();
    }

    return Scaffold(
      appBar: isMostrarAppBar
          ? AppBar(
              title: Text('Realimentar ${widget.mapadto.cdpt}'),
            )
          : null,
      body: SingleChildScrollView(
        child: FocusScope(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Mapa\n${mapadto.cdmapa}',
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomFieldCF(
                  controller: controllerPosicao,
                  isTecladoAtivo: isTecladoAtivo,
                  foco: focoPosicao,
                  ativaDesativaTeclado: ativaDesativaTeclado,
                  botaoSubmitted: posicaoSubmitted,
                  tituloText: 'Posição a ser alimentada',
                  tituloHint:
                      'Qual posição será alimentada com a materia-prima',
                ),
                CustomFieldCF(
                  controller: controllerMateriaPrimaEsperada,
                  isTecladoAtivo: isTecladoAtivo,
                  foco: focomateriaPrimaEsperada,
                  ativaDesativaTeclado: ativaDesativaTeclado,
                  botaoSubmitted: () {},
                  tituloText: 'Materia-prima esperada',
                  isReadOnly: true,
                ),
                CustomFieldCF(
                  controller: controllerIdEmbalagem,
                  isTecladoAtivo: isTecladoAtivo,
                  foco: focoIdEmbalagem,
                  ativaDesativaTeclado: ativaDesativaTeclado,
                  botaoSubmitted: idEmbalagemSubmitted,
                  tituloText: VfApp.configuracao.configuracao.lerid
                      ? 'ID Embalagem'
                      : 'Produto CB',
                  tituloHint: VfApp.configuracao.configuracao.lerid
                      ? 'Ler id embalagem'
                      : 'Ler CB Produto',
                ),
                CustomFieldCF(
                  controller: controllerQuantidade,
                  isTecladoAtivo: isTecladoAtivo,
                  foco: focoQuantidade,
                  ativaDesativaTeclado: ativaDesativaTeclado,
                  botaoSubmitted: quantidadeSubmitted,
                  tituloText: 'Quantidade',
                  tituloHint: 'Ler quantidade embalagem',
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            quantidadeSubmitted();
                          }
                        },
                        child: const Text('Realimentar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          limparFormulario();
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

  void limparFormulario() {
    controllerPosicao.text = '';
    controllerMateriaPrimaEsperada.text = '';
    controllerIdEmbalagem.text = '';
    controllerQuantidade.text = '';

    widget.realimentacaoDTO.cdPa = '';
    widget.realimentacaoDTO.cdProduto = '';
    widget.realimentacaoDTO.reelId = '';
    widget.realimentacaoDTO.qtAlimentada = 0;

    realimentarPostoPageState.cdpa = '';
    realimentarPostoPageState.cdproduto = '';
    realimentarPostoPageState.reelid = '';
    realimentarPostoPageState.quantidade = 0;

    realimentarPostoPageState.isSalvar = false;
    realimentarPostoPageState.isSucessoRealimentar = false;

    focoPosicao.requestFocus();
  }

  void posicaoSubmitted() {
    realimentarPostoPageState.cdpa = controllerPosicao.text;
    realimentarPostoPageState.refreshRest();
  }

  void ativaDesativaTeclado(FocusNode foco) {
    setState(() {
      foco.unfocus(); // tiro o foco para forcar o usuario a dar um tap no campo e o teclado aparecer. O ideal depois eh automatizar isso
      isTecladoAtivo = !isTecladoAtivo;
    });
  }

  idEmbalagemSubmitted() {
    realimentarPostoPageState.reelid = controllerIdEmbalagem.text;
    String cdProdutoEncontrado =
        obtemProduto(controllerIdEmbalagem.text, widget.realimentacaoDTO);
    realimentarPostoPageState.cdproduto = cdProdutoEncontrado;

    int qtItens =
        isReelIdValido(controllerIdEmbalagem.text, cdProdutoEncontrado);

    int qtItensEsperado = VfApp.configuracao.configuracao.lerid ? 3 : 1;

    // Se nao existe um produto encontrado, então nao aceitar o reelid
    if (cdProdutoEncontrado.isEmpty || qtItens < qtItensEsperado) {
      // Salvar a leitura e avisar realimentacao invalida
      realimentarPostoPageState.cdproduto = controllerIdEmbalagem.text;
      realimentarPostoPageState.reelid = controllerIdEmbalagem.text;
      realimentarPostoPageState.quantidade = 0;
      realimentarPostoPageState.isSalvar = true;
      realimentarPostoPageState.isSucessoRealimentar = false;
      realimentarPostoPageState.refreshRest();

      if (cdProdutoEncontrado.isEmpty)
        MensagemDialog.showMensagem(context, 'Realimentação ERRADA',
            'Produto esperado [${controllerMateriaPrimaEsperada.text}] não encontrado em ${controllerIdEmbalagem.text}');
      else
        MensagemDialog.showMensagem(context, 'Realimentação ERRADA',
            'Id Embalagem inválido. Produto encontrado $cdProdutoEncontrado, mas qtItens ${qtItens} no id ${controllerIdEmbalagem.text}');

      return;
    }

    int situacaoLote =
        getStatusValidadeLote(controllerIdEmbalagem.text, cdProdutoEncontrado);

    if (situacaoLote == widget.SITUACAO_VALIDADE_LOTE_OK) {
      double quantidade =
          obtemQuantidade(controllerIdEmbalagem.text, cdProdutoEncontrado);
      realimentarPostoPageState.quantidade = quantidade;

      // Se tem quantidade, entao salvar com sucesso
      realimentarPostoPageState.isSalvar = quantidade > 0;

      // se obteve a quantidade marcar como true a realimentacao
      if (quantidade > 0) {
        realimentarPostoPageState.isSucessoRealimentar = true;
      }

      //2022-01-19 - Flex solicitou que fosse atribuída quantidade que consta no código de barras
      controllerQuantidade.text = quantidade.toInt().toString();

      // refresh no rest
      //2022-01-19 - Flex solicitou que fosse atribuída quantidade que consta no código de barras
      // solic flex: 0.11
      realimentarPostoPageState.refreshRest();
    } else {
      // Salvar a leitura e avisar realimentacao invalida
      realimentarPostoPageState.cdproduto = controllerIdEmbalagem.text;
      realimentarPostoPageState.reelid = controllerIdEmbalagem.text;
      realimentarPostoPageState.quantidade = 0;
      realimentarPostoPageState.isSalvar = true;
      realimentarPostoPageState.isSucessoRealimentar = false;
      realimentarPostoPageState.refreshRest();
    }
  }

  int getStatusValidadeLote(String value, String cdProdutoEncontrado) {
    int retorno = widget.SITUACAO_VALIDADE_LOTE_OK;

    if (VfApp.configuracao.configuracao.lerid) {
      if (Funcoes.reelIDValidadeLoteConsistente(
          controllerIdEmbalagem.text, cdProdutoEncontrado)) {
        if (Funcoes.reelIsTemValidadeLote(
            controllerIdEmbalagem.text, cdProdutoEncontrado)) {
          // verifica se a data é valida (menor que a data atual)
          DateTime dtLote = Funcoes.getRellDataLote(
              controllerIdEmbalagem.text, cdProdutoEncontrado);

          if (!Funcoes.isReelDataLoteValida(dtLote)) {
            retorno = widget.SITUACAO_VALIDADE_LOTE_DATA_VENCIDA;

            var formatoData = DateFormat('yyyy-MM-dd');

            MensagemDialog.showMensagem(
                context,
                'Lote da materia-prima vencido em ' +
                    formatoData.format(dtLote),
                '');
            controllerIdEmbalagem.text = '';
          }
        }
      } else {
        // se a validade do lote (formato) estiver inconsistente, ainda assim será salvo posteriormente
        retorno = widget.SITUACAO_VALIDADE_LOTE_INCONSISTENTE;

        MensagemDialog.showMensagem(
            context, 'Validade do lote não é uma data valida', '');
        controllerIdEmbalagem.text = '';
      }
    }

    return retorno;
  }

  quantidadeSubmitted() {
    String cdProdutoEncontrado =
        obtemProduto(controllerIdEmbalagem.text, widget.realimentacaoDTO);
    double quantidade =
        obtemQuantidade(controllerQuantidade.text, cdProdutoEncontrado);

    // Se a quantidade obtida for mamior que 0 eh pq encontrou um valor valido na string lida no CB. Mas
    // devemos avaliar se esse valor está presente no cb principal. Se nao estiver a qtde eh invalida
    if (VfApp.configuracao.configuracao.lerid &&
        (reelIDContemQuantidade(
                controllerIdEmbalagem.text, quantidade, cdProdutoEncontrado) ==
            false)) {
      MensagemDialog.showMensagem(context, 'Quantidade desconhecida',
          'Esse CB não contém a quantidade válida');
      controllerQuantidade.text = '';
    } else {
      int situacaoLote = getStatusValidadeLote(
          controllerIdEmbalagem.text, cdProdutoEncontrado);

      if (situacaoLote == widget.SITUACAO_VALIDADE_LOTE_OK) {
        realimentarPostoPageState.quantidade = quantidade;
        realimentarPostoPageState.isSalvar = quantidade > 0;
        realimentarPostoPageState.isSucessoRealimentar = quantidade > 0;
        controllerQuantidade.text = quantidade.toString();
        realimentarPostoPageState.refreshRest();
      } else {
        controllerIdEmbalagem.text = '';
      }
    }
  }

  // Objetivo desse metodo eh obter o caracter que separa os valores dentro do reelid. Para isso utilizaremos
  // o caracter imediatamente apos o codigo do produto encontrado, ou antes dele.
  String obtemSeparador(String value, String cdProdutoEncontrado) {
    print(
        'obtendo separador de $value para o cdProdutoEncontrado $cdProdutoEncontrado');
    String separador;
    int posicao = value.indexOf(cdProdutoEncontrado);
    if (posicao > 0) {
      separador = value[posicao - 1];
    } else if (posicao == 0 && value.length > cdProdutoEncontrado.length) {
      print('posicao do separador $posicao');
      separador = value[cdProdutoEncontrado.length];
    } else {
      separador = ','; // virgula como padrao
    }
    return separador;
  }

  int isReelIdValido(String value, String cdProdutoEncontrado) {
    // O separador sera o caracter que envolve o codigo do produto encontrado
    var separador = obtemSeparador(value, cdProdutoEncontrado);
    List<String> valores = value.split(separador);
    return valores.length; // se tiver mais de 2 segmentos entao considerar
  }

  bool reelIDContemQuantidade(
      String value, double quantidade, String cdProdutoEncontrado) {
    bool retorno = false;

    var separador = obtemSeparador(value, cdProdutoEncontrado);
    List<String> valores = value.split(separador);
    List<double> qtdeValidas = [];

    for (String valor in valores) {
      // descarta o trecho com o codigo do produto encontrado
      if (valor.compareTo(cdProdutoEncontrado) == 0) continue;

      // Se o ultimo caracter for diferente de um numero, entao remover ele da lista
      final ultimoCaracter = num.tryParse(valor.substring(valor.length - 1));
      if (ultimoCaracter == null) valor = valor.substring(0, valor.length - 1);
      double valorDouble;
      try {
        valorDouble = double.parse(valor);
        // Se nao deu erro, verificar se o 1o caracter é 0. Se sim, não considerar o valor
        if (valor.startsWith('0') == false &&
            valorDouble < 100000 &&
            valorDouble == quantidade) retorno = true;
      } on Exception catch (_) {
        // apenas descarta o valor
      }
    }
    return retorno;
  }

  double obtemQuantidade(String value, String cdProdutoEncontrado) {
    // O separador sera o caracter que envolve o codigo do produto encontrado
    var separador = obtemSeparador(value, cdProdutoEncontrado);
    List<String> valores = value.split(separador);
    List<double> qtdeValidas = [];

    for (String valor in valores) {
      // descarta o trecho com o codigo do produto encontrado
      if (valor.compareTo(cdProdutoEncontrado) == 0) continue;

      // Se o ultimo caracter for diferente de um numero, entao remover ele da lista
      final ultimoCaracter = num.tryParse(valor.substring(valor.length - 1));
      if (ultimoCaracter == null) valor = valor.substring(0, valor.length - 1);
      double valorDouble;
      try {
        valorDouble = double.parse(valor);
        // Se nao deu erro, verificar se o 1o caracter é 0. Se sim, não considerar o valor
        if (valor.startsWith('0') == false && valorDouble < 100000)
          qtdeValidas.add(valorDouble);
      } on Exception catch (_) {
        // apenas descarta o valor
      }
    }
    // Se nao encontrou valor pra quantidade
    //2022-01-25 - Flex solicitou que fosse considerado o primeiro valor numérico como quantidade (2a coluna)
    double retorno = 0;
    //if (qtdeValidas.isNotEmpty && qtdeValidas.length == 1) {
    if (qtdeValidas.isNotEmpty && qtdeValidas.length >= 1) {
      retorno = qtdeValidas[0];
    }

    return retorno;
  }

  String obtemProduto(String value, RealimentacaoDTO realimentacaoDTO) {
    String cdProdutoEncontrado = '';
    if (value.contains(realimentacaoDTO.cdProduto)) {
      cdProdutoEncontrado = realimentacaoDTO.cdProduto;
    } else {
      // Ordena os alternativos do maior para menor em termos do tamanho da string
      // isso eh importante pois pode haver alternativos contidos no codigo principal mas que são incompletos
      realimentacaoDTO.cdProdutoAlternativo
          .sort((a, b) => a.length.compareTo(b.length) * -1);

      // verificar se algum alternativo esta contido no reelid
      for (String cdprodutoAlternativo
          in realimentacaoDTO.cdProdutoAlternativo) {
        if (value.contains(cdprodutoAlternativo)) {
          cdProdutoEncontrado = cdprodutoAlternativo;
          break;
        }
      }
    }
    return cdProdutoEncontrado;
  }
}
