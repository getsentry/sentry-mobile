import 'dart:async';
import 'dart:io';
import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../redux/state/session_state.dart';
import '../../screens/health/health_card_view_model.dart';
import '../../screens/health/project_card.dart';
import '../../types/project_with_latest_release.dart';
import '../../types/session_status.dart';

class HealthScreenViewModel {
  HealthScreenViewModel.fromStore(Store<AppState> store)
      : _store = store,
        projects = store.state.globalState.projectsWithLatestReleases(),
        _totalSessionStateByProjectId = store.state.globalState
            .sessionStateByProjectId(SessionStatus.values.toSet()),
        _healthySessionsStateByProjectId = store.state.globalState
            .sessionStateByProjectId({SessionStatus.healthy}),
        _erroredSessionsStateByProjectId = store.state.globalState
            .sessionStateByProjectId({SessionStatus.errored}),
        _abnormalSessionsStateByProjectId = store.state.globalState
            .sessionStateByProjectId({SessionStatus.abnormal}),
        _crashedSessionStateByProjectId = store.state.globalState
            .sessionStateByProjectId({SessionStatus.crashed}),
        _crashFreeSessionsByProjectId =
            store.state.globalState.crashFreeSessionsByProjectId,
        _crashFreeSessionsBeforeByProjectId =
            store.state.globalState.crashFreeSessionsBeforeByProjectId,
        _crashFreeUsersByProjectId =
            store.state.globalState.crashFreeUsersByProjectId,
        _crashFreeUsersBeforeByProjectId =
            store.state.globalState.crashFreeUsersBeforeByProjectId,
        _apdexByProjectId = store.state.globalState.apdexByProjectId,
        _apdexBeforeByProjectId =
            store.state.globalState.apdexBeforeByProjectId,
        showProjectEmptyScreen =
            store.state.globalState.projectsWithSessions.isEmpty &&
                !store.state.globalState.orgsAndProjectsLoading,
        showLoadingScreen =
            store.state.globalState.projectsWithSessions.isEmpty &&
                store.state.globalState.orgsAndProjectsLoading,
        showErrorScreen = store.state.globalState.orgsAndProjectsError != null,
        showErrorNoConnectionScreen =
            store.state.globalState.orgsAndProjectsError is TimeoutException ||
                store.state.globalState.orgsAndProjectsError is SocketException,
        loadingProgress = store.state.globalState.orgsAndProjectsProgress,
        loadingText = store.state.globalState.orgsAndProjectsProgressText;

  final Store<AppState> _store;

  final List<ProjectWithLatestRelease> projects;

  final Map<String, SessionState> _totalSessionStateByProjectId;
  final Map<String, SessionState> _healthySessionsStateByProjectId;
  final Map<String, SessionState> _erroredSessionsStateByProjectId;
  final Map<String, SessionState> _abnormalSessionsStateByProjectId;
  final Map<String, SessionState> _crashedSessionStateByProjectId;

  final Map<String, double> _crashFreeSessionsByProjectId;
  final Map<String, double> _crashFreeSessionsBeforeByProjectId;
  final Map<String, double> _crashFreeUsersByProjectId;
  final Map<String, double> _crashFreeUsersBeforeByProjectId;

  final Map<String, double> _apdexByProjectId;
  final Map<String, double> _apdexBeforeByProjectId;

  final double? loadingProgress;
  final String? loadingText;

  final bool showProjectEmptyScreen;
  final bool showLoadingScreen;
  final bool showErrorScreen;
  final bool showErrorNoConnectionScreen;

  void fetchProjects() {
    _store.dispatch(FetchOrgsAndProjectsAction(false));
  }

  void reloadProjects() {
    _store.dispatch(FetchOrgsAndProjectsAction(true));
  }

  ProjectCard projectCard(int index) {
    final projectWitLatestRelease = projects[index];
    return ProjectCard(
        _store.state.globalState
            .organizationForProjectSlug(projectWitLatestRelease.project.slug)
            ?.name,
        projectWitLatestRelease.project,
        projectWitLatestRelease.release,
        _totalSessionStateByProjectId[projectWitLatestRelease.project.id]);
  }

  SessionState? sessionState(int index, SessionStatus sessionStatus) {
    final project = projects[index].project;
    switch (sessionStatus) {
      case SessionStatus.healthy:
        return _healthySessionsStateByProjectId[project.id];
      case SessionStatus.errored:
        return _erroredSessionsStateByProjectId[project.id];
      case SessionStatus.crashed:
        return _crashedSessionStateByProjectId[project.id];
      case SessionStatus.abnormal:
        return _abnormalSessionsStateByProjectId[project.id];
    }
  }

  bool showAbnormalSessions(int index) {
    final project = projects[index].project;
    final platform = project.platform?.toLowerCase();
    if (platform == null) {
      return true;
    } else {
      return !platform.contains('node') && !platform.contains('javascript');
    }
  }

  HealthCardViewModel crashFreeSessionsForProject(int index) {
    final project = projects[index].project;
    return HealthCardViewModel.crashFreeSessions(
      _crashFreeSessionsByProjectId[project.id],
      _crashFreeSessionsBeforeByProjectId[project.id],
    );
  }

  HealthCardViewModel crashFreeUsersForProject(int index) {
    final project = projects[index].project;
    return HealthCardViewModel.crashFreeSessions(
      _crashFreeUsersByProjectId[project.id],
      _crashFreeUsersBeforeByProjectId[project.id],
    );
  }

  HealthCardViewModel apdexForProject(int index) {
    final project = projects[index].project;
    return HealthCardViewModel.apdex(
      _apdexByProjectId[project.id],
      _apdexBeforeByProjectId[project.id],
    );
  }

  void fetchDataForProject(int index) {
    if (index < 0 || index >= projects.length) {
      return;
    }
    final projectWithLatestRelease = projects[index];
    //_fetchLatestRelease(projectWithLatestRelease);
    _fetchSessions(projectWithLatestRelease);
    //_fetchApdex(projectWithLatestRelease);
    if (index + 1 < projects.length) {
      final nextProjectWithLatestRelease = projects[index + 1];
      //_fetchLatestRelease(nextProjectWithLatestRelease);
      _fetchSessions(nextProjectWithLatestRelease);
      //_fetchApdex(nextProjectWithLatestRelease);
    }
  }

  // void _fetchLatestRelease(ProjectWithLatestRelease projectWithLatestRelease) {
  //   final organizationSlug = _store.state.globalState.organizationsSlugByProjectSlug[projectWithLatestRelease.project.slug];
  //   if (organizationSlug == null) {
  //     return;
  //   }
  //   _store.dispatch(
  //     FetchLatestReleaseAction(
  //         organizationSlug,
  //         projectWithLatestRelease.project.slug,
  //         projectWithLatestRelease.project.id,
  //         projectWithLatestRelease.project.latestRelease.version
  //     )
  //   );
  // }

  void _fetchSessions(ProjectWithLatestRelease projectWithLatestRelease) {
    final organizationSlug = _store.state.globalState
        .organizationsSlugByProjectSlug[projectWithLatestRelease.project.slug];
    if (organizationSlug == null) {
      return;
    }
    if (_store.state.globalState
            .sessionsByProjectId[projectWithLatestRelease.project.id] !=
        null) {
      return; // Only fetch when there is no data available yet
    }
    _store.dispatch(FetchSessionsAction(
        organizationSlug, projectWithLatestRelease.project.id));
  }

  // void _fetchApdex(ProjectWithLatestRelease projectWithLatestRelease) {
  //   final organization = _store.state.globalState.organizationForProjectSlug(projectWithLatestRelease.project.slug);
  //   if (organization == null) {
  //     return;
  //   }
  //   _store.dispatch(
  //       FetchApdexAction(
  //         organization.apdexThreshold,
  //         organization.slug,
  //         projectWithLatestRelease.project.id,
  //       )
  //   );
  // }

  bool shouldPresentRating() {
    return _store.state.globalState.numberOfRatingEvents > 10;
  }

  void didPresentRating() {
    _store.dispatch(PresentRatingAction());
  }
}
