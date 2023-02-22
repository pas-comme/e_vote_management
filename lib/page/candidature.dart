
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
                builder: (context, state) {
                  if(state is CandidatInitial){
                    return const Center( child: CircularProgressIndicator());
                  }
                  else if(state is CandidatVideState){
                    return const Center(child: Text("aucun candidat inscrit pour le moment"));
                  }
                  else if(state is CandidatLoadedState){
                    List<Personne> personneLIST = state.candidats;
                    return  ListView.builder(
                        itemCount: personneLIST.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: Card(
                              color: Theme.of(context).primaryColor,
                              child: ListTile(
                                  leading: CircleAvatar(backgroundImage : MemoryImage( Uint8List.fromList(Personne.base64Decoder(personneLIST[index].image)))),
                                  title: Text("${personneLIST[index].anarana} ${personneLIST[index].fanampiny} "),
                                  subtitle: Text("AGE : ${personneLIST[index].daty}       SEXE : ${personneLIST[index].sexe.toString()} \n"
                                      "PROFESSION : ${personneLIST[index].asa}      ADRESSE : ${personneLIST[index].adiresy}      CONTACT : ${personneLIST[index].phone}",)
                              ),
                            ),
                          );
                        });
                  }
                  else if(state is CandidatErrorState){
                    return  Center(child: Text(state.erreur),);
                  }
                  else{
                    return const Center(child: Text("aucun candidat inscrit pour le moment"),);
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
              onPressed: newCandidat,
              child: const Text("ajouter un nouveau candidat"),
            ),
          ),
        ));
  }
}



