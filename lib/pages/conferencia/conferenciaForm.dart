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
import 'package:vfapp/pages/alimentacao/fieldMateriaPrimaEsperada.dart';
import 'package:vfapp/pages/alimentacao/pasRestantesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/pages/conferencia/conferenciaConcluidaPage.dart';

/* O objetivo dessa classe é criar o formulario da alimentacao
Esse formulario deverá guardar os dados alimentados em memoria. Enviando o resultado da alimentacao apenas no final
 */
class ConferenciaForm extends StatefulWidget {
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

  ConferenciaForm(
      {Key? key,
      required this.mapaalimentacaodto,
      required this.cdpt,
      required this.alimentacaoDTO})
      : super(key: key);

  @override
  ConferenciaFormState createState() {
    realimentacaodto = RealimentacaoDTO(
        cdPt: '',
        cdMapa: '',
        cdPa: '',
        cdProduto:
            ''); // usado apenas para inicializar o dto qdo nao tiver nenhuma posicao lida

    return ConferenciaFormState();
  }

  // Metodo para adicionar na lista dos itens alimentados o item recem alimentado
  Future<void> addConferencia(AlimentacaoDTO alimentacaodto,
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
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('conferencia', alimentacaojson);

    /* Salva tambem o mapa pois ele pode mudar. Temos que usar o original do inicio da alimentacao */
    String mapajson = jsonEncode(mapaalimentacaodto.toJson());
    prefs.setString('conferenciamapa', mapajson);
  }
}

class ConferenciaFormState extends State<ConferenciaForm> {
  final _formKey = GlobalKey<FormState>();
  final _controlerPosicao = TextEditingController();
  final _controlerReelId = TextEditingController();
  final _controlerMateriaPrimaEsperada = TextEditingController();

  final FocusNode _focoPosicao = FocusNode();
  final FocusNode _focoIdEmbalagem = FocusNode();

  late List<String> pasRestantes =
      []; // contem os pas que ainda não foram alimentados. assim serão mostrados em forma de botao

  late bool isTecladoAtivo = VfApp.configuracao.configuracao.tecladoHabilitado;

  @override
  void initState() {
    super.initState();

    _focoPosicao.requestFocus();
  }

  int getQtConferenciaSucesso() {
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
    avaliarRestauracaoConferencia();

    // Inicializa o pasRestantes com os PAs que ainda não foram alimentados
    atualizarPasRestantes();

    var paRestatePage = new PasRestantesPage(
      pasRestantes: pasRestantes,
      controlerPosicao: _controlerPosicao,
      refresh: refresh,
      scrollController: widget._scrollController,
      controlerQuantidade: _controlerReelId,
      controlerIdEmbalagem: _controlerReelId,
      focoIdEmbalagem: _focoIdEmbalagem,
      autorizarAlimentacao: realizaConferenciaAutorizadaManualmente,
      cdpt: widget.cdpt,
      cdmapa: widget.mapaalimentacaodto.cdMapa,
    );

    if (VfApp.configuracao.configuracao.posicaoautomatica) {
      paRestatePage.selecionarPa(0);
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
            titulo: 'Conferência pendente',
            mensagem: 'A conferência será perdida. Sair?',
            continueButton: continueButton,
          );
        } else {
          MensagemDialog.showSimOuNao(
            context: context,
            titulo: 'Conferência NÃO FINALIZADA',
            mensagem: 'A conferência será perdida. Sair?',
            continueButton: continueButton,
          );
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('VF Conferência')),
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
                  CustomFieldCF(
                    controller: _controlerPosicao,
                    isTecladoAtivo: isTecladoAtivo,
                    foco: _focoPosicao,
                    ativaDesativaTeclado: ativaDesativaTeclado,
                    botaoSubmitted: posicaoSubmitted,
                    tituloText: 'Posição',
                    tituloHint: 'Ler posição',
                  ),
                  FieldMateriaPrimaEsperada(
                      controlerMateriaPrimaEsperada:
                          _controlerMateriaPrimaEsperada),
                  CustomFieldCF(
                    controller: _controlerReelId,
                    isTecladoAtivo: isTecladoAtivo,
                    foco: _focoIdEmbalagem,
                    ativaDesativaTeclado: ativaDesativaTeclado,
                    botaoSubmitted: idEmbalagemSubmitted,
                    tituloText: 'Produto',
                    tituloHint: 'Ler CB do produto',
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            botaoFinalizarConferencia();
                          },
                          child: const Text('Finalizar conferência'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _controlerPosicao.text = '';
                            _controlerMateriaPrimaEsperada.text = '';
                            _controlerReelId.text = '';
                            _focoPosicao.requestFocus();
                          },
                          child: const Text('Limpar'),
                        ),
                      ]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Abaixo PAs que faltam conferir ${getQtConferenciaSucesso()} / ${widget.mapaalimentacaodto.pas.length}'),
                  ),
                  paRestatePage,
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
      for (RealimentacaoDTO paalimentado in widget.alimentacaoDTO.alimentacoes) {
        // print('comparando pamapa.cdPa ${pamapa.cdPa} com paalimentado.cdPa ${paalimentado.cdPa} sucessoAlimentado ${paalimentado.isSucesso}');
        if (pamapa.cdPa.compareTo(paalimentado.cdPa) == 0 && paalimentado.isSucesso) {
          isExiste = true;
        }
      }
      if (isExiste == false) {
        pasRestantes.add(pamapa.cdPa);

        if (isAssumirPrimeiroPA) {
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

  int isReelIdValido(String value, String cdProdutoEncontrado) {
    // O separador sera o caracter que envolve o codigo do produto encontrado
    var separador = obtemSeparador(value, cdProdutoEncontrado);
    List<String> valores = value.split(separador);
    print('isReelIdValido separador = $separador em value  = $value');
    return valores.length; // se tiver mais de 2 segmentos entao considerar
  }

  void posicaoSubmitted() async {
    if (_controlerPosicao.text.isEmpty) {
      _controlerMateriaPrimaEsperada.text = '';
      _controlerReelId.text = '';
    } else {
      /* Avaliar se a posicao lida existe no mapa */
      bool isExiste = false;
      for (RealimentacaoDTO dto in widget.mapaalimentacaodto.pas) {
        if (dto.cdPa.compareTo(_controlerPosicao.text) == 0) {
          isExiste = true;
          break;
        }
      }
      if (isExiste) {
        /* Avaliar se a posicao já foi alimentada com sucesso. Se sim, avisar
         */
        isExiste = false;

        for (RealimentacaoDTO dto in widget.alimentacaoDTO.alimentacoes) {
          if (dto.cdPa.compareTo(_controlerPosicao.text) == 0 &&
              dto.isSucesso) {
            isExiste = true;
            break;
          }
        }

        if (isExiste) {
          MensagemDialog.showMensagem(
              context, 'Posição ${_controlerPosicao.text}', 'já conferida.');
          _controlerPosicao.text = '';
          _focoPosicao.requestFocus();
        } else {
          _focoIdEmbalagem.requestFocus();
          refresh();
        }
      } else {
        MensagemDialog.showMensagem(context, 'Posição ${_controlerPosicao.text}',
            'desconhecida. Tentar novamente.');
        _controlerPosicao.text = '';
        _focoPosicao.requestFocus();
      }
    }
  }

  idEmbalagemSubmitted() {
    String cdProdutoEncontrado =
        obtemProduto(_controlerReelId.text, widget.realimentacaodto);

    int qtItens = isReelIdValido(_controlerReelId.text, cdProdutoEncontrado);

    // Se nao existe um produto encontrado, então nao aceitar o reelid
    if (cdProdutoEncontrado.isEmpty) {
      if (cdProdutoEncontrado.isEmpty)
        MensagemDialog.showMensagem(context, 'Conferência ERRADA',
            'Produto esperado [${_controlerMateriaPrimaEsperada.text}] não encontrado em ${_controlerReelId.text}');
      else
        MensagemDialog.showMensagem(context, 'Conferência ERRADA',
            'Id Embalagem inválido. Produto encontrado $cdProdutoEncontrado, mas qtItens ${qtItens} no id ${_controlerReelId.text}');

      widget.realimentacaodto.reelId = _controlerReelId.text;
      widget.realimentacaodto.qtAlimentada = 0;
      bool isSucesso = false;
      widget.addConferencia(
          widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);

      _controlerReelId.text = '';
      _focoIdEmbalagem.requestFocus();

      return;
    }

    int situacaoLote =
        getStatusValidadeLote(_controlerReelId.text, cdProdutoEncontrado);

    if (situacaoLote == widget.SITUACAO_VALIDADE_LOTE_OK) {
      // Add alimentação com sucesso
      bool isSucesso = true;
      widget.realimentacaodto.cdProdutoLido = cdProdutoEncontrado;
      widget.realimentacaodto.reelId = _controlerReelId.text;
      widget.realimentacaodto.qtAlimentada = 0;
      widget.addConferencia(
          widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);

      // Altualiza pasPendentes para avaliar se terminou a alimentacao
      atualizarPasRestantes();

      // Verifica se a alimentação está completa. Se sim, entao chamar botão finalizar alimentacao
      int qtdeAlimentadaSucesso = getQtConferenciaSucesso();
      if (qtdeAlimentadaSucesso == widget.mapaalimentacaodto.pas.length) {
        botaoFinalizarConferencia();
      } else {
        // Limpa e foco na posicao
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
      widget.addConferencia(
          widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);

      _controlerReelId.text = '';
      _focoIdEmbalagem.requestFocus();
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

  void botaoFinalizarConferencia() {
    // Avaliar se existe alguma pendencia na alimentacao. Se existir, perguntar se deseja abortar
    if (pasRestantes.isNotEmpty) {
      MensagemDialog.showMensagem(context, 'Conferência incompleta',
          'Conferências pendentes. No final da tela relação das pendencias.');
      return;
    }

    String cdProdutoEncontrado =
        obtemProduto(_controlerReelId.text, widget.realimentacaodto);
    int situacaoLote =
        getStatusValidadeLote(_controlerReelId.text, cdProdutoEncontrado);

    if (situacaoLote == widget.SITUACAO_VALIDADE_LOTE_OK) {
      // se nao existir, registrar a alimentação
      widget.alimentacaoDTO.isSucesso = true;

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ConferenciaConcluidaPage(
                alimentacaodto: widget.alimentacaoDTO)),
      );
    } else {
      // nada
    }
  }

  /* O objetivo desse metodo eh restaurar a ultima alimentacao registrada no dispositivo
  e verificar se ela corresponde ao posto e mapa corrente alimentado. Se sim, utilizar todos os pas salvos
   */
  void avaliarRestauracaoConferencia() async {
    // Restaura a alimentação salva em arquivo somente se a alimentacao em memoria estiver vazia.
    if (widget.alimentacaoDTO.alimentacoes.isEmpty &&
        widget.isRestaurouLeiturasSalvas == false) {
      // Restaura a alimentacao que foi salva anteriormente
      final prefs = await SharedPreferences.getInstance();
      String? alimentacaojson = prefs.getString('conferencia');
      final dynamic json = jsonDecode(alimentacaojson!);

      AlimentacaoDTO alimentacaoAux = AlimentacaoDTO.fromJson(json);

      // Avalia se o mapa e posto salvo sao os mesmos carregados na memoria
      // se for o mesmo e houver alimentacao salva entao perguntar se deseja restaurar a alimentacao
      if (alimentacaoAux.cdMapa.compareTo(widget.alimentacaoDTO.cdMapa) == 0 &&
          alimentacaoAux.cdPt.compareTo(widget.alimentacaoDTO.cdPt) == 0 &&
          alimentacaoAux.alimentacoes.isNotEmpty) {
        // Perguntar se deseja utilizar os dados salvos
        Widget continueButton = TextButton(
          child: Text("Sim"),
          onPressed: () {
            restaurarConferencia(alimentacaoAux);
          },
        );

        Widget naoButton = TextButton(
          child: Text("Não"),
          onPressed: () {
            Navigator.pop(context);
            refresh();
            widget.isRestaurouLeiturasSalvas = true;
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
          titulo: 'Conferência PENDENTE',
          mensagem: 'Conferência com $qtComSucesso leituras. Restaurar?',
          continueButton: continueButton,
          naoButton: naoButton,
        );
      } //
    }
  }

  /* Metodo para autorizar a alimentacao manual de um PA
  Isso significa que a etiqueta nao existe
   */
  void realizaConferenciaAutorizadaManualmente(String cdpa, String matricula) {
    bool isSucesso = true;
    widget.realimentacaodto = RealimentacaoDTO(
        cdPt: widget.cdpt, cdMapa: widget.mapaalimentacaodto.cdMapa);
    widget.realimentacaodto.cdProdutoAlternativo = [];
    widget.realimentacaodto.cdPa = cdpa;
    widget.realimentacaodto.cdProduto = getProdutoDoPa(cdpa);
    widget.realimentacaodto.cdProdutoLido = 'MANUALMENTE';
    widget.realimentacaodto.reelId = 'CONFERÊNCIA MANUAL';
    widget.realimentacaodto.qtAlimentada = 0;
    widget.addConferencia(
        widget.alimentacaoDTO, widget.realimentacaodto, isSucesso);
    refresh();
  }

  restaurarConferencia(AlimentacaoDTO alimentacaoAux) {
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
