import 'package:flutter/material.dart';
import 'package:nillos_moda/abas/singup_screen.dart';
import 'package:nillos_moda/modelos/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
/*
        ========================================
                     TELA DE LOGIN
        ========================================
         */

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // variavel chave global
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

//controladores
  final _emailControle = TextEditingController();
  final _passControle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => SignupScreen()
                    )
                );
              },
              child: Text("Criar Conta",
                style: TextStyle(
                    fontSize: 15.0
                ),
              ),
              textColor: Colors.white,
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            if (model.isLoadIng)
              return Center(child: CircularProgressIndicator(),);
            return Form(
              key: _formkey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children:<Widget> [
                  TextFormField(
                    controller: _emailControle,
                    decoration: InputDecoration(
                        hintText: "E-mail"
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text){
                      if (text.isEmpty || !text.contains("@")) return "E-mail invalido!";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _passControle,
                    decoration: InputDecoration(
                        hintText: "Senha"
                    ),
                    obscureText: true,//faz com que a senha não fique visivel..
                    validator: (text){
                      if (text.isEmpty || text.length < 6) return "Senha invalida!";
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: (){
                        if(_emailControle.text.isEmpty)
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Insira seu e-mail para recuperação!"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              )
                          );
                        else {
                          model.recoverPass(_emailControle.text);
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("Confira seu e-mail!"),
                                backgroundColor: Theme
                                    .of(context)
                                    .primaryColor,
                                duration: Duration(seconds: 2),
                              )
                          );
                        }
                      },
                      child: Text("Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  SizedBox(height: 44.0,
                    child: RaisedButton(
                      child: Text("Entrar",
                        style: TextStyle(
                            fontSize: 18.0
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formkey.currentState.validate()){

                        }
                        model.signIn(
                            email: _emailControle.text,
                            pass: _passControle.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        )
    );
  }
/* =============================================================
                      INICIO DAS FUNCOES
  ============================================================= */
//funcao que indica sucesso
  void _onSuccess(){
    Navigator.of(context).pop();
  }

//funcao que indica sucesso
  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao Entrar!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}





