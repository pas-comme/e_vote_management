import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Personne.dart';

// classe permettant de récupérer les informations des candidats
class CandidatRepository{
  int? id_election;
  CandidatRepository(this.id_election);
  Future<List<Personne>>  getCandidat()async{

    String? ids = "";
    List<Candidat> candidatsLIST = [];

    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/candidats.php?id=$id_election"));
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/candidats.php?id=$id_election"));

    var temp = json.decode(reponse.body);
    for(Map i in temp){
      candidatsLIST.add(Candidat.fromJson(i));
    }

    for(Candidat temp in candidatsLIST){
      if (ids == "") {
        ids = "${temp.idPRS}";
      } else{
        ids = "$ids||id=${temp.idPRS}";
      }
    }

    //requette vers l'API de gestion des identités des citoyens
    var response1 = await http.get(Uri.parse("http://10.42.0.1/API/citizens/specials.php?id=$ids"));
    //var response1 = await http.get(Uri.parse("http://localhost/API/citizens/specials.php?id=$ids"));

    List prs = json.decode(response1.body);
    if(prs.isEmpty){
      return [];
    }
    return prs.map((e) => Personne.fromJson(e)).toList();
  }

}

// classe permettant de récupérer le résultat des élections
class ResultatRepository{
  int? id_election;
  late List<Candidat> candidatsLIST = [] ;
  ResultatRepository(this.id_election);
  //fonction de récupération de liste des candidats
  Future<List<Candidat>>  get()async {
    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/candidats.php?id=$id_election"));
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/candidats.php?id=$id_election"));

    var temp = json.decode(reponse.body);

    for (Map i in temp) {
      candidatsLIST.add(Candidat.fromJson(i));
    }
    return candidatsLIST;
  }
  //fonction de récupération des informations des candidats
  Future<List<Personne>>getCandidat()async{

    String? ids = "";

    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/candidats.php?id=$id_election"));
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/candidats.php?id=$id_election"));

    var temp = json.decode(reponse.body);

    for(Map i in temp){
      candidatsLIST.add(Candidat.fromJson(i));
    }


    for(Candidat temp in candidatsLIST){
      if (ids == "") {
        ids = "${temp.idPRS}";
      } else{
        ids = "$ids||id=${temp.idPRS}";
      }
    }
    //requette vers l'API de gestion des identités des citoyens
    var response1 = await http.get(Uri.parse("http://10.42.0.1/API/citizens/specials.php?id=$ids"));
    //var response1 = await http.get(Uri.parse("http://localhost/API/citizens/specials.php?id=$ids"));

    List prs = json.decode(response1.body);
    if(prs.isEmpty){
      List<Personne> vide = [];
      print ("liste vide");
      return vide;
    }
    return prs.map((e) => Personne.fromJson(e)).toList();
  }
  // fonction récupérant les détails de l'élection après les votes
  Future<List<dynamic>>  getResultat()async{
    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/resultat.php?id=$id_election"));
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/resultat.php?id=$id_election"));
   return json.decode(reponse.body) as List<dynamic>;
  }



}
// classe permettant de récupérer le résultat des électeurs
class ElecteurRepository {
  int? id_election;

  ElecteurRepository(this.id_election);

  Future<List<Personne>> getElecteur() async {
    String? ids = "";
    List<Electeur> electeurLIST = [];

    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/electeurs.php?id=$id_election"));
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/electeurs.php?id=$id_election"));

    var temp = json.decode(reponse.body);
    for (Map i in temp) {
      electeurLIST.add(Electeur.fromJson(i));
    }

    for (Electeur temp in electeurLIST) {
      if (ids == "") {
        ids = "${temp.idPRS}";
      } else {
        ids = "$ids||id=${temp.idPRS}";
      }
    }
    print("id = $ids");
    var response1 = await http.get(Uri.parse("http://10.42.0.1/API/citizens/specials.php?id=$ids"));
    //var response1 = await http.get(Uri.parse("http://localhost/API/citizens/specials.php?id=$ids"));

    List prs = json.decode(response1.body);
    return prs.map((e) => Personne.fromJson(e)).toList();
  }
}
// classe servant de structure de données pour les candidats
class Candidat{
  int idPRS = 0;
  int? id_election;
  int vato = 0;
  Candidat(this.idPRS, this.id_election, this.vato);

  // méthode de convertion de json en dart
  Candidat.fromJson(dynamic json){
    idPRS = json['idPRS'];
    id_election = json['id_election'];
    vato = json['vato'];
  }
}
// classe servant de structure de données pour les électeurs
class Electeur{
  int? idPRS;
  int? id;
  int? id_election;
  Electeur(this.id, this.idPRS, this.id_election);

  // méthode de convertion de json en dart
  Electeur.fromJson(dynamic json){
    id = json['id'];
    idPRS = json['idPRS'];
    id_election = json['id_election'];
  }
}
