import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
        ========================================
                OPÇÕES DO DRAWER
        ========================================
         */

class DrawerTile extends StatelessWidget {
  //construtor que recebe icone e texto
  final IconData _icon;
  final String _text;
  final PageController controller;
  final int page;

  DrawerTile(this._icon, this._text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
        height: 60.0,
        child: Row(
          children: <Widget>[
            Icon(
              _icon,
              size: 32.0,
              color: controller.page.round() == page ?
              Theme.of(context).primaryColor : Colors.grey[700],
            ),
            SizedBox(width: 32.0,),
            Text(
              _text,
              style: TextStyle(
                fontSize: 16.0,
                color: controller.page.round() == page ?
                Theme.of(context).primaryColor : Colors.grey[700],
              ),
            )
          ],
        ),
      ),
      ),
    );
  }
}
