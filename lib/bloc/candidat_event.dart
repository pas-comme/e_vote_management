part of 'candidat_bloc.dart';
@immutable
abstract class CandidatEvent extends Equatable {
  const CandidatEvent();
}

class GetALlCandidat extends CandidatEvent{
  int? id;
  GetALlCandidat(this.id);
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
