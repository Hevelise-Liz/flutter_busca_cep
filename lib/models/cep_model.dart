class CepModel {
  String? cep;
  String? estado;
  String? cidade;
  String? bairro;
  String? rua;

  CepModel({
    this.cep,
    this.estado,
    this.cidade,
    this.bairro,
    this.rua,
  });

  CepModel.fromJson(Map<String, dynamic> json) {
    cep = json['cep'] ?? "";
    estado = json['uf'] ?? "";
    cidade = json['localidade'] ?? "";
    bairro = json['bairro'] ?? "";
    rua = json['logradouro'] ?? "";
  }
}
