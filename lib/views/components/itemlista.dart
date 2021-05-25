import 'package:flutter/material.dart';
import 'package:lista_de_atividade/views/components/titulo1.dart';

class ItemLista extends StatelessWidget {
  final String titulo;
  final String data;
  final String descr;

  const ItemLista({Key key, this.titulo, this.data, this.descr})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Titulo1(txt: titulo),
                Text('Descricao: $descr'),
                Text('Prazo: $data'),
              ],
            ),
            Icon(
              Icons.check,
              size: 40,
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
