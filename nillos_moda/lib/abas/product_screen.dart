import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/abas/login_screen.dart';
import 'package:nillos_moda/data_base/cart_product.dart';
import 'package:nillos_moda/data_base/product_data.dart';
import 'package:nillos_moda/modelos/cart_model.dart';
import 'package:nillos_moda/modelos/user_model.dart';
import 'package:nillos_moda/telas/cart_screen.dart';
/*
        ========================================
          TELA DE ITENS DO PRODUTOS APOS CLICK
        ========================================
         */
class ProducScreen extends StatefulWidget {
  //construtor que recebe o produto
  final ProdutoData produto;
  ProducScreen(this.produto);

  @override
  _ProducScreenState createState() => _ProducScreenState(produto);
}

class _ProducScreenState extends State<ProducScreen> {
  //construtor da state
  final ProdutoData produto;
  _ProducScreenState(this.produto);

  String _size;
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          produto.title,
        ),
        centerTitle: true,
      ),
      body: ListView(
        children:<Widget> [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: produto.images.map((url){
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(produto.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0
                ),
                maxLines: 3,
              ),
              Text("R\$ ${produto.price.toStringAsFixed(2)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0
                ),
              ),
              SizedBox(height: 16.0,),
              Text("Tamanho",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                ),
              ),
              SizedBox(height: 34.0,
                child: GridView(
                  padding: EdgeInsets.all(4.0),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.5
                  ),
                  children: produto.size.map((tam){
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          _size = tam;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: tam == _size ? primaryColor : Colors.grey[500]
                        ),
                        width: 50.0,
                        alignment: Alignment.center,
                        child: Text(tam),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16.0,),
              SizedBox(
                height: 44.0,
                child: RaisedButton(
                  onPressed:
                    _size != null ?
                    (){
                    if(UserModel.of(context).isLoggedIn()){
                      //Adicionar ao Carrinho
                      CartProduct cartProduct = CartProduct();
                      cartProduct.size = _size;
                      cartProduct.qtd = 1;
                      cartProduct.pid = produto.id;
                      cartProduct.category = produto.category;
                      cartProduct.produtoData = produto;
                      
                        CartModel.of(context).addCartItem(cartProduct);

                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CartScreen())
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    }
                    } : null,
                  child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar ao Carrinho"
                    : "Entre para Comprar",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0
                    ),
                  ),
                  color: primaryColor,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0,),
              Text("Descrição",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0
                ),
              ),
              Text(produto.description,
                style: TextStyle(
                    fontSize: 16.0
                ),
              ),
            ],
          ),
          )
        ],
      ),
    );
  }
}

