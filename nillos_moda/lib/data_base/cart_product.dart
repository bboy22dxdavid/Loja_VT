import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nillos_moda/data_base/product_data.dart';
/*
        ========================================
        CLASSE PARA ARMAZENA OS DADOS DO PRODUTO
        ========================================
 */

class CartProduct{
  String cid;//id da categoria do produto
  String category;
  String pid;//id da categoria do produto

  int  qtd; //quantidade de produto
  String size; //tamano do produto


  //variavel do produto
  ProdutoData produtoData;

  CartProduct();
//construtor do produto
  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["categoria"];
    pid = document.data["pId"];
    qtd = document.data["quantidade"];
    size = document.data["size"];
  }
  Map<String, dynamic> toMap(){
    return {
      "categoria": category,
      "pid": pid,
      "quantidade": qtd,
      "size": size,
      "product": produtoData.toResumedMap()
    };
  }
}