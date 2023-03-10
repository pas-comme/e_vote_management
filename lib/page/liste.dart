import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'candidature.dart';
import 'electeurs.dart';

class Liste extends StatefulWidget{
  Liste({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListeScreen();

}
enum OPTIONS {candidature, electeurs, desactiver, resultats, lancer, archiver}

class _ListeScreen extends State<Liste>{
  List<Element> liste = [];
  bool active = false;
  int _currentIndex1 = 0;
  int _currentIndex2 = 0;


  Future<List<Element>> getLIST()async{
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/pollings.php" ));
    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/pollings.php" ));
    liste.clear();
    var temp = json.decode(reponse.body);
    for(Map i in temp){
      liste.add(Element.fromJson(i));
    }
    return liste;
  }

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

                      var reponse = await http.put(Uri.parse("http://10.42.0.1/API/polling/activePolling.php?id=$id"));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reponse.body,
                          textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
                      Navigator.of(context).pop();
                    }
                    else if(index == 1){

                      var reponse = await http.put(Uri.parse("http://10.42.0.1/API/polling/desactivePolling.php?id=$id"));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reponse.body,
                          textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
                      Navigator.of(context).pop();
                    }
                    else{
                      Navigator.of(context).pop();
                    }
                  },
                  currentIndex: _currentIndex1,
                  elevation: 0.0,
                  //backgroundColor: Colors.transparent,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.not_started), label:"Activer cette ??lection" ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_active), label:"D??sactiver cette ??lection" ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive), label:"achiver cette ??lection" ),
                  ],),
                BottomNavigationBar(
                  //backgroundColor: Colors.transparent,
                  onTap: (index){
                    if(index == 0){
                      var route = MaterialPageRoute(builder: (BuildContext context)=>Candidature(id, titre));
                      Navigator.of(context).push(route);
                    }
                    else if(index == 1){
                      var route = MaterialPageRoute(builder: (BuildContext context)=>Electeurs(id, titre));
                      Navigator.of(context).push(route);
                    }
                    else{
                    Navigator.pop(context, OPTIONS.resultats);
                    }
                  },
                  currentIndex: _currentIndex2,
                  elevation: 0.0,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.accessibility_new), label:"Liste des candidats de cette ??lection" ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.app_registration), label:"Liste des ??lecteurs de cette ??lection" ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.leaderboard), label:"Voir r??sultat de cette ??lection" ),
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

      body : //liste.isEmpty ? const Center(child: Text("aucune ??l??ction pertinante pour le moment"),) :
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
              return ListTile(
                onTap: (){
                  electionOptions(liste[index].id, liste[index].nom.toString(), );
                },
                leading: Text(liste[index].nom.toString()),
                title: Text(liste[index].domaine.toString()),
                subtitle: Text(liste[index].description.toString()),
              );
            }
          );
        }
      }),
    );
  }
}
class Element {
  int? id;
  String? nom;
  String? domaine;
  String? description;
  Element({this.id,  this.domaine,  this.nom, this.description});

  Element.fromJson(dynamic json){
    id =  json['id'];
    nom = json['nom'];
    domaine = json['domaine'];
    description = json['description'];
  }
}