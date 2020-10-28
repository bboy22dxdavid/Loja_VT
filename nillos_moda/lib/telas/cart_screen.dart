import 'package:flutter/material.dart';
import 'package:nillos_moda/modelos/cart_model.dart';
import 'package:nillos_moda/modelos/user_model.dart';
import 'package:nillos_moda/abas/login_screen.dart';
import 'package:nillos_moda/telas/orden_screen.dart';
import 'package:nillos_moda/telas/cart_tile.dart';
import 'package:nillos_moda/widgets/cart_price.dart';
import 'package:nillos_moda/widgets/discount_cart.dart';
import 'package:scoped_model/scoped_model.dart';

/*
        ========================================
              TELA DE COMPRAS OU CARRINHO
        ========================================
         */
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int p = model.products.length;
                return Text(
                  "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model){
          //condicao que verificar se o cart esta carregando
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            print("cart caregando, ${model.couponCode}");
            return Center(
              child: CircularProgressIndicator(),
            );
          } //verifica se o usuario nao esta logado
          else if(!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart,
                    size: 80.0, color: Theme
                        .of(context)
                        .primaryColor,),
                  SizedBox(height: 16.0,),
                  Text("Faça o Login para adicionar o produto no carrinho!",
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0,),
                  RaisedButton(
                    child: Text("Entar",
                      style: TextStyle(fontSize: 18.0,),),
                    textColor: Colors.white,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    },
                  )
                ],
              ),
            );
            //casso esteja vazio
          } else if(model.products == null || model.products.length == 0){
            return Center(
                child:  Text("Nenhum item no carrinho",
                  style: TextStyle(fontSize: 18.0,),),
            );
          //caso tenha dados
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((produto){
                    return CartTile(produto);
                  }).toList(),
                ),
                DiscountCart(),
                Cartprice(()
                 async {
                    String orderId = await model.finishOrder();
                      if(orderId != null)
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context)=>OrdenScreen(orderId))
                    );
                }
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
