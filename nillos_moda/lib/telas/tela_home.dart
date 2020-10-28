import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/abas/home_abas.dart';
import 'package:nillos_moda/abas/ordes_tabs.dart';
import 'package:nillos_moda/abas/places_tab.dart';
import 'package:nillos_moda/widgets/cart_button.dart';
import 'file:///C:/Users/Pc%20Gamer/AndroidStudioProjects/nillos_moda/lib/abas/product_tab.dart';
import 'package:nillos_moda/widgets/custom_drawer.dart';

/*
        ========================================
                TELA INICIAL
        ========================================
         */
class HomeScreen extends StatelessWidget {

  //variaveis de controle
  final _pageControle = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageControle,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          //========================================
          // local onde ocorrerar a navegação das paginas
          body: HomeTab(),
          drawer: CustomDrawer(_pageControle),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageControle),
          body: ProductTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageControle),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageControle),
        )

      ],
    );
  }
}
