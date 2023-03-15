
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../Repository/Personne.dart';
import '../Repository/Repository.dart';

part 'resultat_event.dart';
part 'resultat_state.dart';

class ResultatBloc extends Bloc<ResultatEvent, ResultatState> {
  final ResultatRepository resultatRepository;
  ResultatBloc(this.resultatRepository) : super(ResultatInitial()) {
    on<GetResultat>((event, emit) async {
      emit(ResultatInitial());


      final infos = await ResultatRepository(event.id).getCandidat();
      final candidats = await ResultatRepository(event.id).get();
      final resulats = await ResultatRepository(event.id).getResultat();
      emit(ResultatLoadedState(infos, resulats, candidats));

      if(resultatRepository.getCandidat() == []){
        emit(ResultatVideState("d"));
        print("vide");
      }
      else {
        try {
          final infos = await ResultatRepository(event.id).getCandidat();
          final candidats = await ResultatRepository(event.id).get();
          final resulats = await ResultatRepository(event.id).getResultat();
          emit(ResultatLoadedState(infos, resulats, candidats));
        }
        catch (e) {
          if( e is FormatException){
            emit(ResultatVideState("erreur"));
            print(e.message);
          }else {
            emit(ResultatErrorState(e.toString()));
          }
        }
      }
    });
  }
}
