import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/abas/login_screen.dart';
import 'package:nillos_moda/modelos/user_model.dart';
import 'package:nillos_moda/telas/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';
/*
        ========================================
                PAGINA DE NAVEGAÇÃO
        ========================================
         */

class CustomDrawer extends StatelessWidget {
  // construtor que permite a navegação entre paginas
  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {

    // função que cria a cor degrade
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255,	203,	236,	241),
                Colors.white
              ],
              // indicando o local do degrader
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children:<Widget> [
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(" Nillo's\nModa",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34.0),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child:ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["nome"]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn() ?
                                  "Entre ou Cadastre-se ->": "Sair",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Theme.of(context).primaryColor,),
                                ),
                                // evento de click
                                onTap: (){
                                  if(!model.isLoggedIn())
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => LoginScreen()
                                      )
                                  );
                                  else
                                    model.signOut();
                                },
                              )
                            ],
                          );
                        },
                      )
                    ),
                  ],
                ),
              ),

              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Nossas Lojas", pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos", pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}
