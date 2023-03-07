import 'dart:convert';

import 'package:e_vote_management/page/resultat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'candidature.dart';
import 'electeurs.dart';

class Liste extends StatefulWidget{
  const Liste({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListeScreen();
}
class _ListeScreen extends State<Liste>{
  List<Element> liste = [];
  bool active = false;
  final int _currentIndex0 = 0;
  final int _currentIndex1 = 0;
  final int _currentIndex2 = 0;

 //méthode récupérant la liste des éléctions non-arvhivées
  Future<List<Element>> getLIST()async{
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/pollings.php?voting=0" ));
    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/pollings.php?voting=0" ));
    liste.clear();
    var temp = json.decode(reponse.body);
    for(Map i in temp){
      liste.add(Element.fromJson(i));
    }
    return liste;
  }

  // fonction permetant de afficher une fenetre de dialogue après click sur une élection
  void electionOptions(int? id, String titre,) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.center,),
          //backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          content: Container(
            padding: const EdgeInsets.all(15),
            //decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/15.png'), fit: BoxFit.fill,),),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BottomNavigationBar(
                  onTap: (index) async{
                    if(index == 0){
                      //var reponse = await http.put(Uri.parse("http://localhost/API/polling/activePolling.php?id=$id"));
                      var reponse = await http.put(Uri.parse("http://10.42.0.1/API/polling/activePolling.php?id=$id"));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reponse.body,
                          textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
                      Navigator.of(context).pop();
                    }
                    else if(index == 1){
                      //var reponse = await http.put(Uri.parse("http://localhost/API/polling/desactivePolling.php?id=$id"));
                      var reponse = await http.put(Uri.parse("http://10.42.0.1/API/polling/desactivePolling.php?id=$id"));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reponse.body,
                          textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
                      Navigator.of(context).pop();
                    }
                  },
                  currentIndex: _currentIndex0,
                  elevation: 0.0,
                  //backgroundColor: Colors.transparent,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.not_started), label:"Activer cette élection" ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_active), label:"Désactiver cette élection" ),
                  ],),
                BottomNavigationBar(
                  //backgroundColor: Colors.transparent,
                  onTap: (index) async {
                    if(index == 0){
                      //var reponse = await http.put(Uri.parse("http://localhost/API/polling/desactivePolling.php?id=$id"));
                      var reponse = await http.put(Uri.parse("http://10.42.0.1/API/polling/archivePolling.php?id=$id"));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reponse.body,
                          textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
                      Navigator.of(context).pop();
                    }
                    else if(index == 1){
                      var route = MaterialPageRoute(builder: (BuildContext context)=>Electeurs(id, titre));
                      Navigator.of(context).push(route);
                    }
                  },
                  currentIndex: _currentIndex1,
                  elevation: 0.0,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive), label:"achiver cette élection" ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.app_registration), label:"Liste des électeurs de cette élection" ),

                  ],),
                BottomNavigationBar(
                  //backgroundColor: Colors.transparent,
                  onTap: (index){
                    if(index == 0){
                      var route = MaterialPageRoute(builder: (BuildContext context)=>Candidature(id, titre));
                      Navigator.of(context).push(route);
                    }
                    else if(index == 1){
                      var route = MaterialPageRoute(builder: (BuildContext context)=>Resultat(id, titre));
                      Navigator.of(context).push(route);
                    }
                  },
                  currentIndex: _currentIndex2,
                  elevation: 0.0,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.accessibility_new), label:"Liste des candidats de cette élection" ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.leaderboard), label:"Voir résultat de cette élection" ),
                  ],),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body : //liste.isEmpty ? const Center(child: Text("aucune éléction pertinante pour le moment"),) :
      FutureBuilder(
        future: getLIST(),
        builder:  (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text("LOADING.......", style: TextStyle(fontSize: 48, fontWeight:FontWeight.bold ),),
                  CircularProgressIndicator()]));
          } else{
            return ListView.builder(
            itemCount: liste.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  onTap: (){
                    electionOptions(liste[index].id, liste[index].nom.toString(), );
                  },
                  leading: Text(liste[index].nom.toString()),
                  title: Text(liste[index].domaine.toString()),
                  subtitle: Text(liste[index].description.toString()),
                ),
              );
            }
          );
        }
      }),
    );
  }
}
// classe servant de structure de données pour les élections
class Element {
  int? id;
  String? nom;
  String? domaine;
  String? description;
  Element({this.id,  this.domaine,  this.nom, this.description});

  // méthode de convertion de jsnon en dart
  Element.fromJson(dynamic json){
    id =  json['id'];
    nom = json['nom'];
    domaine = json['domaine'];
    description = json['description'];
  }
}