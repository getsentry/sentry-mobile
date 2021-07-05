import 'package:json_annotation/json_annotation.dart';
import 'stat.dart';

part 'stats.g.dart';

@JsonSerializable()
class Stats {
  Stats(this.stats24h, this.stats14d);
  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  @JsonKey(name: '24h', fromJson: Stat.fromJsonList, toJson: Stat.toJsonList)
  final List<Stat>? stats24h;

  @JsonKey(name: '14d', fromJson: Stat.fromJsonList, toJson: Stat.toJsonList)
  final List<Stat>? stats14d;

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
