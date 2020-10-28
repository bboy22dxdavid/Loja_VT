import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/data_base/cart_product.dart';
import 'package:nillos_moda/data_base/product_data.dart';
import 'package:nillos_moda/modelos/cart_model.dart';
/*
        ========================================
                CART DE PRODUTOS
        ========================================
         */
class CartTile extends StatelessWidget {
  //construtor
  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      CartModel.of(context).updatePrices();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProduct.produtoData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProduct.produtoData.title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Tamanho: ${cartProduct.size}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$ ${cartProduct.produtoData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: cartProduct.qtd > 1 ?
                            (){
                          CartModel.of(context).decProduct(cartProduct);
                        } : null,
                      ),
                      Text(cartProduct.qtd.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CartModel.of(context).incProduct(cartProduct);
                        },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );

    }
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      //condicao para verificar se não retorno dados do banco
      child: cartProduct.produtoData == null ?
      FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection("produtos").document(cartProduct.category).collection("itens")
              .document(cartProduct.pid).get(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              cartProduct.produtoData = ProdutoData.fromDocument(snapshot.data);
              print("buscando dados, ${_buildContent()}");
              return _buildContent();
            }else {
              print("retornando, ${_buildContent()}");
              return Container(
                height: 70.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,

              );
            }
          },
          ) :
          _buildContent()

    );
  }
}
