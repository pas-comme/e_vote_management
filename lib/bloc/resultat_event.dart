part of 'resultat_bloc.dart';

abstract class ResultatEvent extends Equatable {
  const ResultatEvent();
}
class GetResultat extends ResultatEvent{
  int? id;
  GetResultat(this.id);
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
