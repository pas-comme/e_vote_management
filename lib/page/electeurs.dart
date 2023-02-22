import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import 'Personne.dart';

class Electeurs extends StatefulWidget{
  int? id;
  String? nom_election;
  Electeurs(this.id, this.nom_election,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ElecteurPage(id, nom_election);
}

class ElecteurPage extends State<Electeurs>{
  int? id_election;
  String? ids;
  String? nom_election;
  String retour = "";

  ElecteurPage(id, this.nom_election){
    id_election = id;
  }

  List<Electeur> electeursLIST = [];
  List<Personne> personneLIST = [];
  newElecteur() async{
    await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR).then((value) => retour = value);
    if(retour!=""){
      final Map<String, dynamic> data = <String, dynamic>{};
      data['idPRS'] = retour;
      data['id_election'] = id_election;
      Uri url = Uri.parse("http://10.42.0.1/API/polling/newElecteur.php?");
      var reponse = await http.post(url, body: data);
      if(reponse.statusCode == 200){
        print(reponse.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("électeur ajouté",
            textAlign: TextAlign.center), shape: BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("statuscode = ${reponse.statusCode} and response = ${reponse.body}",
            textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
      }
    }
  }
  Future<List<Personne>> getElecteurs()async{
    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/electeurs.php?id=$id_election"));
    electeursLIST.clear();
    var temp = json.decode(reponse.body);
    for(Map i in temp){
      electeursLIST.add(Electeur.fromJson(i));
    }
    for(Electeur temp in electeursLIST){
      if (ids == "") {
        ids = "$temp.idPRS";
      } else{
        ids = "$ids||id=$temp.idPRS";
      }
    }
    print("candidat : $electeursLIST");
    print("personne : $personneLIST");
    if(ids != null){
      var reponse1 = await http.get(Uri.parse("http://10.42.0.1/citizens/specials.php?id=$ids"));
      var prs = json.decode(reponse1.body);
      for(Map i in prs){
        personneLIST.add(Personne.fromJson(i));
      }
    }
    return personneLIST;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LISTE DES ÉLECTEURS pour $nom_election"),
      ),
      body :  //personneLIST.isEmpty ? const Center(child: Text("aucun candidat pour le moment"),) :
      FutureBuilder(
          future: getElecteurs(),
          builder:  (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(child:
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("LOADING.......", style: TextStyle(fontSize: 48, fontWeight:FontWeight.bold ),),
                    CircularProgressIndicator()]));
            } else{
              return
                ListView.builder(
                    itemCount: personneLIST.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          //leading: CircleAvatar(child: Image.memory(base64Decode(personneLIST[index].image))),
                          title: Text(personneLIST[index].anarana.toString() + personneLIST[index].fanampiny.toString()),
                          subtitle: Text(personneLIST[index].sexe.toString()),
                          trailing: Text("Profession : ${personneLIST[index].asa}  Adresse : ${personneLIST[index].adiresy} Contact : ${personneLIST[index].phone}",)
                      );
                    });

            }
          }
      ),
      /*
      bottomSheet: Center(
        child: ElevatedButton(

          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
            padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
            elevation: 5,
          ),
          onPressed: newElecteur,
          child: const Text("ajouter un nouveau électeur"),
        ),
      ),

       */

    );

  }

}
class Electeur{
  int? idPRS;
  String? id_election;

  Electeur({int? idPRS, String? id_election, Double? vato}){
    this.idPRS = idPRS;
    this.id_election = id_election;
  }
  Electeur.fromJson(dynamic json){
    idPRS = json['idPRS'];
    id_election = json['id_election'];
  }
}
