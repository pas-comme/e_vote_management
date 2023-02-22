
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../Repository/Repository.dart';
import '../Repository/Personne.dart';

part 'candidat_event.dart';
part 'candidat_state.dart';

class CandidatBloc extends Bloc<CandidatEvent, CandidatState> {
  final CandidatRepository candidiatRepository;
  CandidatBloc(this.candidiatRepository) : super(CandidatInitial()) {
    on<GetALlCandidat>((event, emit) async {
      emit(CandidatInitial());
      if(candidiatRepository.getCandidat() == []){
        emit(CandidatVideState(""));
      }else {
        try {
          final candidats = await CandidatRepository(event.id).getCandidat();
          emit(CandidatLoadedState(candidats));
        }
        catch (e) {
          if( e is FormatException){
            emit(CandidatVideState("erreur"));
          }else {
            emit(CandidatErrorState(e.toString()));
          }
        }
      }

    });
  }
}
