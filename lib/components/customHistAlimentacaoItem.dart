import 'package:flutter/material.dart';
import 'package:vfapp/models/historicoRest.dart';

class CustomHistAlimentacaoItem extends StatelessWidget {
  final MonitorizacaoAlimDTO monAlimentacaoDTO;

  const CustomHistAlimentacaoItem({required this.monAlimentacaoDTO, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xFFE5E1E1),
            width: 0.5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        title: TituloHistorico(
          monTitulo: monAlimentacaoDTO,
        ),
        subtitle: SubtituloHistorico(
          monSubtitulo: monAlimentacaoDTO,
        ),
      ),
    );
  }
}

class SubtituloHistorico extends StatelessWidget {
  final MonitorizacaoAlimDTO monSubtitulo;
  const SubtituloHistorico({
    Key? key,
    required this.monSubtitulo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(
                  nome: 'qt Alimentada',
                  conteudo: '${monSubtitulo.qtAlimentada}'),
              TextItem(nome: 'qt Usada', conteudo: '${monSubtitulo.qtUsada}'),
              TextItem(
                  nome: 'qt Por Placa', conteudo: '${monSubtitulo.qtPorPlaca}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(nome: 'qt Atual', conteudo: '${monSubtitulo.qtAtual}'),
              TextItem(
                  nome: 'Ciclo Padrao',
                  conteudo: '${monSubtitulo.cicloPadrao}'),
              TextItem(
                  nome: 'Previsao Termino',
                  conteudo: '${monSubtitulo.previsaoTermino ~/ 60} minutos'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(
                  nome: 'qt Produto\nRestante',
                  conteudo: '${monSubtitulo.qtProdutoRestante}'),
              TextItem(
                  nome: 'qt Ciclo\nRestante',
                  conteudo: '${monSubtitulo.qtCicloRestante}'),
              TextItem(
                  nome: 'tipo\nAlimentacao',
                  conteudo:
                      '${monSubtitulo.tipoAlimentacao == 0 ? 'Alimentação' : monSubtitulo.tipoAlimentacao == 1 ? 'Realimentação' : 'Indefinido'}'),
            ],
          ),
          TextItem(
              nome: 'Sucesso',
              conteudo: '${monSubtitulo.isSucesso ? 'SIM' : 'NAO'}'),
          TextItem(
              nome: 'Data e Hora Leitura',
              conteudo: '${monSubtitulo.dthrLeitura}'),
          TextItem(
              nome: 'Alimentador', conteudo: '${monSubtitulo.alimentador}'),
        ],
      ),
    );
  }
}

class TituloHistorico extends StatelessWidget {
  final MonitorizacaoAlimDTO monTitulo;

  const TituloHistorico({required this.monTitulo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(nome: 'Posto', conteudo: '${monTitulo.cdPt}'),
              TextItem(nome: 'cdPa', conteudo: '${monTitulo.cdPa}'),
            ],
          ),
          TextItem(nome: 'Mapa', conteudo: '${monTitulo.cdMapa}'),
          TextItem(nome: 'Id Produto Esperado', conteudo: '${monTitulo.cdProduto}'),
          TextItem(nome: 'Produto lido', conteudo: '${monTitulo.cdProdutoLido}'),
          TextItem(nome: 'Id.Embalagem', conteudo: '${monTitulo.idEmbalagem}'),
        ],
      ),
    );
  }
}

class TextItem extends StatelessWidget {
  final String nome;
  final String conteudo;

  const TextItem({required this.nome, required this.conteudo, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$nome',
          style: TextStyle(fontSize: 10),
        ),
        Text(
          '$conteudo',
          style: TextStyle(fontSize: 20),
        ),
        Container(
          height: 20,
        ),
      ],
    );
  }
}
