

import 'package:flutter/material.dart';
import 'package:flutter_je_veux/model/databaseClient.dart';
import 'package:flutter_je_veux/model/item.dart';
import 'package:flutter_je_veux/widgets/donnees_vides.dart';
import 'package:flutter_je_veux/widgets/item_detail.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  String nouvelleListe;
  List<Item> items;


  @override
  void initState() {
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          new FlatButton(onPressed: () => ajouter(null), child: new Text("Ajouter", style: new TextStyle(color: Colors.white),))
        ],
      ),
      body: items == null || items.length == 0 ? new DonneesVides()
          :
      new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i){
          Item item = items[i];
          return new ListTile(
            title: new Text(item.nom),
            trailing: new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: (){
                  DatabaseClient().deleteItem(item.id, "item").then((int) => recuperer());
                }),
            leading: new IconButton(
                icon: new Icon(Icons.edit),
                onPressed: (){
                  ajouter(item);
                }),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext){
                return new ItemDetail(item);
              }));
            },
          );
        },
      )

    );
  }

  Future<Null> ajouter(Item item) async {
    TextEditingController controller = new TextEditingController(text: item != null ? item.nom : null);
    await showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext){
          return new AlertDialog(
            title: new Text("Ajouter une liste de souhaits"),
            content: new TextField(
              controller: controller,
              decoration: new InputDecoration(
                  labelText: "Liste:",
                  hintText: "ex: mes prochains jeux vidéos"
              ),
              autofocus: true,

              onChanged: (String str){
                nouvelleListe = str;
              },

            ),
            actions: [
              new FlatButton(
                  onPressed: () => Navigator.pop(buildContext),
                  child: new Text("Annuler")),
              new FlatButton(
                  onPressed: () {
                    if(nouvelleListe != null && nouvelleListe.isNotEmpty){
                      if(item == null){
                        item = new Item();
                        Map<String, dynamic> map = {
                          "nom": nouvelleListe
                        };
                        item.fromMap(map);
                      }else{
                        item.nom = nouvelleListe;
                      }

                      DatabaseClient().upsertItem(item).then((value) => recuperer());
                      nouvelleListe = null;
                    }

                    Navigator.pop(buildContext);
                  },
                  child: new Text("Valider", style: new TextStyle(color: Colors.blue),))
            ],
          );
        }

    );
  }

  void recuperer() {
    DatabaseClient().allItem().then((items){
      setState(() {
        this.items = items;
      });
    });
  }
}
