part of 'electeur_bloc.dart';
@immutable
abstract class ElecteurState extends Equatable {
  const ElecteurState();
}

class ElecteurInitial extends ElecteurState {
  @override
  List<Object> get props => [];
}

class ElecteurErrorState extends ElecteurState {
  String erreur;
  ElecteurErrorState(this.erreur);

  @override
  List<Object> get props => [erreur];
}
class ElecteurVideState extends ElecteurState {
  String erreur;
  ElecteurVideState(this.erreur);

  @override
  List<Object> get props => [erreur];
}
class ElecteurLoadedState extends ElecteurState {
  final List<Personne> electeurs;
  const ElecteurLoadedState(this.electeurs);
  @override
  List<Object> get props => [electeurs];
}
