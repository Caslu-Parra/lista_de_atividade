import 'package:flutter/cupertino.dart';
import 'package:lista_de_atividade/models/database/db.dart';
import 'package:lista_de_atividade/models/produto_model.dart';

class PrincipalController {
  double sliderQtd = 1;

  // Objetos de controle dos campos de entrada:
  var tfTitulo = TextEditingController();
  var tfDescricao = TextEditingController();
  var tfData = TextEditingController();

  // Metodo de listagem de usuários:
  Future<List<ProdutoModel>> listarTudo() async {
    return DBProvider.db.obterTodosItens();
  }

  Future<void> cadastrar() async {
    // Instanciar um obj do tipo ProdutoModel:
    var produto = ProdutoModel();

    produto.id = 0;
    produto.titulo = tfTitulo.text;
    produto.descricao = tfDescricao.text;
    produto.data = tfData.text;

    // Chamar o método de cadastro:
    await DBProvider.db.inserirProduto(produto);
    // Remover os campos do textField:
    tfDescricao.text = "";
    tfTitulo.text = "";
    tfData.text = "";
  }

  Future<void> apagar(id) async {
    if (id == '*') {
      await DBProvider.db.deletarTudo();
    } else {
      await DBProvider.db.apagarProduto(id);
    }
  }
}
