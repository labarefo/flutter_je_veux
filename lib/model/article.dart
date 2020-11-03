

class Article {
  int id;
  String nom;
  int item;
  var prix;
  String magasin;
  String image;

  Article();

  void fromMap(Map<String, dynamic> map){
    this.id = map["id"];
    this.nom = map["nom"];
    this.item = map["item"];
    this.prix = map["prix"];
    this.magasin = map["magasin"];
    this.image = map["image"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "item":    this.item,
      "prix":    this.prix ,
      "magasin": this.magasin,
      "image":   this.image
    };
    if(this.id != null){
      map["id"] = this.id;
    }

    return map;
  }
}