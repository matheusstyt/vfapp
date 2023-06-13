import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vfapp/main.dart';
import 'package:vfapp/models/alimentacaoRest.dart';
import 'package:vfapp/models/mapaAlimentacaoRest.dart';
import 'package:vfapp/models/realimentacaoRest.dart';
import 'package:vfapp/pages/mensagemDialog.dart';

class FieldPosicao extends StatelessWidget {
  FieldPosicao({
    Key? key,
    required TextEditingController controlerPosicao,
    required TextEditingController controlerMateriaPrimaEsperada,
    required TextEditingController controllerReelId,
    required TextEditingController controllerQuantidade,
    required FocusNode focoPosicao,
    required FocusNode focoIdEmbalagem,
    required Function refresh,
    required Function isTecladoAtivo,
    required Function inverterTecladoAtivo,
    required MapaAlimentacaoDTO mapa,
    required AlimentacaoDTO alimentacaodto,
  })  : _controlerPosicao = controlerPosicao,
        _controlerMateriaPrimaEsperada = controlerMateriaPrimaEsperada,
        _controlerReelId = controllerReelId,
        _controlerQuantidade = controllerQuantidade,
        _focoPosicao = focoPosicao,
        _focoIdEmbalagem = focoIdEmbalagem,
        _refresh = refresh,
        _isTecladoAtivo = isTecladoAtivo,
        _inverterTecladoAtivo = inverterTecladoAtivo,
        _mapa = mapa,
        _alimentacaodto = alimentacaodto,
        super(key: key);

  final TextEditingController _controlerPosicao;
  final TextEditingController _controlerMateriaPrimaEsperada;
  final TextEditingController _controlerReelId;
  final TextEditingController _controlerQuantidade;

  final FocusNode _focoPosicao;
  final FocusNode _focoIdEmbalagem;
  final Function _refresh;
  final Function _isTecladoAtivo;
  final Function _inverterTecladoAtivo;
  final MapaAlimentacaoDTO _mapa;
  final AlimentacaoDTO _alimentacaodto;

  late BuildContext contexto;

  @override
  Widget build(BuildContext context) {
    this.contexto = context;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Focus(
        onFocusChange: (focus) {
          if (focus) {
            VfApp.leitorFactory.configurarLeituraCB(controller: _controlerPosicao, onSubmited: posicaoSubmitted);
          }
        },
      child: TextFormField(
        cursorWidth: 12.0,
        keyboardType:
        _isTecladoAtivo() ? TextInputType.text : TextInputType.none,
        controller: _controlerPosicao,
          focusNode: _focoPosicao,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                    _inverterTecladoAtivo();
                    _focoPosicao.unfocus(); // tiro o foco para forcar o usuario a dar um tap no campo e o teclado aparecer. O ideal depois eh automatizar isso
                  _refresh();
                },
                icon:_isTecladoAtivo() ? Icon(Icons.arrow_back): Icon(Icons.keyboard),
              ),
              border: OutlineInputBorder(),
              labelText: 'Posição a ser alimentada',
              hintText: 'Qual posição será alimentada com a materia-prima'),
          // The validator receives the text that the user has entered.
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return 'A posição deve ser informada.';
          //   }
          //
          //   return null;
          // },
          onFieldSubmitted: (value) {
            posicaoSubmitted();
          },
        ),
      ),
    );
  }

  void posicaoSubmitted() async {
    if (_controlerPosicao.text.isEmpty) {
      _controlerMateriaPrimaEsperada.text = '';
      _controlerReelId.text = '';
      _controlerQuantidade.text = '';
    } else {
      /* Avaliar se a posicao lida existe no mapa */
      bool isExiste = false;
      for(RealimentacaoDTO dto in this._mapa.pas) {
        if (dto.cdPa.compareTo(_controlerPosicao.text) == 0) {
          isExiste = true;
          break;
        }
      }
      if (isExiste) {

        /* Avaliar se a posicao já foi alimentada com sucesso. Se sim, avisar
         */
        isExiste = false;

        for (RealimentacaoDTO dto in this._alimentacaodto.alimentacoes) {
          if (dto.cdPa.compareTo(_controlerPosicao.text) == 0 && dto.isSucesso) {
            isExiste = true;
            break;
          }
        }

        if(isExiste) {
          MensagemDialog.showMensagem(contexto, 'Posição ${_controlerPosicao.text}', 'já alimentada.');
          _controlerPosicao.text = '';
          _focoPosicao.requestFocus();
        } else {
          _focoIdEmbalagem.requestFocus();
          _refresh();
        }
      } else {
        MensagemDialog.showMensagem(contexto, 'Posição ${_controlerPosicao.text}', 'desconhecida. Tentar novamente.');
        _controlerPosicao.text = '';
        _focoPosicao.requestFocus();
      }
    }
  }
}
