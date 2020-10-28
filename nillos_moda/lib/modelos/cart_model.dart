import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nillos_moda/data_base/cart_product.dart';
import 'package:nillos_moda/modelos/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';



/*
        ========================================
                TELA DE CARRINHO DE PRODUTOS
        ========================================
         */

class CartModel extends Model {
  UserModel user;

  //lista de produtos
  List<CartProduct> products = [];

   //variaveis de desconto
  String couponCode;
  int discountPercentage = 0;

  CartModel(this.user){
    if(user.isLoggedIn())
      _loadCartItems();
  }

  //construtor que verrifica se esta carregando
  bool isLoading = false;


  static CartModel of(BuildContext context) =>
    ScopedModel.of<CartModel>(context);

  /*
        ========================================
              CLASS DE GRUD DE PRODUTO
        ========================================
         */
  //FUNCAO QUE ADD NO CARRINHO
    void addCartItem(CartProduct cartProduct){
      products.add(cartProduct);
      
      //add no banco
      Firestore.instance.collection("usuarios")
          .document(user.firebaseUser.uid).collection("cart").add(cartProduct.toMap()).then((doc){
            cartProduct.cid = doc.documentID;
      });
      notifyListeners();
    }

    //FUNCAO QUE REMOVE NO CARRINHO
    void removeCartItem(CartProduct cartProduct){
      //deletando do banco
      Firestore.instance.collection("usuarios")
          .document(user.firebaseUser.uid).collection("cart")
          .document(cartProduct.cid).delete();
      products.remove(cartProduct);
      notifyListeners();
    }

  //FUNCAO QUE DECREMENTA ITEM DO CARRINHO
  void decProduct(CartProduct cartProduct){
    cartProduct.qtd--;

    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid).collection("cart")
        .document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  //FUNCAO QUE INCREMENTA ITEM DO CARRINHO
  void incProduct(CartProduct cartProduct){
    cartProduct.qtd++;

    Firestore.instance.collection("usuarios").document(user.firebaseUser.uid).collection("cart")
        .document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  //FUNCAO QUE ATUALIZA O PREÇO NOCARRINHO
  void updatePrices(){
    notifyListeners();
  }

  //FUNCAO QUE PEGA TODOS OS DADOS DO CART
  void _loadCartItems() async {

    QuerySnapshot query = await Firestore.instance.collection("usuarios")
        .document(user.firebaseUser.uid).collection("cart")
        .getDocuments();

    products = query.documents.map((doc) => CartProduct.fromDocument(doc)
    ).toList();

    notifyListeners();
  }

  //FUNCAO DE % DE DESCONTO
  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  //FUNCAO QUE RETORNA O SUBTOTAL
  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.produtoData != null)
        price += c.qtd * c.produtoData.price;
    }
    return price;
  }

  //FUNCAO QUE RETORNA O VALOR DA ENTREGA
  double getShipPrice(){
    return 9.99;
  }

  //FUNCAO QUE RETORNA O VALOR DO DESCONTO
  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

  //FUNCAO QUE FINALIZA A ORDEM DE SERVIÇO
  Future<String> finishOrder() async {
    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection("ordemServico").add(
        {
          "clientId": user.firebaseUser.uid,
          "E-mail": user.firebaseUser.email,
          "products": products.map((cartProduct)=>cartProduct.toMap()).toList(),
          "Taxa de entrega": shipPrice,
          "Preco do produto": productsPrice,
          "disconto": discount,
          "valor total": productsPrice - discount + shipPrice,
          "status": 1
        }
    );

    await Firestore.instance.collection("usuarios").document(user.firebaseUser.uid)
        .collection("orders").document(refOrder.documentID).setData(
        {
          "orderId": refOrder.documentID
        }
    );

    QuerySnapshot query = await Firestore.instance.collection("usuarios").document(user.firebaseUser.uid)
        .collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }
}
