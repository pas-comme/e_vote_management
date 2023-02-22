import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Personne.dart';

class Candidature extends StatefulWidget{
  int? id;
  String? nom_election;

  Candidature(this.id, this.nom_election, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CandidatPage(id, nom_election);
}

class CandidatPage extends State<Candidature>{
  int? id_election;
  String? nom_election;
  String? ids = "";
  var id_candidat;
  String retour = "";

  CandidatPage(id, this.nom_election){
    id_election = id;
  }

  List<Candidat> candidatsLIST = [];
  List<Personne> personneLIST = [];
   newCandidat()async {

      await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR).then((value) => retour = value);
      if(retour!=""){
        final Map<String, dynamic> data = <String, dynamic>{};
        data['idPRS'] = retour;
        data['id_election'] = id_election;
        Uri url = Uri.parse("http://10.42.0.1/API/polling/newCandidat.php?");
        var reponse = await http.post(url, body: data);
        if(reponse.statusCode == 200){
          print(reponse.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reponse.body,
              textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("statuscode = ${reponse.statusCode} and response = ${reponse.body}",
              textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
        }
      }
  }

  Future<List<Personne>>  getCandidat()async{
    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/candidats.php?id=$id_election"));
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/candidats.php?id=$id_election"));
    print("id_election $id_election");
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
    print("candidat : $candidatsLIST");

      print("id : $ids");
        if(ids != "") {
          var response1 = await http.get(Uri.parse("http://10.42.0.1/API/citizens/specials.php?id=$ids"));
          //var reponse1 = await http.get(Uri.parse("http://localhost/API/citizens/specials.php?id=$ids"));
          print("code / ${response1.statusCode}");
          var prs = json.decode(response1.body);
          //var prs = reponse1.body;

          for (Map x in prs) {
            personneLIST.add(Personne.fromJson(x));
          }
          print("personne : $personneLIST");
      }

    print("personne : $personneLIST");
    return personneLIST;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LISTE DES CANDIDATS POUR $nom_election"),
      ),
      body :  //personneLIST.isEmpty ? const Center(child: Text("aucun candidat pour le moment"),) :
      FutureBuilder(
              future: getCandidat(),
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
                          //leading: CircleAvatar(child: Image.memory(base64Decode(personneLIST[index].image.toString()))),
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
                onPressed : () async => newCandidat(),
                child: const Text("ajouter un nouveau candidat"),
              ),
            ),

             */

        );

  }

}
class Candidat{
  int idPRS = 0;
  int? id_election;
  Double? vato;
  Candidat(this.idPRS, this.id_election, this.vato);
  Candidat.fromJson(dynamic json){
    idPRS = json['idPRS'];
    id_election = json['id_election'];
    vato = json['vato'];
  }
}


