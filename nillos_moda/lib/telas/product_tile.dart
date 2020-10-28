import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/abas/product_screen.dart';
import 'package:nillos_moda/data_base/product_data.dart';
/*
        ========================================
                TELA DE ITENS DO PRODUTOS
        ========================================
         */
class ProducTile extends StatelessWidget {
  //construtor que recebe o tipo grid ou list
  final String type;
  final ProdutoData produto;

  ProducTile(this.type, this.produto);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //função que chama a tela do produto
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context)=> ProducScreen(produto))
        );
      },
      child: Card(
        child: type == "grid" ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children:<Widget>[
            AspectRatio(
                aspectRatio: 0.8,
              child: Image.network(
                produto.images[0],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children:<Widget> [
                      Text(
                        produto.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        "R\$ ${produto.price.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                )
            )
          ],
        )
        : Row(
          children:<Widget> [
            Flexible(
              flex: 1,
              child: Image.network(
                produto.images[0],
                fit: BoxFit.cover,
                height: 250.0,
              ),
            ),
            Flexible(
              flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget> [
                      Text(
                        produto.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        "R\$ ${produto.price.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
