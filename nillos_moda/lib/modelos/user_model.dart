import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
/*
        ========================================
              CLASS DE GRUD DE USUARIO
        ========================================
         */
class UserModel extends Model{
  //controlara usuario atual
  //importando  banco de dados
  FirebaseAuth _auth = FirebaseAuth.instance;

  //variavel que identifica se o usuario esta logado
  FirebaseUser firebaseUser;

  //armazenara os dados do usuario
  Map<String, dynamic> userData = Map();

  // variaveis que indica se esta carregando
  bool isLoadIng = false;

  //metodo statico
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  /*==================================================
               FUNCOES
   ==================================================*/
  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  //FUNCAO DE INSCREVER-SE USUARIO
  void signup({@required Map<String, dynamic> userData,@required
  String pass,@required VoidCallback onSucess,@required VoidCallback onFail}){
    //indicando ao usuari que esta carregando
    isLoadIng = true;
    // comando que atualiza a view
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass).then((user) async{
          firebaseUser = user;

          //funcão que salva na base de dados
         await _saveUserData(userData);

          onSucess();
          //indicando ao usuari que esta carregando
          isLoadIng = false;
          // comando que atualiza a view
          notifyListeners();
    }).catchError((onError){
      onFail();
      //indicando ao usuari que esta carregando
      isLoadIng = false;
      // comando que atualiza a view
      notifyListeners();
    });
  }

  //FUNCAO DE CADASTRAR USUARIO
  void signIn({@required String email, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail})async {

    //indicando ao usuari que esta carregando
    isLoadIng = true;
    // comando que atualiza a view
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: pass).then(
            (user) async {
          firebaseUser = user;

          await _loadCurrentUser();

          onSuccess();
          isLoadIng = false;
          notifyListeners();

        }).catchError((e){
      onFail();
      isLoadIng = false;
      notifyListeners();
    });
  }

  //FUNCAO DE RECUPERAR SENHA DE USUARIO
  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  //FUNCAO QUE VERIFICA SE O USUARIO ESTA LOGADO
  bool isLoggedIn(){
    return firebaseUser != null;
  }

  //FUNCAO DE RECUPERAR SENHA DE USUARIO
  void signOut()async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    // comando que atualiza a view
    notifyListeners();
  }

  //FUNCAO QUE SALVA SENHA E EMAIL
  Future<Null> _saveUserData(Map<String, dynamic> userData)async{
    this.userData = userData;

    await Firestore.instance.collection("usuarios").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if(firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
      if(userData["nome"] == null){
        DocumentSnapshot docUser =
        await Firestore.instance.collection("usuarios").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }
}