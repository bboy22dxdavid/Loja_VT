import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/data_base/product_data.dart';
import 'package:nillos_moda/telas/product_tile.dart';

/*
        ========================================
                TELA DE CATEGORIA DE PRODUTOS
        ========================================
         */
class CategoryScreen extends StatelessWidget {
  //construtor que recebe os dados da categoria
  final DocumentSnapshot snapshot;
  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              snapshot.data["title"],),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs:<Widget> [
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                )
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot> (
            future: Firestore.instance.collection("produtos").document(snapshot.documentID)
                .collection("itens").getDocuments(),
            builder: (context, snapshot){
              // condição em quanto carrega os dados
              if(!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else{
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GridView.builder(
                      padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 0.65,
                        ),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index){
                        ProdutoData data = ProdutoData.fromDocument(snapshot.data.documents[index]);
                        data.category = this.snapshot.documentID;
                        return ProducTile("grid", data);
                      },
                    ),
                    ListView.builder(
                        padding: EdgeInsets.all(4.0),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index){
                          ProdutoData data = ProdutoData.fromDocument(snapshot.data.documents[index]);
                          data.category = this.snapshot.documentID;
                          return ProducTile("list", data);
                        })
                  ]
                );
              }
            },
          )
        ),
    );
  }
}
