import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:lista_de_atividade/controllers/principal_controller.dart';
import 'package:lista_de_atividade/views/components/itemlista.dart';
import 'package:lista_de_atividade/views/components/titulo1.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  // Controller:
  var _controller = PrincipalController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Remover?",
                    desc:
                        "Tem certeza que deseja remover todas as tarefas da lista?",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Sim",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          await _controller.apagar('*');
                          setState(() {});
                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: "Show!",
                            desc: "As tarefas foram removida da sua lista!",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Legal!",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();
                        },
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                      ),
                      DialogButton(
                        child: Text(
                          "Não",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.red,
                      )
                    ],
                  ).show();
                },
                child: Icon(
                  Icons.restore_from_trash_rounded,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/todoIcon.png',
                width: 100,
                height: 100,
              ),
              Column(
                children: [
                  Titulo1(
                    txt: 'Bem-Vindo a sua lista de tarefas',
                  ),
                  Container(
                    width: 200,
                    child: Text(
                        'Clique no botão + abaixo para adicionar tarefas na sua lista.'),
                  ),
                ],
              )
            ],
          ),
          // ===================
          // Listagem de compras:
          // Utilizar ListViewBuilder dentro de um FutureBuilder
          Expanded(
              // Conteúdo do banco de dados:
              child: FutureBuilder(
            future: _controller.listarTudo(),
            builder: (context, r) {
              if (r.hasData) {
                // Caso tenha conteúdo monta o listView:
                return ListView.builder(
                    itemCount: r.data.length,
                    itemBuilder: (context, i) {
                      // print(r.data[i].titulo);
                      return GestureDetector(
                        onHorizontalDragStart:
                            (DragStartDetails details) async {
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "Remover?",
                            desc:
                                "Tem certeza que deseja remover a tarefa ${r.data[i].titulo} da lista?",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Sim",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);

                                  // await _controller.apagar(r.data[i].id);
                                  await _controller.apagar('*');
                                  print("Tarefa apagada: " +
                                      r.data[i].id.toString());
                                  setState(() {});
                                  Alert(
                                    context: context,
                                    type: AlertType.success,
                                    title: "Show!",
                                    desc:
                                        "A tarefa ${r.data[i].titulo} foi removida da sua lista!",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Legal!",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                },
                                color: Color.fromRGBO(0, 179, 134, 1.0),
                              ),
                              DialogButton(
                                child: Text(
                                  "Não",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                color: Colors.red,
                              )
                            ],
                          ).show();
                        },
                        child: ItemLista(
                          titulo: r.data[i].titulo,
                          descr: r.data[i].descricao,
                          data: r.data[i].data,
                        ),
                      );
                    });
              } else {
                return Text("Não existe tarefas cadastradas.");
              }
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: () {
          // RFLUTTER ALERT:
          Alert(
              context: context,
              title: "Adicionar Tarefa",
              content: Column(
                children: [
                  TextField(
                    controller: _controller.tfTitulo,
                    maxLength: 15,
                    decoration: InputDecoration(
                      icon: Icon(Icons.shopping_cart),
                      labelText: 'Nome da tarefa:',
                    ),
                  ),
                  TextField(
                    controller: _controller.tfDescricao,
                    maxLength: 15,
                    decoration: InputDecoration(
                      icon: Icon(Icons.note),
                      labelText: 'Descrição da tarefa',
                    ),
                  ),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9/]"))
                    ],
                    controller: _controller.tfData,
                    maxLength: 15,
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today_rounded),
                      labelText: 'Prazo da tarefa',
                    ),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () async {
                    //print(_controller.tfTitulo.text);
                    await _controller.cadastrar();
                    // Comandos para inserção no BD quando clicar em "Adicionar":
                    Navigator.pop(context);
                    setState(() {});
                  },
                  color: Colors.green,
                  child: Text(
                    "Adicionar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
        },
      ),
    );
  }
}
