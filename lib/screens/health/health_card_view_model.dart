import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/crash_free_formatting.dart';
import '../../utils/sentry_colors.dart';
import '../../utils/sentry_icons.dart';

class HealthCardViewModel {
  HealthCardViewModel(this.value, this.change);

  HealthCardViewModel.crashFreeSessions(double? value, double? valueBefore) {
    color = colorForValue(value);
    if (value != null) {
      this.value = value.formattedPercent();
    } else {
      this.value = '--';
    }
    if (value != null && valueBefore != null && value != valueBefore) {
      final changeValue = value - valueBefore;
      change = changeValue.formattedPercentChange();
      trendIcon = getTrendIcon(changeValue);
    } else {
      change = '--';
    }
  }

  HealthCardViewModel.crashFreeUsers(double? value, double? valueBefore) {
    color = colorForValue(value);
    if (value != null) {
      this.value = value.formattedPercent();
    } else {
      this.value = '--';
    }
    if (value != null && valueBefore != null && value != valueBefore) {
      final changeValue = value - valueBefore;
      change = changeValue.formattedPercentChange();
      trendIcon = getTrendIcon(changeValue);
    } else {
      change = '--';
    }
  }

  HealthCardViewModel.apdex(double? value, double? valueBefore) {
    color = value == null ? SentryColors.lavenderGray : SentryColors.revolver;
    if (value != null) {
      this.value = valueFormatApdex.format(value);
    } else {
      this.value = '--';
    }
    if (value != null && valueBefore != null && value != valueBefore) {
      final changeValue = value - valueBefore;
      final trendSign = changeValue > 0 ? '+' : '';
      change = trendSign + valueFormatApdex.format(changeValue);
      trendIcon = getTrendIcon(changeValue);
    } else {
      change = '--';
    }
  }

  static final valueFormatApdex = NumberFormat('#.###');
  static const warningThreshold = 99.5;
  static const dangerThreshold = 98;

  late Color color;
  late String value;

  late String change;
  Icon? trendIcon;

  static Color colorForValue(double? value) {
    return value == null
        ? SentryColors.lavenderGray
        : value > warningThreshold
            ? SentryColors.shamrock
            : value > dangerThreshold
                ? SentryColors.lightningYellow
                : SentryColors.burntSienna;
  }

  static Icon? getTrendIcon(double? change) {
    if (change == null || change == 0) {
      return null;
    }
    return change > 0
        ? Icon(SentryIcons.trend_up, color: SentryColors.shamrock, size: 8.0)
        : Icon(SentryIcons.trend_down,
            color: SentryColors.burntSienna, size: 8.0);
  }
}
