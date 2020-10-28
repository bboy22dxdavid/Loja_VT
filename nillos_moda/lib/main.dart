import 'package:flutter/material.dart';
import 'package:nillos_moda/modelos/cart_model.dart';
import 'package:nillos_moda/modelos/user_model.dart';
import 'package:nillos_moda/telas/tela_home.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
        return ScopedModel<CartModel>(
          model: CartModel(model),
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Nilo's  LV",
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                              /*
                    ========================================
                            COR PERSONALISADA
                    ========================================
                     */
                  primaryColor: Color.fromARGB(255, 4, 125, 141)),
                          /*
                    ========================================
                            TELA INICIAL
                    ========================================
                     */
              home: HomeScreen()),
        );
      }),
    );
  }
}
