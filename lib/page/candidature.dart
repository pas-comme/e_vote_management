
import 'dart:typed_data';

import 'package:e_vote_management/Repository/Repository.dart';
import 'package:e_vote_management/bloc/candidat_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../Repository/Personne.dart';

class Candidature extends StatefulWidget{
  int? id;
  String? nom_election;

  Candidature(this.id, this.nom_election,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CandidaturePage(id, nom_election);
}

class CandidaturePage extends State<Candidature>{
  int? id;
  String? ids;
  String? nom_election;
  String retour = "";

  CandidaturePage(this.id, this.nom_election);
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  // méthode permettant d'ajouter un nouveau candidat
  newCandidat() async{
    await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR).then((value) => retour = value);
    if(retour!=""){
      final Map<String, dynamic> data = <String, dynamic>{};
      data['idPRS'] = retour;
      data['id_election'] = id.toString();
      Uri url = Uri.parse("http://10.42.0.1/API/polling/newCandidat.php?");
      var reponse = await http.post(url, body: data);
      if(reponse.statusCode == 200){

        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(reponse.body,
            textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("statuscode = ${reponse.statusCode} and response = ${reponse.body}",
            textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = MediaQuery.of(context).size.width * 0.2;
    return MultiBlocProvider(
        providers: [
          BlocProvider<CandidatBloc>(create:(BuildContext context) => CandidatBloc(CandidatRepository(id)),)],
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Liste des candidtas \npour $nom_election", textAlign: TextAlign.center),
          ),
          body : BlocProvider(
            create: (context) => CandidatBloc(CandidatRepository(id))..add(GetALlCandidat(id)),
            child: BlocBuilder<CandidatBloc, CandidatState>(
                //bloc: blocTEMP,
                builder: (context, state) {
                  if(state is CandidatInitial){ // ce qui s'affiche pendant le chargement des données
                    return  Center( child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [Text("LOADING.......", style: TextStyle(fontSize: 48, fontWeight:FontWeight.bold ),),
                          CircularProgressIndicator()]));
                  }
                  else if(state is CandidatVideState){  // ce qui s'affiche si les données sont vides
                    return const Center(child: Text("aucun candidat inscrit pour le moment"));
                  }
                  else if(state is CandidatLoadedState){ // ce qui s'affiche quand les données sont chargées
                    List<Personne> personneLIST = state.candidats;
                    return  ListView.builder(
                        itemCount: personneLIST.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                            child: Card(
                              color: Theme.of(context).primaryColor,
                              child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                  horizontalTitleGap: -avatarSize / 14,
                                  leading: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                    children: [CircleAvatar(
                                        radius: avatarSize / 2 ,
                                        foregroundImage : MemoryImage( Uint8List.fromList(Personne.base64Decoder(personneLIST[index].image)))),
                                  ]),
                                  title: Text("${personneLIST[index].anarana} ${personneLIST[index].fanampiny} "),
                                  subtitle: Text("AGE : ${personneLIST[index].daty}       SEXE : ${personneLIST[index].sexe.toString()} \n"
                                      "PROFESSION : ${personneLIST[index].asa}      ADRESSE : ${personneLIST[index].adiresy}      CONTACT : ${personneLIST[index].phone}",)
                              ),
                            ),
                          );
                        });
                  }
                  else if(state is CandidatErrorState){ // ce qui s'affiche en cas d'erreur
                    return  Center(child: Text(state.erreur),);
                  }
                  else{ // ce qui s'affiche dans d'autre cas
                    return const Center(child: Text("quelque chose ne marche pas"),);
                  }
                }

            ),),
          floatingActionButton: Container(
            alignment: AlignmentGeometry.lerp(Alignment.bottomCenter, Alignment.bottomCenter, 0.0) ,
            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                elevation: 5,
              ),
              onPressed : () {
                newCandidat();
                var route = MaterialPageRoute(builder: (BuildContext context)=>Candidature(id, nom_election));
                Navigator.of(context).replace(oldRoute: route, newRoute: route);
            },
              child: const Text("ajouter un nouveau candidat"),
            ),
          ),
        ));
  }
}



