import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vfapp/components/customFieldCF.dart';
import 'package:vfapp/functions/funcoes.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/alimentacaoRest.dart';
import 'package:vfapp/models/mapaAlimentacaoRest.dart';
import 'package:vfapp/models/realimentacaoRest.dart';
import 'package:vfapp/pages/mensagemDialog.dart';
import 'package:vfapp/pages/alimentacao/alimentacaoConcluidaPage.dart';
import 'package:vfapp/pages/alimentacao/fieldMateriaPrimaEsperada.dart';
import 'package:vfapp/pages/alimentacao/fieldPosicao.dart';
import 'package:vfapp/pages/alimentacao/pasRestantesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* O objetivo dessa classe é criar o formulario da alimentacao
Esse formulario deverá guardar os dados alimentados em memoria. Enviando o resultado da alimentacao apenas no final
 */
class AlimentacaoForm extends StatefulWidget {
  final MapaAlimentacaoDTO
      mapaalimentacaodto; // contem o mapa original a ser realimentado
  final String cdpt;
  final AlimentacaoDTO
      alimentacaoDTO; // a alimentacao inicializada ja vem de AlimentacaoPage, pois se criasse no FOrm perderia o conteudo como refresh

  late RealimentacaoDTO realimentacaodto; // contem a alimentação corrente
  final ScrollController _scrollController = ScrollController();

  late List<double> qtdeValidas = [];

  late bool isRestaurouLeiturasSalvas = false;

  final int SITUACAO_VALIDADE_LOTE_OK = 1;
  final int SITUACAO_VALIDADE_LOTE_INCONSISTENTE = 2;
  final int SITUACAO_VALIDADE_LOTE_DATA_VENCIDA = 3;

  AlimentacaoForm(
      {Key? key,
      required this.mapaalimentacaodto,
      required this.cdpt,
      required this.alimentacaoDTO})
      : super(key: key);

  @override
  AlimentacaoFormState createState() {
    realimentacaodto = RealimentacaoDTO(
        cdPt: '',
        cdMapa: '',
        cdPa: '',
        cdProduto:
            ''); // usado apenas para inicializar o dto qdo nao tiver nenhuma posicao lida

    return AlimentacaoFormState();
  }

  // Metodo para adicionar na lista dos itens alimentados o item recem alimentado
  Future<void> addAlimentacao(AlimentacaoDTO alimentacaodto,
      RealimentacaoDTO realimentacaodto, bool isSucesso) async {
    // adiciona mais uma alimentacao a lista de alimentacoes ja realizadas
    print('addAlimentacao ${realimentacaodto.cdPa} com sucesso = ${isSucesso}');
    realimentacaodto.cdPt = alimentacaodto.cdPt;
    realimentacaodto.cdMapa = mapaalimentacaodto.cdMapa;
    realimentacaodto.isSucesso = isSucesso;
    realimentacaodto.dthrLeitura = DateTime.now();
    alimentacaodto.alimentacoes.add(realimentacaodto);

    /* Salvar em sharedpreferences a alimentacao  */
    String alimentacaojson = jsonEncode(alimentacaodto.toJson());
    print('alimentacaojson $alimentacaojson');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('alimentacao', alimentacaojson);
    print('salvando alimentacao $alimentacaojson');

    /* Salva tambem o mapa pois ele pode mudar. Temos que usar o original do inicio da alimentacao */
    String mapajson = jsonEncode(mapaalimentacaodto.toJson());
    print('salvando mapa $mapajson');
    prefs.setString('mapa', mapajson);
  }

  List<double> getQuantidades() {
    return this.qtdeValidas;
  }
}

class AlimentacaoFormState extends State<AlimentacaoForm> {
  final _formKey = GlobalKey<FormState>();
  final _controlerPosicao = TextEditingController();
  final _controlerReelId = TextEditingController();
  final _controlerQuantidade = TextEditingController();
  final _controlerMateriaPrimaEsperada = TextEditingController();

  final FocusNode _focoPosicao = FocusNode();
  final FocusNode _focoIdEmbalagem = FocusNode();
  final FocusNode _focoQuantidade = FocusNode();

  late List<String> pasRestantes =
      []; // contem os pas que ainda não foram alimentados. assim serão mostrados em forma de botao

  late bool isTecladoAtivo = VfApp.configuracao.configuracao.tecladoHabilitado;

  @override
  void initState() {
    super.initState();

    _focoPosicao.requestFocus();
  }

  int getQtAlimentadaSucesso() {
    int retorno = widget.mapaalimentacaodto.pas.length - pasRestantes.length;
    return retorno;
  }

  @override
  Widget build(BuildContext context) {
    /* Alessandre em 24-11-21. A arvore hierarquica da alimentação é AlimnetacaoPage, AlimentacaoPageState (statefull)
     chama AlimentacaoForm, AlimentacaoFormState (stateful)
      Ao chamar o setState em AlimentacaoFormState, foi feito a inicializacao do construtor em AlimentacaoPage. Fazendo isso
      o alimentacaoDTO está sendo zerado. Ainda não entendi se existe uma solução para evitar isso e deixar o setState atualizando
      apenas AlimentacaoFormState. Assim, o workaround desse problema de limpeza do alimentacaodto foi salvar as alimentacoes em prefered
      shared e restaurar nesse momento.
     */
    avaliarRestauracaoAlimentacao();

    print(
        'quantidade de alimentacoes antes do build ${widget.alimentacaoDTO.alimentacoes.length}');
    // Inicializa o pasRestantes com os PAs que ainda não foram alimentados
    atualizarPasRestantes();
    print(
        'quantidade de alimentacoes DEPOIS do build ${widget.alimentacaoDTO.alimentacoes.length}');

    if (VfApp.configuracao.configuracao.posicaoautomatica) {
      _focoIdEmbalagem.requestFocus();
    }
    return WillPopScope(
      onWillPop: () async {
        Widget continueButton = TextButton(
          child: Text("Sim"),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );

        if (pasRestantes.isNotEmpty) {
          MensagemDialog.showSimOuNao(
            context: context,
            titulo: 'Alimentação pendente',
            mensagem: 'A alimentação será perdida. Sair?',
            continueButton: continueButton,
          );
        } else {
          MensagemDialog.showSimOuNao(
            context: context,
            titulo: 'Alimentação NÃO FINALIZADA',
            mensagem: 'A alimentação será perdida. Sair?',
            continueButton: continueButton,
          );
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('VF Alimentação')),
        body: SingleChildScrollView(
          controller: widget._scrollController,
          padding: EdgeInsets.only(top: 10),
          child: FocusScope(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Text('Posto ${widget.cdpt}'),
                  Text('Mapa ${widget.mapaalimentacaodto.cdMapa}'),
                  FieldPosicao(
                    controlerPosicao: _controlerPosicao,
                    controlerMateriaPrimaEsperada:
                        _controlerMateriaPrimaEsperada,
                    controllerReelId: _controlerReelId,
                    controllerQuantidade: _controlerQuantidade,
                    focoPosicao: _focoPosicao,
                    focoIdEmbalagem: _focoIdEmbalagem,
                    refresh: refresh,
                    inverterTecladoAtivo: inverterTecladoAtivo,
                    isTecladoAtivo: getIsTecladoAtivo,
                    mapa: widget.mapaalimentacaodto,
                    alimentacaodto: widget.alimentacaoDTO,
                  ),
                  FieldMateriaPrimaEsperada(
                      controlerMateriaPrimaEsperada:
                          _controlerMateriaPrimaEsperada),
                  // FieldIdEmbalagem(
                  //   controlerReelId: _controlerReelId,
                  //   controlerQuantidade: _controlerQuantidade,
                  //   controlerPosicao: _controlerPosicao,
                  //   controlerMateriaPrimaEsperada:
                  //       _controlerMateriaPrimaEsperada,
                  //   focoIdEmbalagem: _focoIdEmbalagem,
                  //   focoQuantidade: _focoQuantidade,
                  //   focoPosicao: _focoPosicao,
                  //   realimentacaodto: widget.realimentacaodto,
                  //   // dados da posicao atual para uso na validacao
                  //   alimentacaodto: widget.alimentacaoDTO,
                  //   refresh: refresh,
                  //   setQuantidade: setQuantidade,
                  //   addAlimentacao: widget.addAlimentacao,
                  //   inverterTecladoAtivo: inverterTecladoAtivo,
                  //   isTecladoAtivo: getIsTecladoAtivo,
                  // ),
                  CustomFieldCF(
                    controller: _controlerReelId,
                    isTecladoAtivo: isTecladoAtivo,
                    foco: _focoIdEmbalagem,
                    ativaDesativaTeclado: ativaDesativaTeclado,
                    botaoSubmitted: idEmbalagemSubmitted,
                    tituloText: VfApp.configuracao.configuracao.lerid
                        ? 'Id Embalagem'
                        : 'Produto CB',
                    tituloHint: VfApp.configuracao.configuracao.lerid
                        ? 'Ler id embalagem'
                        : 'Ler CB Produto',
                  ),
                  CustomFieldCF(
                    controller: _controlerQuantidade,
                    isTecladoAtivo: isTecladoAtivo,
                    foco: _focoQuantidade,
                    ativaDesativaTeclado: ativaDesativaTeclado,
                    botaoSubmitted: quantidadeSubmitted,
                    tituloText: 'Quantidade',
                    tituloHint: 'Ler quantidade embalagem',
                  ),

                  // Alessandre: em 22-11-21 comentei o trecho abaixo pois a qtde nao deve abrir um menu com as possiveis qtde pro operador
                  // escolher, pois isso trava o processo. A alternativa foi ler outro CB com a qtde
                  // FieldQuantidade(
                  //     controlerPosicao: _controlerPosicao,
                  //     controlerReelId: _controlerReelId,
                  //     controlerQuantidade: _controlerQuantidade,
                  //     controlerMateriaPrimaEsperada:
                  //         _controlerMateriaPrimaEsperada,
                  //     focoPosicao: _focoPosicao,
                  //     focoQuantidade: _focoQuantidade,
                  //     refresh: refresh,
                  //     addAlimentacao: widget.addAlimentacao,
                  //     getQuantidades: widget.getQuantidades,
                  //     alimentacaodto: widget.alimentacaoDTO,
                  //     realimentacaodto: widget.realimentacaodto,
                  //     inverterTecladoAtivo: inverterTecladoAtivo,
                  //     isTecladoAtivo: getIsTecladoAtivo,
                  // ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // solic flex: 0.11
                        ElevatedButton(
                          onPressed: () {
                            botaoFinalizarAlimentacao();
                          },
                          child: const Text('Finalizar Alimentação'),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            _controlerPosicao.text = '';
                            _controlerMateriaPrimaEsperada.text = '';
                            _controlerReelId.text = '';
                            _controlerQuantidade.text = '';
                            _focoPosicao.requestFocus();
                          },
                          child: const Text('Limpar'),
                        ),
                      ]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Abaixo PAs que faltam alimentar ${getQtAlimentadaSucesso()} / ${widget.mapaalimentacaodto.pas.length}'),
                  ),
                  PasRestantesPage(
                    pasRestantes: pasRestantes,
                    controlerPosicao: _controlerPosicao,
                    refresh: refresh,
                    scrollController: widget._scrollController,
                    controlerQuantidade: _controlerQuantidade,
                    controlerIdEmbalagem: _controlerReelId,
                    focoIdEmbalagem: _focoIdEmbalagem,
                    autorizarAlimentacao:
                        realizaAlimentacaoAutorizadaManualmente,
                    cdpt: widget.cdpt,
                    cdmapa: widget.mapaalimentacaodto.cdMapa,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void atualizarPasRestantes() {
    // Limpa o vetor dos PAs restantes para atualizar com novos valores, considerando o que ja foi aliementado com suesso
    pasRestantes.clear();

    // Inicializa o pasRestantes com os PAs que ainda não foram alimentados
    widget.mapaalimentacaodto.pas.sort((a, b) => a.ordem.compareTo(b.ordem));


    /* Alessandre em 20-06-22 verifica se a conferencia assume automaticamente a proxima posicao. Se sim. ja inicializa
      a posicao pra pedir a leitura do reelid
       */
    bool isAssumirPrimeiroPA = VfApp.configuracao.configuracao.posicaoautomatica;



    bool isPaValido = false;
    for (RealimentacaoDTO pamapa in widget.mapaalimentacaodto.pas) {

      // tenho que pegar o conteudo do campo posicao, e atualizar o id esperado
      // e realimentacaodto com a posicao que sera alimentada
      if (_controlerPosicao.text.isNotEmpty) {
        if (_controlerPosicao.text.compareTo(pamapa.cdPa) == 0) {
          this.widget.realimentacaodto = pamapa;
          _controlerMateriaPrimaEsperada.text = pamapa.cdProduto;
          isPaValido = true;
          widget.realimentacaodto = pamapa; // em realimentacaodto fica os dados da posicao lida
        }
      }

      bool isExiste = false;
      for (RealimentacaoDTO paalimentado
          in widget.alimentacaoDTO.alimentacoes) {
        // print('comparando pamapa.cdPa ${pamapa.cdPa} com paalimentado.cdPa ${paalimentado.cdPa} sucessoAlimentado ${paalimentado.isSucesso}');
        if (pamapa.cdPa.compareTo(paalimentado.cdPa) == 0 &&
            paalimentado.isSucesso) {
          isExiste = true;
        }
      }
      if (isExiste == false) {
        pasRestantes.add(pamapa.cdPa);
        if (isAssumirPrimeiroPA) {
          _controlerPosicao.text = pamapa.cdPa;
          this.widget.realimentacaodto = pamapa;
          _controlerMateriaPrimaEsperada.text = pamapa.cdProduto;
          isPaValido = true;
          widget.realimentacaodto = pamapa; // em realimentacaodto fica os dados da posicao lida
          isAssumirPrimeiroPA = false;
        }
      }
    }

    // print('qt em pasRestantes.lenght = ${pasRestantes.length}');
  }

  // Metodo para reexecutar o build
  void refresh() {
    setState(() {});
  }

  void setQuantidade(List<double> valores) {
    widget.qtdeValidas = valores;
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

  String obtemProduto(String value, RealimentacaoDTO realimentacaoDTO) {
    String cdProdutoEncontrado = '';
    if (value.contains(realimentacaoDTO.cdProduto)) {
      print('obtemProduto value $value contem ${realimentacaoDTO.cdProduto}');
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
          print(
              'obtemProduto em alternativo value $value contem $cdprodutoAlternativo');
          cdProdutoEncontrado = cdprodutoAlternativo;
          break;
        }
      }
    }
    return cdProdutoEncontrado;
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
    double retorno = 0;

    //2022-01-25 - Flex solicitou que fosse considerado o primeiro valor numérico como quantidade (2a coluna)
    //if (qtdeValidas.isNotEmpty && qtdeValidas.length == 1) {
    if (qtdeValidas.isNotEmpty && qtdeValidas.length >= 1) {
      retorno = qtdeValidas[0];
    } else {
      // Alessandre em 20-06-22 temporariamente para a SEMP, obter a qtde a partir da mascara ------?????
      // Entretanto, essa mascarada deverá vim da RN
      try {
        print("value = $value");
        String qtdeMascara = value.substring(6, 10);
        print("qtdeMascara= $qtdeMascara");
        retorno = double.parse(qtdeMascara);
        print("retorno=$retorno");
      } on Exception catch (_) {
        print("erro");
        retorno = 0;
      }
    }

    return retorno;
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

  quantidadeSubmitted() {
    String cdProdutoEncontrado =
        obtemProduto(_controlerReelId.text, widget.realimentacaodto);
    double quantidade =
        obtemQuantidade(_controlerQuantidade.text, cdProdutoEncontrado);

    bool isSucesso = true;

    // Se a quantidade obtida for mamior que 0 eh pq encontrou um valor valido na string lida no CB. Mas
    // devemos avaliar se esse valor está presente no cb principal. Se nao estiver a qtde eh invalida
    if (VfApp.configuracao.configuracao.lerid &&
        (reelIDContemQuantidade(
                    _controlerReelId.text, quantidade, cdProdutoEncontrado) ==
                false ||
            quantidade <= 0)) {
      MensagemDialog.showMensagem(context, 'Quantidade desconhecida',
          'Esse CB não contém a quantidade válida');
      _controlerQuantidade.text = '';
    } else {
      int situacaoLote =
          getStatusValidadeLote(_controlerReelId.text, cdProdutoEncontrado);

      if (situacaoLote == widget.SITUACAO_VALIDADE_LOTE_OK) {
        // Add alimentação
        widget.realimentacaodto.reelId = _controlerReelId.text;
        widget.realimentacaodto.qtAlimentada = quantidade;
        widget.addAlimentacao(
            widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);

        // avaliar se finaliza a alimentacao
        // Altualiza pasPendentes para avaliar se terminou a alimentacao
        atualizarPasRestantes();

        // Verifica se a alimentação está completa. Se sim, entao chamar botão finalizar alimentacao
        int qtdeAlimentadaSucesso = getQtAlimentadaSucesso();
        print('qtdeAlimentadaSucesso $qtdeAlimentadaSucesso');
        if (qtdeAlimentadaSucesso == widget.mapaalimentacaodto.pas.length) {
          //2022-01-25 - Flex que ocorra a finalização somente quanto clicar no botão.
          // solic flex: 0.11
          botaoFinalizarAlimentacao();
        } else {
          // Limpa e foco na posicao
          _controlerQuantidade.text = '';
          _controlerReelId.text = '';
          _controlerPosicao.text = '';
          _controlerMateriaPrimaEsperada.text = '';
          _focoPosicao.requestFocus();
          refresh();
        }
      } else {
        widget.realimentacaodto.reelId = _controlerReelId.text;
        widget.realimentacaodto.qtAlimentada = 0;
        bool isSucesso = false;
        widget.addAlimentacao(
            widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);

        _controlerReelId.text = '';
        _focoIdEmbalagem.requestFocus();
      }

      // Alessandre o codigo abaixo foi comentado pois veio da realimentacao para servir como referencia.e xcluir apos alimentacao ok
      // realimentarPostoPageState.quantidade = quantidade;
      // realimentarPostoPageState.isSalvar = quantidade > 0;
      // realimentarPostoPageState.isSucessoRealimentar = quantidade > 0;
      // _controlerQuantidade.text = quantidade.toString();
      // realimentarPostoPageState.refreshRest();
    }
  }

  int getStatusValidadeLote(String value, String cdProdutoEncontrado) {
    int retorno = widget.SITUACAO_VALIDADE_LOTE_OK;

    if (VfApp.configuracao.configuracao.lerid) {
      if (Funcoes.reelIDValidadeLoteConsistente(
          _controlerReelId.text, cdProdutoEncontrado)) {
        if (Funcoes.reelIsTemValidadeLote(
            _controlerReelId.text, cdProdutoEncontrado)) {
          // verifica se a data é valida (menor que a data atual)
          DateTime dtLote = Funcoes.getRellDataLote(
              _controlerReelId.text, cdProdutoEncontrado);

          if (!Funcoes.isReelDataLoteValida(dtLote)) {
            retorno = widget.SITUACAO_VALIDADE_LOTE_DATA_VENCIDA;

            var formatoData = DateFormat('yyyy-MM-dd');

            MensagemDialog.showMensagem(
                context,
                'Lote da materia-prima vencido em ' +
                    formatoData.format(dtLote),
                '');
            _controlerReelId.text = '';
          }
        }
      } else {
        // se a validade do lote (formato) estiver inconsistente, ainda assim será salvo posteriormente
        retorno = widget.SITUACAO_VALIDADE_LOTE_INCONSISTENTE;

        MensagemDialog.showMensagem(
            context, 'Validade do lote não é uma data valida', '');
        _controlerReelId.text = '';
      }
    }

    return retorno;
  }

  int isReelIdValido(String value, String cdProdutoEncontrado) {
    // O separador sera o caracter que envolve o codigo do produto encontrado
    var separador = obtemSeparador(value, cdProdutoEncontrado);
    List<String> valores = value.split(separador);
    print('isReelIdValido separador = $separador em value  = $value');
    return valores.length; // se tiver mais de 2 segmentos entao considerar
  }

  idEmbalagemSubmitted() {
    String cdProdutoEncontrado = obtemProduto(_controlerReelId.text, widget.realimentacaodto);

    int qtItens = isReelIdValido(_controlerReelId.text, cdProdutoEncontrado);

    // Qt Itens Esperado depende se o ID da embalagem sera lido ou nao. Qdo nao for lido basta ter 0 ou 1 itens para aceitar
    int qtItensEsperado = VfApp.configuracao.configuracao.lerid ? 3 : 1;

    // Se nao existe um produto encontrado, então nao aceitar o reelid
    if (cdProdutoEncontrado.isEmpty || qtItens < qtItensEsperado) {
      if (cdProdutoEncontrado.isEmpty)
        MensagemDialog.showMensagem(context, 'Alimentação ERRADA',
            'Produto esperado [${_controlerMateriaPrimaEsperada.text}] não encontrado em ${_controlerReelId.text}');
      else
        MensagemDialog.showMensagem(context, 'Alimentação ERRADA',
            'Id Embalagem inválido. Produto encontrado $cdProdutoEncontrado, mas qtItens ${qtItens} no id ${_controlerReelId.text}');

      widget.realimentacaodto.reelId = _controlerReelId.text;
      widget.realimentacaodto.qtAlimentada = 0;
      bool isSucesso = false;
      widget.addAlimentacao(widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);

      _controlerReelId.text = '';
      _focoIdEmbalagem.requestFocus();

      return;
    }

    // teste validade do lote
    int situacaoLote =
        getStatusValidadeLote(_controlerReelId.text, cdProdutoEncontrado);

    if (situacaoLote == widget.SITUACAO_VALIDADE_LOTE_OK) {
      double quantidade = obtemQuantidade(_controlerReelId.text, cdProdutoEncontrado);

      // se obteve a quantidade marcar como true a alimentacao
      if (quantidade > 0) {
        // Add alimentação com sucesso
        bool isSucesso = true;

        //2022-01-19 - Flex solicitou que fosse atribuída quantidade que consta no código de barras
        _controlerQuantidade.text = quantidade.toInt().toString();

        widget.realimentacaodto.cdProdutoLido = cdProdutoEncontrado;
        widget.realimentacaodto.reelId = _controlerReelId.text;
        widget.realimentacaodto.qtAlimentada = quantidade;
        widget.addAlimentacao(
            widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);

        // Altualiza pasPendentes para avaliar se terminou a alimentacao
        print(
            'pasRestantes Antes de atualizar restantes = ${pasRestantes.length}');
        atualizarPasRestantes();
        print(
            'pasRestantes DEPOIS de atualizar restantes = ${pasRestantes.length}');

        // Verifica se a alimentação está completa. Se sim, entao chamar botão finalizar alimentacao
        int qtdeAlimentadaSucesso = getQtAlimentadaSucesso();
        print('qtdeAlimentadaSucesso $qtdeAlimentadaSucesso');
        if (qtdeAlimentadaSucesso == widget.mapaalimentacaodto.pas.length) {
          //2022-01-19 - Flex solicitou que fosse atribuída quantidade que consta no código de barras
          // solic flex: 0.11
          botaoFinalizarAlimentacao();
        } else {
          // Limpa e foco na posicao
          _controlerQuantidade.text = '';
          _controlerReelId.text = '';
          _controlerPosicao.text = '';
          _controlerMateriaPrimaEsperada.text = '';
          _focoPosicao.requestFocus();
          refresh();
        }
      } else {
        // vamos pedir a quantidade pois nao foi identificada
        _focoQuantidade.requestFocus();
      }
    } else {
      widget.realimentacaodto.reelId = _controlerReelId.text;
      widget.realimentacaodto.qtAlimentada = 0;
      bool isSucesso = false;
      widget.addAlimentacao(
          widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);

      _controlerReelId.text = '';
      _focoIdEmbalagem.requestFocus();
    }
  }

  void botaoFinalizarAlimentacao() {
    // Avaliar se existe alguma pendencia na alimentacao. Se existir, perguntar se deseja abortar
    if (pasRestantes.isNotEmpty) {
      MensagemDialog.showMensagem(context, 'Alimentação incompleta',
          'Alimentações pendentes. No final da tela relação das pendencias.');
      return;
    }

    // se nao existir, registrar a alimentação
    widget.alimentacaoDTO.isSucesso = true;

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              AlimentacaoConcluidaPage(alimentacaodto: widget.alimentacaoDTO)),
    );
  }

  /* O objetivo desse metodo eh restaurar a ultima alimentacao registrada no dispositivo
  e verificar se ela corresponde ao posto e mapa corrente alimentado. Se sim, utilizar todos os pas salvos
   */
  void avaliarRestauracaoAlimentacao() async {
    // Restaura a alimentação salva em arquivo somente se a alimentacao em memoria estiver vazia.
    if (widget.alimentacaoDTO.alimentacoes.isEmpty &&
        widget.isRestaurouLeiturasSalvas == false) {
      // Restaura a alimentacao que foi salva anteriormente
      final prefs = await SharedPreferences.getInstance();
      String? alimentacaojson = prefs.getString('alimentacao');
      print('restore alimentacaojson $alimentacaojson');
      final dynamic json = jsonDecode(alimentacaojson!);

      AlimentacaoDTO alimentacaoAux = AlimentacaoDTO.fromJson(json);

      // Avalia se o mapa e posto salvo sao os mesmos carregados na memoria
      // se for o mesmo e houver alimentacao salva entao perguntar se deseja restaurar a alimentacao
      if (alimentacaoAux.cdMapa.compareTo(widget.alimentacaoDTO.cdMapa) == 0 &&
          alimentacaoAux.cdPt.compareTo(widget.alimentacaoDTO.cdPt) == 0 &&
          alimentacaoAux.alimentacoes.isNotEmpty) {
        Widget naoButton = TextButton(
          child: Text("Não"),
          onPressed: () {
            Navigator.pop(context);
            refresh();
            widget.isRestaurouLeiturasSalvas = true;
          },
        );

        // Perguntar se deseja utilizar os dados salvos
        Widget continueButton = TextButton(
          child: Text("Sim"),
          onPressed: () {
            restaurarAlimentacao(alimentacaoAux);
          },
        );

        int qtComSucesso = 0;
        List<String> cdpaComSucesso = [];
        for (RealimentacaoDTO dto in alimentacaoAux.alimentacoes) {
          if (dto.isSucesso && cdpaComSucesso.contains(dto.cdPa) == false) {
            qtComSucesso++;
            cdpaComSucesso.add(dto.cdPa);
          } else
            print('alimentacao salva com sucesso false');
        }

        MensagemDialog.showSimOuNao(
          context: context,
          titulo: 'Alimentação PENDENTE',
          mensagem: 'Alimentação com $qtComSucesso leituras. Restaurar?',
          continueButton: continueButton,
          naoButton: naoButton,
        );
      } //
    }
  }

  /* Metodo para autorizar a alimentacao manual de um PA
  Isso significa que a etiqueta nao existe
   */
  void realizaAlimentacaoAutorizadaManualmente(String cdpa, String matricula) {
    bool isSucesso = true;
    widget.realimentacaodto = RealimentacaoDTO(
        cdPt: widget.cdpt, cdMapa: widget.mapaalimentacaodto.cdMapa);
    widget.realimentacaodto.cdProdutoAlternativo = [];
    widget.realimentacaodto.cdPa = cdpa;
    widget.realimentacaodto.cdProduto = getProdutoDoPa(cdpa);
    widget.realimentacaodto.cdProdutoLido = 'MANUALMENTE';
    widget.realimentacaodto.reelId = 'ALIMENTAÇÃO MANUAL';
    widget.realimentacaodto.qtAlimentada = 0;
    widget.addAlimentacao(
        widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);
    refresh();
  }

  restaurarAlimentacao(AlimentacaoDTO alimentacaoAux) {
    Navigator.pop(context);
    widget.alimentacaoDTO.alimentacoes.addAll(alimentacaoAux.alimentacoes);
    refresh();
    widget.isRestaurouLeiturasSalvas = true;
  }

  String getProdutoDoPa(String cdpa) {
    String retorno = '';
    for (RealimentacaoDTO dto in widget.mapaalimentacaodto.pas) {
      if (dto.cdPa.compareTo(cdpa) == 0) retorno = dto.cdProduto;
    }
    return retorno;
  }
}
