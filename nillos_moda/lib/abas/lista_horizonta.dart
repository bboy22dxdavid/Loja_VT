import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/telas/tela_lista_horizo.dart';

/*
        ========================================
        ABA DE LISTA DE CATEGORIAS HORIZONTAL
        ========================================
         */

class ListHorizontal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("produtos").getDocuments(),
        builder: (context, snapshot){
        //condição que verifica se esta retornando dados da DB
        if (!snapshot.hasData)
          return Center(
           child: CircularProgressIndicator(),
        );
        else {
          return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data.documents.map((doc) {
                return TelaListaHori(doc);
              }).toList(),
          );
        }
     }
    );
  }
}
