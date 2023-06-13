import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vfapp/models/linhasRest.dart';

class ConfiguracaoApp {
  late ConfiguracaoDTO configuracao;

  Future<ConfiguracaoDTO> lerConfiguracao() async {
    /* Alessandre em 01-11-21 comentei o trecho e substitui por SharedPrefernces pois o path_profiler está depracated

    final configFile = await _localFile;

    // Verifica se o arquivo existe. Se nao existir, criar
    if (!configFile.existsSync()) {
      // Se nao existir  o arquivo criar uma configuracao padrao
      criarArquivoEmBranco();
    } else {
      final jsonString = await configFile.readAsString();
      print('Lendo configuracao json $jsonString');
      final dynamic json = jsonDecode(jsonString);

      // Se der algum erro é pq o arquivo existe e eh antigo, logo fora do padrão. Nesse caso criar um arquivo limpo
      try {
        configuracao = ConfiguracaoDTO.fromJson(json);
      } on NoSuchMethodError catch (_) {
        criarArquivoEmBranco();
      }
    }
    return configuracao;
     */
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('configuracao')) {
      final jsonConfiguracao = prefs.getString('configuracao');
      final dynamic json = jsonDecode(jsonConfiguracao!);
      // Se der algum erro é pq o arquivo existe e eh antigo, logo fora do padrão. Nesse caso criar um arquivo limpo
      try {
        configuracao = ConfiguracaoDTO.fromJson(json);
      } on Exception catch (_) {
        criarArquivoEmBranco();
      }
    } else {
      // Se nao existir  o arquivo criar uma configuracao padrao
      criarArquivoEmBranco();
    }
    return configuracao;
  }

  void criarArquivoEmBranco() {
    //ConfiguracaoDTO configPadrao = new ConfiguracaoDTO(url: 'http://170.10.0.10:8080/idw');

    //ConfiguracaoDTO configPadrao = new ConfiguracaoDTO(url: 'http://192.168.1.7:8080/idw');
    //configPadrao.cdgtFase = 'SMD';

    ConfiguracaoDTO configPadrao =
        new ConfiguracaoDTO(url: 'http://192.168.0.13:8080/idw');
    configPadrao.cdgtFase = 'IAC';
    configPadrao.vermelhoate = 10;
    configPadrao.amareloate = 30;
    configPadrao.segreclista = 30;
    configPadrao.linhaSelecionada = LinhaDTO(cdLinha: '', postos: <PostoDTO>[]);
    configPadrao.postoSelecionado = PostoDTO(cdPosto: '');
    configPadrao.brightness = true;
    configPadrao.lerid = true;
    configPadrao.tecladoHabilitado = false;
    configPadrao.urlProtheus = 'http://192.168.0.37:9098/rest/wms';
    configPadrao.habilitarValidacaoERP = true;
    configPadrao.posicaoautomatica = false;
    this.configuracao = configPadrao;
    salvarConfiguracao();
  }

  Future<void> salvarConfiguracao() async {
    /* Alessandre em 01-11-21 comentei o trecho abaixo e substitui por SharedPreferrences
    final configFile = await _localFile;
    final jsonString = jsonEncode(configuracao);
    print('Vou salvar a configuracao = $jsonString');
    configFile.writeAsString(jsonString);
    */
    print("vou mostrar configuracao");
    print("toJson url ${configuracao.url}");
    print("cdgtfase ${configuracao.cdgtFase}");
    print("linhaSelecionada ${configuracao.linhaSelecionada}");
    print("vermelhoate ${configuracao.vermelhoate}");
    print("amareloate ${configuracao.amareloate}");
    print("segreclista ${configuracao.segreclista}");
    print("postoSelecionado ${configuracao.postoSelecionado}");
    print("brightness ${configuracao.brightness}");
    print("lerid ${configuracao.lerid} tecladoHabilitado ${configuracao.tecladoHabilitado} urlPrhtheus ${configuracao.urlProtheus} habilitarValidacaoERP ${configuracao.habilitarValidacaoERP} posicaoautomatica ${configuracao.posicaoautomatica}");

    final jsonConfiguracao = jsonEncode(configuracao);
    final prefs = await SharedPreferences.getInstance();
    print('json configuracao que sera salva $jsonConfiguracao');
    prefs.setString('configuracao', jsonConfiguracao);
  }

  /* Alessandre em 01-11-21 comentei o trecho abaixo pois removi do projeo a api path_provider que tem metodos
  deprecated. Substitui o uso de arquivo por
  Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/vfapp-config.json');
  }
   */

}

class ConfiguracaoDTO {
  late String url;
  late String cdgtFase =
      'IAC'; // Codigo do GT que representa a fase de producao que será considerada para apresentacao das linhas
  late int vermelhoate;
  late int amareloate;
  late int segreclista;
  late LinhaDTO linhaSelecionada =
      new LinhaDTO(cdLinha: '', postos: <PostoDTO>[]);
  late PostoDTO postoSelecionado;
  late bool brightness;
  late bool lerid;
  late bool tecladoHabilitado;
  late String urlProtheus;
  late bool habilitarValidacaoERP;
  late bool posicaoautomatica; // se true durante a alimentação ou conferencia a posição é solicitada automaticamente

  ConfiguracaoDTO({required this.url});

  factory ConfiguracaoDTO.fromJson(Map<String, dynamic> json) {
    ConfiguracaoDTO retorno = ConfiguracaoDTO(url: json['url']);
    retorno.cdgtFase = json['cdgtfase'];
    retorno.linhaSelecionada = LinhaDTO.fromJson(json['linhaSelecionada']);
    retorno.vermelhoate = json['vermelhoate'];
    retorno.amareloate = json['amareloate'];
    retorno.segreclista = json['segreclista'];
    retorno.postoSelecionado = PostoDTO.fromJson(json['postoSelecionado']);
    retorno.brightness = json['brightness'] ?? true;
    retorno.lerid = json['lerid'] ?? true;
    retorno.tecladoHabilitado = json['tecladoHabilitado'] ?? true;
    retorno.urlProtheus = json['urlProtheus'] ?? '';
    retorno.habilitarValidacaoERP = json['habilitarValidacaoERP'] ?? false;
    retorno.posicaoautomatica = json['posicaoautomatica'] ?? false;
    return retorno;
  }

  // O metodo abaixo monta o json para ser salvo no arquivo local de configuracoes
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'cdgtfase': this.cdgtFase,
      'linhaSelecionada': this.linhaSelecionada,
      'vermelhoate': this.vermelhoate,
      'amareloate': this.amareloate,
      'segreclista': this.segreclista,
      'postoSelecionado': this.postoSelecionado,
      'brightness': this.brightness,
      'lerid': this.lerid,
      'tecladoHabilitado': this.tecladoHabilitado,
      'urlProtheus': this.urlProtheus,
      'habilitarValidacaoERP': this.habilitarValidacaoERP,
      'posicaoautomatica': this.posicaoautomatica,
    };
  }
}
