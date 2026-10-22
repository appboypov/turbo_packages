/// A runtime Option whose `toString` gives `candidate_` and its [id].
final class Candidate {
  const Candidate(this.id);

  final int id;

  @override
  String toString() => 'candidate_$id';
}
