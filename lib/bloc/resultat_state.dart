part of 'resultat_bloc.dart';
@immutable
abstract class ResultatState extends Equatable {
  const ResultatState();
}

class ResultatInitial extends ResultatState {
  @override
  List<Object> get props => [];
}

class ResultatErrorState extends ResultatState {
  String erreur;
  ResultatErrorState(this.erreur);

  @override
  List<Object> get props => [erreur];
}
class ResultatVideState extends ResultatState {
  String erreur;
  ResultatVideState(this.erreur);

  @override
  List<Object> get props => [erreur];
}
class ResultatLoadedState extends ResultatState {
  final List<Personne> infos;
  final List<dynamic> resultat;
  final List<Candidat> candidats;
  const ResultatLoadedState(this.infos, this.resultat, this.candidats);
  @override
  List<Object> get props => [infos, resultat, candidats];
}
