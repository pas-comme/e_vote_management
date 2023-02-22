part of 'candidat_bloc.dart';

@immutable
abstract class CandidatState extends Equatable {
  const CandidatState();
}

class CandidatInitial extends CandidatState {
  @override
  List<Object> get props => [];
}
class CandidatErrorState extends CandidatState {
  String erreur;
  CandidatErrorState(this.erreur);

  @override
  List<Object> get props => [erreur];
}
class CandidatVideState extends CandidatState {
  String erreur;
  CandidatVideState(this.erreur);

  @override
  List<Object> get props => [erreur];
}
class CandidatLoadedState extends CandidatState {
  final List<Personne> candidats;
  const CandidatLoadedState(this.candidats);
  @override
  List<Object> get props => [candidats];
}