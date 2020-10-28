import 'package:flutter/material.dart';
import 'package:nillos_moda/modelos/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

/*
        ========================================
                TELA DE CADASTRO DE LOGIN
        ========================================
         */
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // variavel chave global
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //controladores
  final _nomeControle = TextEditingController();
  final _phoneControle = TextEditingController();
  final _emailControle = TextEditingController();
  final _enderecoControle = TextEditingController();
  final _passControle = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
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
                    controller: _nomeControle,
                    decoration: InputDecoration(
                        hintText: "Nome completo"
                    ),
                    validator: (text){
                      if (text.isEmpty ) return "*Campo Obrigatorio";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _phoneControle,
                    decoration: InputDecoration(
                        hintText: "Telefone"
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (text){
                      if (text.isEmpty || text.length < 9) return "Número Invalido";
                    },
                  ),
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
                    controller: _enderecoControle,
                    decoration: InputDecoration(
                        hintText: "Endereço "
                    ),
                    validator: (text){
                      if (text.isEmpty ) return "Endereço invalido!";
                    },
                  ),
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
                  SizedBox(height: 16.0,),
                  SizedBox(height: 40.0,
                    child: RaisedButton(
                      onPressed: (){
                        if(_formkey.currentState.validate()){
                          Map<String, dynamic> userData = {
                            "nome" : _nomeControle.text,
                            "phone" : _phoneControle.text,
                            "email" : _emailControle.text,
                            "endereco" : _enderecoControle.text,
                          };

                          model.signup(
                              userData: userData,
                              pass: _passControle.text,
                              onSucess: _onSuccess,
                              onFail: _onFail
                          );
                        }
                      },
                      child: Text("Criar Conta",
                        style: TextStyle(
                            fontSize: 18.0
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
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
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Usuário criado com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

//funcao que indica falha
  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao criar usuário!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}





