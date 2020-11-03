
import 'dart:core';
import 'dart:io';

import 'package:flutter_je_veux/model/article.dart';
import 'package:flutter_je_veux/model/item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseClient {

  Database _database;

  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database;
    }
    // créer cette database
    _database = await create();
    return _database;
  }

  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, "database.db");
    var bdd = await openDatabase(
        database_directory, version: 1, onCreate: _onCreate);

    return bdd;
  }


  Future _onCreate(Database db, int version) async {
    String sqlItem = '''
    CREATE TABLE item (
      id INTEGER PRIMARY KEY, 
      nom TEXT NOT NULL
      )
    ''';
    await db.execute(sqlItem);

    String sqlArticle = '''
    CREATE TABLE article (
      id INTEGER PRIMARY KEY, 
      nom TEXT NOT NULL,
      item INTEGER,
      prix TEXT,
      magasin TEXT,
      image TEXT
      )
    ''';
    await db.execute(sqlArticle);
  }

  /* ECRITURES DES DONNEES */


  Future<Item> ajoutItem(Item item) async {
    Database database = await getDatabase();
    item.id = await database.insert("item", item.toMap());

    return item;
  }

  Future<int> deleteItem (int id, String table) async{
    Database database = await getDatabase();
    await database.delete("article", where: "item = ?", whereArgs: [id]);
    return await database.delete(table, where: " id = ? ", whereArgs: [id]);
  }

  Future<Item> upsertItem(Item item) async {
    if(item.id == null){
      item = await ajoutItem(item);
    }else {
      await updateItem(item);
    }
    return item;
  }

  Future<int> updateItem(Item item) async {
    Database database = await getDatabase();
    return await database.update("item", item.toMap(), where: " id = ?", whereArgs: [item.id]);
  }

  /* LECTURE DES DONNEES */

  Future<List<Item>> allItem() async {
    Database database = await getDatabase();
    List<Map<String, dynamic>> resultat = await database.rawQuery('SELECT * FROM item');
    List<Item> items = [];
    resultat.forEach((map) {
      Item item = new Item();
      item.fromMap(map);
      items.add(item);
    });

    return items;
  }

  //Future<Article> findArticle(int item)

  Future<Article> upsertArticle(Article article) async {
    Database database = await getDatabase();
    if(article.id == null){
      article.id = await database.insert("article", article.toMap());
    }else{
      await database.update("article", article.toMap(), where: "id = ? ", whereArgs: [article.id]);
    }
    return article;
  }

  Future<List<Article>> allArticles(int item) async {
    Database database = await getDatabase();
    List<Map<String, dynamic>> resultat = await database.query("article", where: "item = ?", whereArgs: [item]);
    List<Article> articles = [];
    resultat.forEach((map) {
      Article article = new Article();
      article.fromMap(map);
      articles.add(article);
    });

    return articles;
  }

  Future<int> deleteArticle(Article article) async {
    Database database = await getDatabase();
    return await database.delete("article", where: "id = ?", whereArgs: [article.id]);
  }

}
