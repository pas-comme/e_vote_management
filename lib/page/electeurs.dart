import 'dart:typed_data';

import 'package:e_vote_management/Repository/Repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../Repository/Personne.dart';
import '../bloc/electeur_bloc.dart';

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

  ElecteurPage(this.id_election, this.nom_election);

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  newElecteur() async{
    await FlutterBarcodeScanner.scanBarcode('#eeeeee', 'Cancel', true, ScanMode.QR).then((value) => retour = value);
    if(retour!=""){
      final Map<String, dynamic> data = <String, dynamic>{};
      data['idPRS'] = retour;
      data['id_election'] = id_election.toString();
      Uri url = Uri.parse("http://10.42.0.1/API/polling/newElecteur.php?");
      var reponse = await http.post(url, body: data);
      if(reponse.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reponse.body,
            textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("statuscode = ${reponse.statusCode} and response = ${reponse.body}",
            textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
      }
    }
    context.read<ElecteurBloc>().add(GetAllElecteur(id_election));
  }
  @override
  Widget build(BuildContext context) {
    final avatarSize = MediaQuery.of(context).size.width * 0.2;
    return MultiBlocProvider(
        providers: [
          BlocProvider<ElecteurBloc>(create:(BuildContext context) => ElecteurBloc(ElecteurRepository(id_election)),)],
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Liste des electeurs \npour $nom_election", textAlign: TextAlign.center),
          ),
          body : BlocProvider(
            create: (context) => ElecteurBloc(ElecteurRepository(id_election))..add(GetAllElecteur(id_election)),
            child: BlocBuilder<ElecteurBloc, ElecteurState>(

                builder: (context, state) {
                  if(state is ElecteurInitial){
                    return const Center( child: CircularProgressIndicator());
                  }
                  else if(state is ElecteurLoadedState){
                    List<Personne> personneLIST = state.electeurs;
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
                                      children: [
                                    CircleAvatar(
                                        radius: avatarSize / 2 ,
                                        foregroundImage : MemoryImage( Uint8List.fromList(Personne.base64Decoder(personneLIST[index].image))))]),
                                  title: Text("${personneLIST[index].anarana} ${personneLIST[index].fanampiny} "),
                                  subtitle: Text("AGE : ${personneLIST[index].daty}       SEXE : ${personneLIST[index].sexe.toString()} \n"
                                      "PROFESSION : ${personneLIST[index].asa}      ADRESSE : ${personneLIST[index].adiresy}      CONTACT : ${personneLIST[index].phone}",)
                              ),
                            ),
                          );
                        });
                  }
                  else if(state is ElecteurErrorState){
                    return  Center(child: Text(state.erreur),);
                  }
                  else if (state is ElecteurVideState){
                    return const Center(child: Text("aucun électeur inscrit pour le moment"),);
                  }
                  else{
                    return const Center(child: Text("aucun électeur inscrit pour le moment"),);
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
              onPressed: newElecteur,
              child: const Text("ajouter un nouveau electeur"),
            ),
          ),
        ));
  }
}