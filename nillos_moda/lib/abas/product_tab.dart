import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/telas/category_tile.dart';

/*
        ========================================
                TELA DE PRODUTOS
        ========================================
         */
class ProductTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("produtos").getDocuments(),
        builder: (context, snapshot) {
          //condição que verifica se esta retornando dados da DB
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            var dividedTiles = ListTile.divideTiles(
                    tiles: snapshot.data.documents.map((doc) {
                      return CategoryTiles(doc);
                    }).toList(),
                    color: Colors.grey[700])
                .toList();
            return ListView(
              children: dividedTiles,
            );
          }
        });
  }
}
