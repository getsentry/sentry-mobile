// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) {
  return Stats(
    Stat.fromJsonList(json['24h'] as List<List<dynamic>>),
    Stat.fromJsonList(json['14d'] as List<List<dynamic>>),
  );
}

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      '24h': Stat.toJsonList(instance.stats24h),
      '14d': Stat.toJsonList(instance.stats14d),
    };
