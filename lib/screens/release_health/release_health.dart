import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/screens/chart/line_chart_data.dart';
import 'package:sentry_mobile/screens/chart/line_chart_point.dart';
import 'package:sentry_mobile/types/stat.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../redux/state/app_state.dart';
import '../../screens/chart/line_chart.dart';
import '../../screens/empty/empty_screen.dart';
import '../../screens/project_picker/project_picker.dart';
import '../../screens/release_health/release_health_data.dart';
import '../../utils/sentry_icons.dart';
import 'release_card.dart';
import 'release_health_chart_row.dart';
import 'release_health_view_model.dart';

class ReleaseHealth extends StatefulWidget {
  const ReleaseHealth({Key key}) : super(key: key);

  @override
  _ReleaseHealthState createState() => _ReleaseHealthState();
}

class _ReleaseHealthState extends State<ReleaseHealth> {
  int _index;

  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ReleaseHealthViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => ReleaseHealthViewModel.fromStore(store),
    );
  }

  Widget _content(ReleaseHealthViewModel viewModel) {
    viewModel.fetchProjectsIfNeeded();
    viewModel.fetchReleasesIfNeeded();

    if (viewModel.showProjectEmptyScreen) {
      return EmptyScreen(
        'Remain Calm',
        'You need at least one project to use this view.',
        () async {
          const url = 'https://sentry.io';
          if (await canLaunch(url)) {
            await launch(url);
          }
        }
      );
    } else if (viewModel.showReleaseEmptyScreen) {
      return EmptyScreen(
        'Remain Calm',
        'You need at least one bookmarked project to use this view.',
        () => {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => ProjectPicker()
            ),
          )
        }
      );
    } else if (viewModel.showLoadingScreen || viewModel.releases.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Color(0xff81B4FE)),
        ),
      );
    } else {

      WidgetsBinding.instance.addPostFrameCallback( ( Duration duration ) {
        if (viewModel.showLoadingScreen) {
          _refreshKey.currentState.show();
        } else {
          _refreshKey.currentState.deactivate();
        }
      });

      final updateIndex = (int index) {
        viewModel.fetchIssues(viewModel.releases[index]);
        _index = index;
      };

      if (_index == null) {
        updateIndex(0);
      }

      return RefreshIndicator(
        key: _refreshKey,
        backgroundColor: Colors.white,
        color: Color(0xff81B4FE),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: viewModel.releases.length,
                    controller: PageController(viewportFraction: 0.9),
                    onPageChanged: (int index) => setState(() => updateIndex(index)),
                    itemBuilder: (context, index) {
                      return ReleaseCard(
                          viewModel.releases[index].project,
                          viewModel.releases[index].release,
                      );
                    },
                  )),
              Container(
                padding: EdgeInsets.only(top: 22, left: 22, right: 22),
                child: Column(
                  children: [
                    HealthDivider(
                      onSeeAll: () {},
                      title: 'Charts',
                    ),
                    ReleaseHealthChartRow(
                        title: 'Issues',
                        data: viewModel.statsAsLineChartPoints(viewModel.releases[_index], true),
                    ), // TODO: api
                    ReleaseHealthChartRow(
                        title: 'Crashes',
                        data: viewModel.statsAsLineChartPoints(viewModel.releases[_index], false),
                        parentData: viewModel.statsAsLineChartPoints(viewModel.releases[_index], true), // Crashes are included in issues
                    ), // TODO: api
                    HealthDivider(
                      onSeeAll: () {},
                      title: 'Statistics',
                    ),
                    Row(
                      children: [
                        HealthCard(
                            title: 'Crash Free Users',
                            value: viewModel.releases[_index].release.crashFreeUsers,
                            change: 0.04
                        ), // TODO: api
                        HealthCard(
                            title: 'Crash Free Sessions',
                            value: viewModel.releases[_index].release.crashFreeSessions,
                            change: -0.01
                        ), // TODO: api
                      ],
                    )
                  ],
                ),
              ),
              // Column(children: [
              //   // WARNING Those line charts are just stacked one over the other, so the scaling between them is not in sync. Implement if we will keep this view.
              //   Stack(
              //     children: [
              //       Container(
              //         height: 120,
              //         child: LineChart(
              //             points: ReleaseHealthData.palceholderHealthy,
              //             lineWidth: 1.0,
              //             lineColor: Color(0xffffc227),
              //             gradientStart: Color(0xffffc227),
              //             gradientEnd: Color(0xe1ffc227)
              //         ),
              //       ),
              //       Container(
              //         height: 120,
              //         child: LineChart(
              //             points: ReleaseHealthData.placeholderError,
              //             lineWidth: 1.0,
              //             lineColor: Color(0xffef7061),
              //             gradientStart: Color(0xffef7061),
              //             gradientEnd: Color(0xe1ef7061)
              //         ),
              //       ),
              //       Container(
              //         height: 120,
              //         child: LineChart(
              //             points: ReleaseHealthData.placeholderAbnormal,
              //             lineWidth: 1.0,
              //             lineColor: Color(0xffa35488),
              //             gradientStart: Color(0xffa35488),
              //             gradientEnd: Color(0xe1a35488)
              //         ),
              //       ),
              //       Container(
              //         height: 120,
              //         child: LineChart(
              //             points: ReleaseHealthData.placeholderCrashes,
              //             lineWidth: 1.0,
              //             lineColor: Color(0xff444674),
              //             gradientStart: Color(0xff444674),
              //             gradientEnd: Color(0xe1444674)
              //         ),
              //       ),
              //     ],
              //   )
              //
              // ])
            ],
          ),
        ),
        onRefresh: () => Future.delayed(
          Duration(microseconds: 100),
          () { viewModel.fetchReleases(); }
        ),
      );
    }
  }
}

class HealthDivider extends StatelessWidget {
  HealthDivider(
      {@required this.title,
      @required this.onSeeAll});

  final String title;
  final void Function() onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 6.0, bottom: 22.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFFB9C1D9),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          // MaterialButton(
          //   minWidth: 0,
          //   padding: EdgeInsets.zero,
          //   onPressed: onSeeAll,
          //   child: Text(
          //     'See All',
          //     style: TextStyle(
          //       color: Color(0xFF81B4FE),
          //       fontWeight: FontWeight.w500,
          //       fontSize: 16,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class HealthCard extends StatelessWidget {
  HealthCard(
      {@required this.title, this.value, @required this.change});

  final String title;
  final double value;
  final double change;

  final warningThreshold = 99.5;
  final dangerThreshold = 98;

  Color getColor() {
    return value == null
        ? Color(0xFFB9C1D9)
        : value > warningThreshold
          ? Color(0xFF23B480)
          : value > dangerThreshold ? Color(0xFFFFC227) : Color(0xFFEE6855);
  }

  Icon getIcon(Color color) {
    if (value == null) {
      return null;
    }
    return value > warningThreshold
        ? Icon(SentryIcons.status_ok, color: color, size: 20.0)
        : value > dangerThreshold
            ? Icon(SentryIcons.status_warning, color: color, size: 20.0)
            : Icon(SentryIcons.status_error, color: color, size: 20.0);
  }

  String getTrendSign() {
    return change > 0 ? '+' : '';
  }

  Icon getTrendIcon() {
    if (change == 0) {
      return null;
    }
    return change == 0
      ? Icon(SentryIcons.trend_same, color: Color(0xffB9C1D9), size: 8.0)
      :  change > 0
        ? Icon(SentryIcons.trend_up, color: Color(0xff23B480), size: 8.0)
        : Icon(SentryIcons.trend_down, color: Color(0xffEE6855), size: 8.0);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      elevation: 3,
      shadowColor: Color(0x99FFFFFF),
      margin: EdgeInsets.only(left: 7, right: 7, top: 0, bottom: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: getColor().withAlpha(0x19),
              child: getIcon(getColor()),
            )
          ),
          Text(
            value != null ? value.toString() + '%' : '--',
            style: TextStyle(
              color: getColor(),
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 5, bottom: 8),
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF14223B),
                  fontSize: 14,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(bottom: 8),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  change != null ? getTrendSign() + change.toString() + '%' : '--',
                  style: TextStyle(
                    color: Color(0xFFB9C1D9),
                    fontSize: 13,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: getTrendIcon() ?? Spacer(),
                )
              ])),
        ],
      ),
    ));
  }
}
