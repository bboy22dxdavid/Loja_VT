import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/abas/lista_horizonta.dart';

/*
        ========================================
                ABAS DA TELA INICIAL
        ========================================
         */

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;
    // função que cria a cor degrade
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255,  160, 220, 180),
                Color.fromARGB(255, 255, 255, 180)
              ],
              // indicando o local do degrader
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          )
      ),
    );
    return Stack(
      children:<Widget> [
        _buildBodyBack(),
        //visualização de rolagem personalizada
        CustomScrollView (
          slivers: <Widget> [
            SliverAppBar(
              //barra de titulo flutuante
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades",),
                centerTitle: true,
              ),
            ),
            //não retorna um futuro instantaneamente
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.collection("images_home")
                  .orderBy("pos").getDocuments(),
              builder: (context, snapshot){
                //iniciando condições para verificar se retorna dados da Db
                if(!snapshot.hasData)
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else  {
                  print(snapshot.data.documents.length);
                  return SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.9,
                        child: Carousel(
                          images: snapshot.data.documents.map((doc){
                            return Image.network(
                              doc.data["images"],
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotBgColor: Colors.transparent,
                          dotColor: primaryColor,
                          autoplay: true,
                          animationDuration: Duration(milliseconds: 1000)
                        ),
                      ),
                        /*
                        ===================================================
                              CATEGORIAS DE PRODUTOS HORIZONTAL
                        ===================================================*/
                        SizedBox(height: 20.0,),
                        new Padding(padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: new Text('Produtos',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, ),),
                            )
                        ),

                        new Center(
                            child: Container(
                              //width: 400.0,
                              height: 80.0,
                              child: ListHorizontal(),
                            ),
                        ),
                        /*
                        ===================================================
                                    LISTA DE PRODUTOS
                        ===================================================*/
                        new Padding(padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: new Text('Ofertas do Mes',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, ),),
                            ),
                        ),

                        GridImages(),
                      ],
                  )
                  );
                }

              },
            ),

          ],
        ),
      ],
    );
  }
}

/*
=============================================================================
              CLASSE DA GRADE DE IMAGENS
============================================================================= */

class GridImages extends StatelessWidget {
  Widget makeImageGrid(){
    return Column(
      children:<Widget> [
        SizedBox(
          height: 400,
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index){
                return ImageGridItens(index+1);
              }
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children:<Widget> [
        Container(
          child: makeImageGrid(),
        ),
      ],

    );
  }
}

class ImageGridItens extends StatefulWidget {
  int _index;
  // StorageReference photosReferencia = FirebaseStorage.instance.ref().child("home");

  ImageGridItens(int index){
    this._index = index;
  }

  @override
  _ImageGridItensState createState() => _ImageGridItensState();
}

class _ImageGridItensState extends State<ImageGridItens> {
  Uint8List imageFile;
  StorageReference photosReferencia = FirebaseStorage.instance.ref().child("home");

  getImage(){
    int Max_size = 7*1024*1024;

    photosReferencia.child("ofert-${widget._index}.jpg").getData(Max_size).then((data){
      this.setState(() {
        imageFile = data;
      });
    }).catchError((Error){
      //printa o erro
      debugPrint(Error.toString());
    });
  }

  Widget decideGridTileWidget(){
    if(imageFile == null){
      return Center( child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
        //Text("Erro ao acessar banco"),
      );
    }else {
      return Image.memory(
        imageFile,
        fit: BoxFit.cover,
      );
    }
  }


  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: decideGridTileWidget(),
    );
  }
}


/*
alteração no banco de dados
request.auth != null
 */

/*
SliverStaggeredGrid.count(
                    crossAxisCount: 1,
                    staggeredTiles: snapshot.data.documents.map(
                            (doc){
                          return StaggeredTile.count(
                              doc.data["x"],
                              doc.data["y"]);
                        }).toList(),
                    children: snapshot.data.documents.map(
                            (doc){
                          return  FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: doc.data["images"],
                            fit: BoxFit.cover,
                          );
                        }
                    ).toList(),
                  );
 */
/*
 new Center(
                          child: Column(
                            children: [
                              GridView.builder(
                              padding: EdgeInsets.all(10.0),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                ),
                                itemCount: 4,
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                    child: Image.network(
                                     "https://i2.wp.com/marketingcomcafe.com.br/wp-content/uploads/2017/12/banco-imagens-gratis.png?resize=720%2C480",
                                      fit: BoxFit.cover,
                                      height: 250.0,
                                    ),
                                  );
                                }
                            ),
                            ],
                          ),
                        )
 */
/*
SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.9,
                        child: Carousel(
                          images: snapshot.data.documents.map((doc){
                            return Image.network(
                              doc.data["images"],
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          dotBgColor: Colors.transparent,
                          dotColor: primaryColor,
                          autoplay: true,
                          animationDuration: Duration(milliseconds: 1000)
                        ),
                      ),
                        /*
                        ===================================================
                              CATEGORIAS DE PRODUTOS HORIZONTAL
                        ===================================================*/
                        SizedBox(height: 20.0,),
                        new Padding(padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: new Text('Produtos',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, ),),
                            )
                        ),

                        new Center(
                            child: Container(
                              //width: 400.0,
                              height: 80.0,
                              child: ListHorizontal(),
                            ),
                        ),
                        /*
                        ===================================================
                                    LISTA DE PRODUTOS
                        ===================================================*/
                        new Center(
                          child: Column(
                            children: [
                              new Padding(padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                    child: new Text('Ofertas',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0, ),),
                                  )
                              ),
                            ],
                          ),
                        ),


                      ],
                  )
                  );
 */