import 'dart:math';

extension ListExtension<T> on List<T> {
  List<T> get deepCopy => [...this];
  List<T> ifEmpty(List<T> Function() ifEmpty) => isEmpty ? ifEmpty() : this;

  T? lastWhereOrNull(bool Function(T item) test) {
    for (int i = length - 1; i >= 0; i--) {
      final item = this[i];
      if (test(item)) return item;
    }
    return null;
  }

  T get eighth => this[7];
  T get fifth => this[4];
  T get fourth => this[3];
  T get random => this[Random().nextInt(length)];
  T get second => this[1];
  T get seventh => this[6];
  T get sixth => this[5];
  T get third => this[2];

  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;

  T? indexOrNull(int index) => index >= 0 && index < length ? this[index] : null;

  bool get isMoreThanOne => length > 1;
  bool get isOne => length == 1;
  bool get lengthIsUneven => !length.isEven;

  String get asId {
    if (isEmpty) return '';
    return map((e) => e.toString()).join('_');
  }

  List<T> randomValues(int quantity) {
    final random = Random();
    final list = <T>[];
    while (list.length < quantity) {
      final value = this[random.nextInt(length)];
      if (!list.contains(value)) {
        list.add(value);
      }
    }
    return list;
  }

  List<T> safeSublist(int start, int end) {
    if (start < 0) start = 0;
    if (end > length) end = length;
    return sublist(start, end);
  }

  void startAt(int index) {
    if (index < 0 || index >= length) return;
    final sublist = this.sublist(index);
    sublist.addAll(this.sublist(0, index));
    for (int i = 0; i < length; i++) {
      this[i] = sublist[i];
    }
  }

  bool isDeepSame(List<T> other) {
    if (length != other.length) return false;
    for (int i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }

  List<T> atLeastFirstSeven({required T Function(int missingCount) orElse}) {
    int missingCount = length;
    if (length > 7) {
      return sublist(0, 7);
    } else if (length == 7) {
      return this;
    } else {
      final list = [...this];
      while (list.length < 7) {
        list.insert(0, orElse(missingCount));
        missingCount++;
      }
      return list;
    }
  }

  T get removeRandom {
    final random = Random().nextInt(length);
    final value = this[random];
    removeAt(random);
    return value;
  }

  int get countTrue {
    int count = 0;
    for (final value in this) {
      if (value is bool && value) {
        count++;
      }
    }
    return count;
  }

  bool get hasOneOrMoreTrue {
    for (final value in this) {
      if (value is bool && value) {
        return value;
      }
    }
    return false;
  }

  T? indexOrElse(int index, {required T? orElse}) {
    if (index >= 0 && index < length) return this[index];
    return orElse;
  }

  int? indexWhereOrNull({required bool Function(T element) where, int start = 0, int? skip}) {
    for (int i = start; i < length + start; i++) {
      final index = i % length;
      if (where(this[index])) {
        return index;
      }
    }
    return null;
  }

  Map<E, T> toIdMap<E extends Object>(E Function(T element) id) {
    final map = <E, T>{};
    for (final element in this) {
      map[id(element)] = element;
    }
    return map;
  }

  Map<E, List<T>> toIdListMap<E extends Object>(E Function(T element) id) {
    final map = <E, List<T>>{};
    for (final element in this) {
      map.putIfAbsent(id(element), () => []).add(element);
    }
    return map;
  }

  List<T> maxLength(int maxLength) {
    if (length <= maxLength) return this;
    return sublist(0, maxLength);
  }
}
