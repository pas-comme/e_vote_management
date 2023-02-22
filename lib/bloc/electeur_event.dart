part of 'electeur_bloc.dart';
@immutable
abstract class ElecteurEvent extends Equatable {
  const ElecteurEvent();
}
class GetAllElecteur extends ElecteurEvent{
  int? id;
  GetAllElecteur(this.id);
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}