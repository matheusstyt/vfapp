class Funcoes {
  /*
   A função abaixo troca as virgulas do json por uma quebra de linha, além
  de remover a palavra exception e os caracteres { e }
  */
  static formataJsonErro(String jsonErro) {
    String retorno = jsonErro;
    retorno = retorno.replaceFirst('Exception: {', '\n');
    retorno = retorno.replaceFirst('}', '', retorno.length - 1);
    retorno = retorno.replaceAll(', ', '\n');

    return retorno;
  }

  static bool reelIDValidadeLoteConsistente(
      String value, String cdProdutoEncontrado) {
    bool retorno = false;

    var separador = obtemSeparador(value, cdProdutoEncontrado);
    List<String> valores = value.split(separador);

    if (valores.length != 7) {
      retorno = true;
    } else {
      // aqui deveremos analisar se o ultimo campo é uma data válida
      String dtCB = valores[6]; // deve estar no padrao AAAAMMDD
      if (dtCB.length == 8) {
        try {
          print(dtCB);
          retorno = isValidDate(dtCB);
        } on Exception catch (_) {
          // apenas descarta o valor
        }
      }
    }

    return retorno;
  }

  static bool reelIsTemValidadeLote(String value, String cdProdutoEncontrado) {
    bool retorno = false;

    var separador = obtemSeparador(value, cdProdutoEncontrado);
    List<String> valores = value.split(separador);

    retorno = (valores.length >= 7);

    return retorno;
  }

  static DateTime getRellDataLote(String value, String cdProdutoEncontrado) {
    DateTime retorno;

    var separador = obtemSeparador(value, cdProdutoEncontrado);
    List<String> valores = value.split(separador);

    // Neste trecho ja sabemos que é uma data valida. Basta comparar com o ano
    String dtCB = valores[6]; // deve estar no padrao AAAAMMDD
    retorno = DateTime.parse(dtCB);
    return retorno;
  }

  static bool isReelDataLoteValida(DateTime dtLote) {
    bool retorno = false;
    DateTime dtAtual = DateTime.now();
    String dtLoteStr = toOriginalFormatString(dtLote);
    String dtAtualStr = toOriginalFormatString(dtAtual);

    retorno = (double.parse(dtLoteStr) >= double.parse(dtAtualStr));

    return retorno;
  }

  static bool isValidDate(String input) {
    final date = DateTime.parse(input);
    final originalFormatString = toOriginalFormatString(date);
    return input == originalFormatString;
  }

  static String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  static String obtemSeparador(String value, String cdProdutoEncontrado) {
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
}
