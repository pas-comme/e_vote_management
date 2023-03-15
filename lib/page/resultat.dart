
import 'dart:typed_data';

import 'package:e_vote_management/Repository/Repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Repository/Personne.dart';
import '../bloc/resultat_bloc.dart';

class Resultat extends StatefulWidget{
  int? id;
  String? nom_election;

  Resultat(this.id, this.nom_election,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ResultatPage(id, nom_election);
}

class ResultatPage extends State<Resultat>{
  int? id;
  String? ids;
  String? nom_election;
  String retour = "";

  ResultatPage(this.id, this.nom_election);
  @override
  Widget build(BuildContext context) {
    final avatarSize = MediaQuery.of(context).size.width * 0.2;
    return MultiBlocProvider(
        providers: [
          BlocProvider<ResultatBloc>(create:(BuildContext context) => ResultatBloc(ResultatRepository(id)),)],
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Résultat de vote \npour $nom_election", textAlign: TextAlign.center),
          ),
          body : BlocProvider(
            create: (context) => ResultatBloc(ResultatRepository(id))..add(GetResultat(id)),
            child: BlocBuilder<ResultatBloc, ResultatState>(
                builder: (context, state) {
                  if(state is ResultatInitial){
                    return const Center( child: CircularProgressIndicator());
                  }
                  else if(state is ResultatVideState){
                    return const Center(child: Text("aucun candidat inscrit pour le moment"));
                  }
                  else if(state is ResultatLoadedState){
                    List<Personne> personneLIST = state.infos;
                    List<dynamic> resultatVOTE = state.resultat;
                    List<Candidat> candidats = state.candidats;
                    return Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: Card(
                                  color: Colors.grey,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            resultatVOTE[1] == "fin" ? const Text("Le temps de vote de cette éléction est terminé, en voici les statistiques",
                                                style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold, color: Colors.white) ):
                                            Row(
                                                children: const [Text("Cette éléction est encore encours.... ",
                                                    style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold, color: Colors.white,  )),
                                                  Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                      child: CircularProgressIndicator()),
                                                  Text("Mais on peut déjà afficher les statistiques suivantes",
                                                      style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold, color: Colors.white,  )),]),
                                            Text("taux de participation : ${(resultatVOTE[2] / resultatVOTE[0] * 100).toStringAsFixed(2)}%      soit : ${resultatVOTE[2]} / ${resultatVOTE[0]}",
                                              style: const TextStyle(fontSize: 20, fontWeight:FontWeight.bold, color: Colors.white ), textAlign: TextAlign.start,),

                                          ]),
                                    ),
                                  )
                              )
                          ),
                          const Center(child: Text("Voici les sufrages de chaque candidat", style: TextStyle(fontSize: 22, fontWeight:FontWeight.bold))),
                          Expanded(
                            child: ListView.builder(

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
                                            "PROFESSION : ${personneLIST[index].asa}      ADRESSE : ${personneLIST[index].adiresy}      CONTACT : ${personneLIST[index].phone}",),
                                        trailing: Card(child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                          child: Text("VOTE : \n "
                                              "${candidats[index].vato}  /  ${resultatVOTE[0]}     soit : ${(candidats[index].vato / resultatVOTE[0] * 100 ).toStringAsFixed(2)}%", textAlign: TextAlign.center,),
                                        ),),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ]
                    );
                  }
                  else if(state is ResultatErrorState){
                    return  Center(child: Text(state.erreur),);
                  }
                  else{
                    return const Center(child: Text("aucun candidat inscrit pour le moment oooooo..."),);
                  }
                }

            ),),
        ));
  }
}



