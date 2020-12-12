import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import '../../types/project.dart';
import '../../types/release.dart';

class ReleaseCard extends StatelessWidget {
  ReleaseCard(this.project , this.release);

  final Project project;
  final Release release;

  @override
  Widget build(BuildContext context) {

    var data = '[';
    data += release.stats24h
        .map((stat) => '[${stat.timestamp*1000},${stat.value}]')
        .join(',');
    data += ']';

    return Card(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              gradient: LinearGradient(
                colors: [Color(0xff23B480), Color(0xff23B480)],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )),
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  release.version,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  release.project,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            Expanded(
              child: Echarts(
                option: '''
                {
                  backgroundColor: '#23B480',
                  isGroupedByDate: true,
                  xAxis: [{
                    type: 'time',
                    show: false
                  }],
                  yAxis: [{
                    type: 'value',
                    show: false
                  }],
                  grid: {
                    left: -3,
                    right: -3,
                    bottom: 17,
                    top: 3
                  },
                  series: [
                  {
                    name: 'Stat',
                    showSymbol: false,
                    data: ''' + data + ''',
                    type: 'line',
                    clip: false,
                    smooth: true,
                    stack: 'area',
                    animation: false,
                    lineStyle: {
                      opacity: 1,
                      width: 5,
                      color: '#ffffff',
                      shadowColor: 'rgba(0, 0, 0, 0.05)',
                      shadowBlur: 0,
                      shadowOffsetX: 5,
                      shadowOffsetY: 14
                    }
                  }]
                }
              ''',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 16),
              child: _platforms(context, project.platforms)
            )
          ]),
        ));
  }

  Widget _platforms(BuildContext context, List<String> platforms) {
    final platformWidgets = platforms.take(3).map((item) => _platform(context, item)).toList();
    final List<Widget> all = [];
    for (final platformWidget in platformWidgets) {
      all.add(platformWidget);
      if (platformWidget != platformWidgets.last) {
        all.add(SizedBox(width: 8));
      }
    }
    return Row(children: all);
  }

  Widget _platform(BuildContext context, String platform) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0x33ffffff),
          borderRadius: BorderRadius.all(Radius.circular(4.0))
      ),
      padding: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
      child: Text(
          platform,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12
          )
          )
      );
  }
}