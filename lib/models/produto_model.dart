class ProdutoModel {
  int id;
  String titulo;
  String data;
  String descricao;

  ProdutoModel({this.descricao, this.id, this.data, this.titulo});

  factory ProdutoModel.fromMap(Map<String, dynamic> json) => new ProdutoModel(
        id: json["id"],
        titulo: json["nome"],
        data: json["data"],
        descricao: json["descricao"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "titulo": titulo,
        "data": data,
        "descricao": descricao,
      };
}