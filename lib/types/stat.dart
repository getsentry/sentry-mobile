class Stat {
  Stat(this.timestamp, this.value);
  Stat.fromJson(List json)
      : timestamp = json.map((e) => e as int).first,
        value = json.map((e) => e as int).last;

  int timestamp;
  int value;

  static List<Stat>? fromJsonList(List<List>? json) {
    if (json == null) {
      return null;
    }
    return json.map((e) => Stat.fromJson(e)).toList();
  }

  static List<dynamic>? toJsonList(List<Stat>? json) {
    if (json == null) {
      return null;
    }
    return json.map((e) => [e.timestamp, e.value]).toList();
  }

  @override
  String toString() {
    return 'Stat(timestamp: $timestamp, value: $value)';
  }
}
