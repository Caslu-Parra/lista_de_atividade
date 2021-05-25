import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../produto_model.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

// Criar BD caso ele não exista.
  initDB() async {
    // Indicação do caminho do arquivo .db ondee será salvo:
    Directory pastaDeDocs = await getApplicationDocumentsDirectory();
    String caminhoFinal = pastaDeDocs.path + "/banco.db";
    return await openDatabase(caminhoFinal, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // Comando SQL que cria a estrutura do Banco:
      await db.execute("CREATE TABLE Tarefas("
          "id INTEGER PRIMARY KEY,"
          "nome TEXT,"
          "descricao TEXT,"
          "data TEXT)");
    });
  }

  // Comandos para inserir/excluir/editar itens do db:
  inserirProduto(ProdutoModel produto) async {
    // intanciar o db:
    final db = await database;
    // obter o último id cadastrado:
    var tabela = await db.rawQuery("SELECT MAX(id)+1 as id FROM Tarefas");

    int id = tabela.first["id"];
    // Executar o comando INSERT:
    var resultado = await db.rawInsert(
        "INSERT INTO Tarefas (id, nome, descricao, data)" +
            "VALUES (?, ?, ?, ?) ",
        [id, produto.titulo, produto.descricao, produto.data]);
    return resultado;
  }

  // Comandos para inserir/excluir/editar itens do db:
  apagarProduto(int id) async {
    final db = await database;
    return db.delete("Tarefas", where: "id = ?", whereArgs: [id]);
  }

  deletarTudo() async {
    final db = await database;
    db.rawDelete("DELETE FROM Tarefas");
  }

  // Listar itens:
  Future<List<ProdutoModel>> obterTodosItens() async {
    // Conectar ao banco:
    final db = await database;
    // SELECT *
    var res = await db.query("Tarefas");
    // Mapeamento para lista:
    List<ProdutoModel> lista =
        res.isNotEmpty ? res.map((c) => ProdutoModel.fromMap(c)).toList() : [];
    // retornar a lista de objetos:
    //print(lista[0].descricao);
    return lista;
  }
}
