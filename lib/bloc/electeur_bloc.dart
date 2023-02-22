
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../Repository/Personne.dart';
import '../Repository/Repository.dart';

part 'electeur_event.dart';
part 'electeur_state.dart';

class ElecteurBloc extends Bloc<ElecteurEvent, ElecteurState> {
  final ElecteurRepository electeurRepository;
  ElecteurBloc(this.electeurRepository) : super(ElecteurInitial()) {
    on<GetAllElecteur>((event, emit) async {
      emit(ElecteurInitial());
      if(electeurRepository.getElecteur() == []){
        emit(ElecteurVideState("d"));
      }
      else {
        try {
          final electeurs = await ElecteurRepository(event.id).getElecteur();
          emit(ElecteurLoadedState(electeurs));
        }
        catch (e) {
          if( e is FormatException){
            emit(ElecteurVideState("erreur"));
          }else {
            emit(ElecteurErrorState(e.toString()));
          }
        }
      }
    });
  }
}
