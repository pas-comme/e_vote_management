
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../Repository/Personne.dart';
import '../Repository/Repository.dart';

part 'resultat_event.dart';
part 'resultat_state.dart';

class ResultatBloc extends Bloc<ResultatEvent, ResultatState> {
  final ResultatRepository resultatRepository;
  ResultatBloc(this.resultatRepository) : super(ResultatInitial()) {
    on<GetResultat>((event, emit) async {
      emit(ResultatInitial());
      if(resultatRepository.getCandidat() == []){
        emit(ResultatVideState("d"));
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
          }else {
            emit(ResultatErrorState(e.toString()));
          }
        }
      }
    });
  }
}
