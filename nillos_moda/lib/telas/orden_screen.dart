import 'package:flutter/material.dart';
import 'package:nillos_moda/abas/ordes_tabs.dart';
import 'package:nillos_moda/telas/tela_home.dart';
/*
        ========================================
                TELA DE ORDEM DE PEDIDO 
        ========================================
         */

class OrdenScreen extends StatelessWidget {

  final String orderId;
  OrdenScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Realizado"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check,
              color: Theme.of(context).primaryColor,
              size: 80.0,
            ),
            Text("Pedido realizado com sucesso!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text("Código do pedido: $orderId", style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 44.0,),
            //adicionar butao para ir aos pedidos
            RaisedButton(
              child: Text("Retornar Ao inicio",
                style: TextStyle(color: Colors.white),
              ),
                color: Theme.of(context).primaryColor,
                onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>
                      HomeScreen())
                );
                }
            ),
          ],
        ),
      ),
    );
  }
}
