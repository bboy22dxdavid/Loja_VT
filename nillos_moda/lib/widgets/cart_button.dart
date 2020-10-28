import 'package:flutter/material.dart';
import 'package:nillos_moda/telas/cart_screen.dart';
/*
        ========================================
         TELA QUE CRIA O BOTAO DO CART PRODUTO
        ========================================
         */
class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.shopping_cart, color: Colors.white,),
      onPressed: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>CartScreen())
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}