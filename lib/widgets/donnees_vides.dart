

import 'package:flutter/material.dart';

class DonneesVides extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(

      child: new Text(
        "Aucune donnée n'est présente",
        textScaleFactor: 1.4,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color:  Colors.red,
        fontStyle: FontStyle.italic
      ),
      ),
    );
  }


}