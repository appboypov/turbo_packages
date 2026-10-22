/// A runtime Option whose `toString` gives its [name].
final class Tag {
  const Tag(this.name, this.id);

  final String name;

  final int id;

  @override
  String toString() => name;
}
