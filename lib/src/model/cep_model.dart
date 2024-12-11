class CepModel {
  final String objectId;
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;

  CepModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.objectId = '',
  });

  factory CepModel.fromJson(Map<String, dynamic> json) {
    return CepModel(
      cep: json['cep'],
      logradouro: json['logradouro'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      localidade: json['localidade'],
      uf: json['uf'],
      objectId: json['objectId'] != null ? json['objectId'] : '',
    );
  }

  static List<CepModel> fromJsonCollection(json) {
      List<CepModel> cepModel = [];
      
      if (json['results'] != null) {
        json['results'].forEach((v) {
          cepModel.add(CepModel.fromJson(v));
        });
      }

      return cepModel;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['cep'] = cep;
    data['logradouro']  = logradouro;
    data['complemento'] = complemento;
    data['bairro'] = bairro;
    data['localidade'] = localidade;
    data['uf'] = uf;

    return data;
  }
  
}