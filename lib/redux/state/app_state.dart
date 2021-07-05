import '../../redux/state/session_state.dart';
import '../../screens/chart/line_chart_point.dart';
import '../../types/group.dart';
import '../../types/organization.dart';
import '../../types/project.dart';
import '../../types/project_with_latest_release.dart';
import '../../types/release.dart';
import '../../types/session_status.dart';
import '../../types/sessions.dart';
import '../../types/user.dart';

class AppState {
  AppState({required this.globalState});

  factory AppState.initial() {
    return AppState(
      globalState: GlobalState.initial(),
    );
  }

  final GlobalState globalState;

  AppState copyWith({GlobalState? globalState}) {
    return AppState(
      globalState: globalState ?? this.globalState,
    );
  }
}

class GlobalState {
  GlobalState(
      {this.authToken,
      required this.hydrated,
      required this.sentrySdkEnabled,
      required this.version,
      required this.selectedTab,
      required this.organizations,
      required this.organizationsSlugByProjectSlug,
      required this.projectsByOrganizationSlug,
      required this.orgsAndProjectsLoading,
      required this.orgsAndProjectsProgress,
      required this.orgsAndProjectsProgressText,
      required this.orgsAndProjectsError,
      required this.projectIdsWithSessions,
      required this.projectsWithSessions,
      required this.latestReleasesByProjectId,
      required this.sessionsByProjectId,
      required this.sessionsBeforeByProjectId,
      required this.crashFreeSessionsByProjectId,
      required this.crashFreeSessionsBeforeByProjectId,
      required this.crashFreeUsersByProjectId,
      required this.crashFreeUsersBeforeByProjectId,
      required this.apdexByProjectId,
      required this.apdexBeforeByProjectId,
      required this.issuesByProjectSlug,
      required this.numberOfRatingEvents,
      this.selectedOrganization,
      this.selectedProject,
      this.me});

  factory GlobalState.initial() {
    return GlobalState(
        authToken: null,
        hydrated: false,
        sentrySdkEnabled: false,
        version: '--',
        selectedTab: 0,
        organizations: [],
        organizationsSlugByProjectSlug: {},
        projectsByOrganizationSlug: {},
        orgsAndProjectsLoading: true,
        orgsAndProjectsProgress: null,
        orgsAndProjectsProgressText: null,
        orgsAndProjectsError: null,
        projectIdsWithSessions: {},
        projectsWithSessions: [],
        latestReleasesByProjectId: {},
        sessionsByProjectId: {},
        sessionsBeforeByProjectId: {},
        crashFreeSessionsByProjectId: {},
        crashFreeSessionsBeforeByProjectId: {},
        crashFreeUsersByProjectId: {},
        crashFreeUsersBeforeByProjectId: {},
        apdexByProjectId: {},
        apdexBeforeByProjectId: {},
        issuesByProjectSlug: {},
        numberOfRatingEvents: 0,
        selectedOrganization: null,
        selectedProject: null,
        me: null);
  }

  final String? authToken;
  final bool hydrated;
  final bool sentrySdkEnabled;
  final String version;
  final int selectedTab;

  final List<Organization> organizations;
  final Map<String, String> organizationsSlugByProjectSlug;
  final Map<String, List<Project>> projectsByOrganizationSlug;

  final bool orgsAndProjectsLoading;
  final double? orgsAndProjectsProgress;
  final String? orgsAndProjectsProgressText;
  final dynamic orgsAndProjectsError;

  final Set<String> projectIdsWithSessions;
  final List<Project> projectsWithSessions;
  final Map<String, Release> latestReleasesByProjectId;

  final Map<String, Sessions> sessionsByProjectId;
  final Map<String, Sessions>
      sessionsBeforeByProjectId; // Interval before sessionsByProjectId
  final Map<String, double> crashFreeSessionsByProjectId;
  final Map<String, double>
      crashFreeSessionsBeforeByProjectId; // Interval before stabilityScoreByProjectId
  final Map<String, double> crashFreeUsersByProjectId;
  final Map<String, double>
      crashFreeUsersBeforeByProjectId; // Interval before stabilityScoreByProjectId
  final Map<String, double> apdexByProjectId;
  final Map<String, double>
      apdexBeforeByProjectId; // Interval before apdexByProjectId

  final Map<String, List<Group>> issuesByProjectSlug;
  final int numberOfRatingEvents;

  final Organization? selectedOrganization;
  final Project? selectedProject;

  final User? me;

  GlobalState copyWith({
    String? authToken,
    bool? hydrated,
    bool? sentrySdkEnabled,
    String? version,
    int? selectedTab,
    bool setTokenNull = false,
    List<Organization>? organizations,
    Map<String, String>? organizationsSlugByProjectSlug,
    Map<String, List<Project>>? projectsByOrganizationSlug,
    bool? orgsAndProjectsLoading,
    double? orgsAndProjectsProgress,
    String? orgsAndProjectsProgressText,
    dynamic orgsAndProjectsError,
    bool setOrgsAndProjectsErrorNull = false,
    Set<String>? projectIdsWithSessions,
    List<Project>? projectsWithSessions,
    Map<String, Release>? latestReleasesByProjectId,
    Map<String, Sessions>? sessionsByProjectId,
    Map<String, Sessions>? sessionsBeforeByProjectId,
    Map<String, double>? crashFreeSessionsByProjectId,
    Map<String, double>? crashFreeSessionsBeforeByProjectId,
    Map<String, double>? crashFreeUsersByProjectId,
    Map<String, double>? crashFreeUsersBeforeByProjectId,
    Map<String, double>? apdexByProjectId,
    Map<String, double>? apdexBeforeByProjectId,
    Map<String, List<Group>>? issuesByProjectSlug,
    Organization? selectedOrganization,
    Project? selectedProject,
    int? numberOfRatingEvents,
    User? me,
  }) {
    return GlobalState(
        authToken: setTokenNull ? null : (authToken ?? this.authToken),
        hydrated: hydrated ?? this.hydrated,
        sentrySdkEnabled: sentrySdkEnabled ?? this.sentrySdkEnabled,
        version: version ?? this.version,
        selectedTab: selectedTab ?? this.selectedTab,
        organizations: organizations ?? this.organizations,
        organizationsSlugByProjectSlug: organizationsSlugByProjectSlug ??
            this.organizationsSlugByProjectSlug,
        projectsByOrganizationSlug:
            projectsByOrganizationSlug ?? this.projectsByOrganizationSlug,
        orgsAndProjectsLoading:
            orgsAndProjectsLoading ?? this.orgsAndProjectsLoading,
        orgsAndProjectsProgress:
            (orgsAndProjectsLoading ?? this.orgsAndProjectsLoading)
                ? orgsAndProjectsProgress ?? this.orgsAndProjectsProgress
                : null,
        orgsAndProjectsProgressText: (orgsAndProjectsLoading ??
                this.orgsAndProjectsLoading)
            ? orgsAndProjectsProgressText ?? this.orgsAndProjectsProgressText
            : null,
        orgsAndProjectsError: setOrgsAndProjectsErrorNull
            ? null
            : orgsAndProjectsError ?? this.orgsAndProjectsError,
        projectIdsWithSessions:
            projectIdsWithSessions ?? this.projectIdsWithSessions,
        projectsWithSessions: projectsWithSessions ?? this.projectsWithSessions,
        latestReleasesByProjectId:
            latestReleasesByProjectId ?? this.latestReleasesByProjectId,
        sessionsByProjectId: sessionsByProjectId ?? this.sessionsByProjectId,
        sessionsBeforeByProjectId:
            sessionsBeforeByProjectId ?? this.sessionsBeforeByProjectId,
        crashFreeSessionsByProjectId:
            crashFreeSessionsByProjectId ?? this.crashFreeSessionsByProjectId,
        crashFreeSessionsBeforeByProjectId:
            crashFreeSessionsBeforeByProjectId ??
                this.crashFreeSessionsBeforeByProjectId,
        crashFreeUsersByProjectId:
            crashFreeUsersByProjectId ?? this.crashFreeUsersByProjectId,
        crashFreeUsersBeforeByProjectId: crashFreeUsersBeforeByProjectId ??
            this.crashFreeUsersBeforeByProjectId,
        apdexByProjectId: apdexByProjectId ?? this.apdexByProjectId,
        apdexBeforeByProjectId:
            apdexBeforeByProjectId ?? this.apdexBeforeByProjectId,
        issuesByProjectSlug: issuesByProjectSlug ?? this.issuesByProjectSlug,
        selectedOrganization: selectedOrganization ?? this.selectedOrganization,
        selectedProject: selectedProject ?? this.selectedProject,
        numberOfRatingEvents: numberOfRatingEvents ?? this.numberOfRatingEvents,
        me: me ?? this.me);
  }

  Map<String, SessionState> sessionStateByProjectId(
      Set<SessionStatus> sessionStatus) {
    final sessionStateByProjectId = <String, SessionState>{};

    for (final projectId in sessionsByProjectId.keys) {
      final sessions = sessionsByProjectId[projectId];
      final previousSession = sessionsBeforeByProjectId[projectId];

      var total = 0;
      var previousTotal = 0;

      var lineChartPoints = <LineChartPoint>[];
      var previousLineChartPoints = <LineChartPoint>[];

      if (sessions != null) {
        final totalAndPoints =
            createTotalSessionCountAndLinePoints(sessionStatus, sessions);
        total = totalAndPoints[0] as int;
        lineChartPoints = totalAndPoints[1] as List<LineChartPoint>;
      }

      if (previousSession != null) {
        final totalAndPoints = createTotalSessionCountAndLinePoints(
            sessionStatus, previousSession);
        previousTotal = totalAndPoints[0] as int;
        previousLineChartPoints = totalAndPoints[1] as List<LineChartPoint>;
      }

      if (sessions != null) {
        sessionStateByProjectId[projectId] = SessionState(
            projectId: projectId,
            numberOfSessions: total,
            previousNumberOfSessions: previousTotal,
            sessionPoints: lineChartPoints,
            previousSessionPoints: previousLineChartPoints);
      }
    }
    return sessionStateByProjectId;
  }

  // Returns the total number of sessions and the line chart points for individual intervals.
  List<dynamic> createTotalSessionCountAndLinePoints(
      Set<SessionStatus> sessionStatus, Sessions sessions) {
    final groups = sessions.groups!
        .where((element) => sessionStatus.contains(element.by!.sessionStatus))
        .toList();

    var total = 0;
    for (final group in groups) {
      total += group.totals!.sumSession!;
    }

    final lineChartPoints = <LineChartPoint>[];
    for (var index = 0; index < sessions.intervals!.length; index++) {
      final interval = sessions.intervals![index];
      var sum = 0;

      for (final group in groups) {
        sum += group.series!.sumSession![index];
      }
      lineChartPoints.add(LineChartPoint(
          interval.millisecondsSinceEpoch.toDouble(), sum.toDouble()));
    }
    return [total, lineChartPoints];
  }

  Organization? organizationForProjectSlug(String projectSlug) {
    final organizationSlug = organizationsSlugByProjectSlug[projectSlug];
    if (organizationSlug != null) {
      return organizations
          .firstWhere((element) => element.slug == organizationSlug);
    } else {
      return null;
    }
  }

  List<ProjectWithLatestRelease> projectsWithLatestReleases() {
    return projectsWithSessions
        .map((project) => ProjectWithLatestRelease(
            project, latestReleasesByProjectId[project.id]))
        .toList();
  }
}
