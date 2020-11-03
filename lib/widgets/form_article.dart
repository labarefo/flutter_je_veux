
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_je_veux/model/article.dart';
import 'package:flutter_je_veux/model/databaseClient.dart';
import 'package:flutter_je_veux/model/item.dart';
import 'package:image_picker/image_picker.dart';

class FormArticle extends StatefulWidget {
  Item item;
  Article article;

  FormArticle(this.item, {this.article});

  @override
  _FormArticleState createState() {
    return new _FormArticleState();
  }

}

class _FormArticleState extends State<FormArticle> {
  String image;

  String nom;
  String prix;
  String magasin;

  @override
  void initState() {
    super.initState();
    if(widget.article != null){
      nom = widget.article.nom;
      prix = widget.article.prix;
      magasin = widget.article.magasin;
      image = widget.article.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ajout à ${widget.item.nom}"),
        actions: [
          new FlatButton(onPressed: ajouterOuModifier, child: new Text("Valider", style: new TextStyle(color: Colors.white),))
        ],
      ),
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          children: [
            new Text( widget.article == null ? "Article à ajouter" : "Article à modifier", textScaleFactor: 1.4,style: new TextStyle(color: Colors.red, fontStyle: FontStyle.italic),),

            new Card(
              elevation: 10.0,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (image == null) ? new Image.asset("images/no_image.png") : new Image.file(new File(image)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new IconButton(icon: new Icon(Icons.camera_enhance), onPressed: () => getImage(ImageSource.camera)),
                      new IconButton(icon: new Icon(Icons.photo_library), onPressed: () => getImage(ImageSource.gallery))
                    ],
                  ),

                  textField(TypeTextField.nom, "Nom de l'article", nom),
                  textField(TypeTextField.prix, "Prix", prix),
                  textField(TypeTextField.magasin, "Magasin", magasin),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void ajouterOuModifier() {

    if(nom != null){
      Map<String, dynamic> map = {
        "nom": nom,
        "item": widget.item.id
      };
      if(magasin != null && magasin.isNotEmpty){
        map["magasin"] = magasin;
      }
      if(prix != null && prix.isNotEmpty){
        map["prix"] = prix;
      }
      if(image != null && image.isNotEmpty){
        map["image"] = image;
      }
      if(widget.article == null){
        widget.article = new Article();
      }else{
        map["id"] = widget.article.id;
      }
      widget.article.fromMap(map);
      DatabaseClient().upsertArticle(widget.article).then((value) {
        image = null;
        nom = null;
        magasin = null;
        prix = null;
        widget.article = null;
        Navigator.pop(context);
      });
    }

  }

  TextField textField(TypeTextField type, String label, var value) {

    return new TextField(
      controller:  new TextEditingController(text: value),
      decoration: new InputDecoration(labelText: label),
      onChanged: (str){
        switch(type){
          case TypeTextField.nom:
            nom = str;
            break;
          case TypeTextField.prix:
            prix = str;
            break;
          case TypeTextField.magasin:
            magasin = str;
            break;
        }
      },
    );
  }


  Future getImage(ImageSource source) async {
    var nouvelleImage = await ImagePicker().getImage(source: source);
    setState(() {
      image = nouvelleImage.path;
    });
  }
}

enum TypeTextField {
  nom,
  prix,
  magasin
}