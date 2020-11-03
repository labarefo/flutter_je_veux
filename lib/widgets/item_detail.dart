

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_je_veux/model/databaseClient.dart';
import 'package:flutter_je_veux/model/item.dart';
import 'package:flutter_je_veux/widgets/ajout_article.dart';
import 'package:flutter_je_veux/widgets/donnees_vides.dart';

import '../model/article.dart';
import 'modifier_article.dart';

class ItemDetail extends StatefulWidget {
  Item item;


  ItemDetail(this.item);

  @override
  _ItemDetailState  createState() {
    return new _ItemDetailState();
  }

}

class _ItemDetailState extends State<ItemDetail> {

  List<Article> articles;

  @override
  void initState() {
    super.initState();

    listeArticles();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.item.nom),
        actions: [
          new FlatButton(
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext){
                  return new AjoutArticle(widget.item);
                })
                ).then((value) {
                  print('On est de retour après ajout');
                  listeArticles();
                });
              },
              child: new Text("Ajouter", style: new TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: articles == null || articles.length == 0
          ?
      new DonneesVides()
          :
      new GridView.builder(
        itemCount: articles.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemBuilder: (context, i){
          Article article = articles[i];
          return new Card(
            elevation: 10.0,
            //margin: EdgeInsets.all(5.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new FlatButton(onPressed: () => modifierArticle(article), child: new Text(article.nom, textScaleFactor: 1.5, )),
                    new IconButton(icon: new Icon(Icons.delete), onPressed: () => supprimerArticle(article))
                  ],
                ),
                new InkWell(
                  onTap: () => modifierArticle(article),
                  child: new Container(
                    //width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 3,
                    child:  (article.image == null)
                        ?
                    new Image.asset("images/no_image.png", width: MediaQuery.of(context).size.width / 3)
                        :
                    new Image.file(new File(article.image)),
                  ),
                ),


                new Text((article.prix == null) ? "Aucun prix renseigné" : "Prix: ${article.prix}"),
                new Text(article.magasin == null ? "Aucun magasin renseigné" : "Magasin: ${article.magasin}")
              ],
            ),
          );
        },
      )
      ,
    );
  }

  void listeArticles() {
    DatabaseClient().allArticles(widget.item.id).then((liste) {
      setState(() {
        articles = liste;
      });
    });
  }

  modifierArticle(Article article) {
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext){
      return new ModifierArticle(widget.item, article);
    })
    ).then((value) {
      print('On est de retour après modification');
      listeArticles();
    });
  }

  void supprimerArticle(Article article) {
    DatabaseClient().deleteArticle(article).then((value) {
      print('$value article supprimé.');
      listeArticles();
    });
  }
}