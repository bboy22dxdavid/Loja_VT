import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nillos_moda/telas/category_screen.dart';
/*
        ========================================
        TELA DE LISTA DE CATEGORIAS HORIZONTAL
        ========================================
         */
class TelaListaHori extends StatelessWidget {
  final DocumentSnapshot snapshot;
  TelaListaHori(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:  const EdgeInsets.all(2.0),
      child: InkWell(
        child: Container(
          width: 90.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(snapshot.data["icon"]),
            ),
            //title: (snapshot.data["title"]),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> CategoryScreen(snapshot)
                  )
              );
            },
          ),
        ),
      ),
    );
  }
}
/*
 Padding(
        padding:  const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: (){},
        child: Container(
          width: 90.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(snapshot.data["icon"]),
            ),
            title: Text(snapshot.data["title"]),
            onTap: (){},
          ),
        ),
      ),
    );
 */