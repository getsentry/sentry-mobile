import '../types/group.dart';
import '../types/organization.dart';
import '../types/project.dart';
import '../types/project_with_latest_release.dart';
import '../types/release.dart';
import '../types/sessions.dart';
import '../types/user.dart';

class RehydrateAction {
  RehydrateAction();
}

class AppStartAction {
  AppStartAction();
}

class RehydrateSuccessAction {
  RehydrateSuccessAction(this.authToken, this.sentrySdkEnabled, this.version,
      this.numberOfRatingEvents);
  final String? authToken;
  final bool sentrySdkEnabled;
  final String version;
  final int numberOfRatingEvents;
}

class SwitchTabAction {
  SwitchTabAction(this.selectedTab);
  final int selectedTab;
}

class LoginSuccessAction {
  LoginSuccessAction(this.authToken);
  final String authToken;
}

class LogoutAction {
  LogoutAction();
}

class ApiFailureAction {
  ApiFailureAction(this.error, this.stackTrace);
  final dynamic error;
  final StackTrace stackTrace;
}

// FetchOrganizationsAndProjects

class FetchOrgsAndProjectsAction {
  FetchOrgsAndProjectsAction(this.resetSessionData);
  final bool resetSessionData;
}

class FetchOrgsAndProjectsProgressAction {
  FetchOrgsAndProjectsProgressAction(this.text, this.progress);
  final String text;
  final double? progress;
}

class FetchOrgsAndProjectsSuccessAction {
  FetchOrgsAndProjectsSuccessAction(this.organizations,
      this.projectsByOrganizationSlug, this.projectIdsWithSessions);
  final List<Organization> organizations;
  final Map<String, List<Project>> projectsByOrganizationSlug;
  final Set<String> projectIdsWithSessions;
}

class FetchOrgsAndProjectsFailureAction extends ApiFailureAction {
  FetchOrgsAndProjectsFailureAction(error, StackTrace stackTrace)
      : super(error, stackTrace);
}

// FetchLatestRelease

class FetchLatestReleaseAction {
  FetchLatestReleaseAction(
      this.organizationSlug, this.projectSlug, this.projectId, this.releaseId);
  final String organizationSlug;
  final String projectSlug;
  final String projectId;
  final String releaseId;
}

class FetchLatestReleaseSuccessAction {
  FetchLatestReleaseSuccessAction(this.projectSlug, this.latestRelease);
  final String projectSlug;
  final Release latestRelease;
}

class FetchLatestReleaseFailureAction extends ApiFailureAction {
  FetchLatestReleaseFailureAction(error, StackTrace stackTrace)
      : super(error, stackTrace);
}

// FetchLatestReleases

class FetchLatestReleasesAction {
  FetchLatestReleasesAction(this.projectsByOrganizationSlug);
  final Map<String, List<Project>> projectsByOrganizationSlug;
}

class FetchLatestReleasesSuccessAction {
  FetchLatestReleasesSuccessAction(this.projectsWithLatestReleases);
  final List<ProjectWithLatestRelease> projectsWithLatestReleases;
}

class FetchLatestReleasesFailureAction extends ApiFailureAction {
  FetchLatestReleasesFailureAction(error, StackTrace stackTrace)
      : super(error, stackTrace);
}

// FetchIssues

class FetchIssuesAction {
  FetchIssuesAction(this.organizationSlug, this.projectSlug);
  final String organizationSlug;
  final String projectSlug;
}

class FetchIssuesSuccessAction {
  FetchIssuesSuccessAction(this.projectSlug, this.issues);
  final String projectSlug;
  final List<Group> issues;
}

class FetchIssuesFailureAction extends ApiFailureAction {
  FetchIssuesFailureAction(error, StackTrace stackTrace)
      : super(error, stackTrace);
}

// FetchAuthenticatedUser

class FetchAuthenticatedUserAction {
  FetchAuthenticatedUserAction(this.authToken);
  final String authToken;
}

class FetchAuthenticatedUserSuccessAction {
  FetchAuthenticatedUserSuccessAction(this.me);
  final User me;
}

class FetchAuthenticatedUserFailureAction extends ApiFailureAction {
  FetchAuthenticatedUserFailureAction(error, StackTrace stackTrace)
      : super(error, stackTrace);
}

// FetchSessions

class FetchSessionsAction {
  FetchSessionsAction(this.organizationSlug, this.projectId);

  final String organizationSlug;
  final String projectId;
}

class FetchSessionsSuccessAction {
  FetchSessionsSuccessAction(
      this.projectId, this.sessions, this.sessionsBefore);
  final String projectId;
  final Sessions sessions;
  final Sessions sessionsBefore;
}

class FetchSessionsFailureAction extends ApiFailureAction {
  FetchSessionsFailureAction(error, StackTrace stackTrace)
      : super(error, stackTrace);
}

// BookmarkProject

class BookmarkProjectAction {
  BookmarkProjectAction(
      this.organizationSlug, this.projectSlug, this.bookmarked);

  final String organizationSlug;
  final String projectSlug;
  final bool bookmarked;
}

class BookmarkProjectSuccessAction {
  BookmarkProjectSuccessAction(this.organizationSlug, this.project);

  final String organizationSlug;
  final Project project;
}

class BookmarkProjectFailureAction extends ApiFailureAction {
  BookmarkProjectFailureAction(
      this.projectSlug, this.bookmarked, error, StackTrace stackTrace)
      : super(error, stackTrace);
  final String projectSlug;
  final bool bookmarked;
}

// FetchApDex

class FetchApdexAction {
  FetchApdexAction(this.apdexThreshold, this.organizationSlug, this.projectId);

  final int apdexThreshold;
  final String organizationSlug;
  final String projectId;
}

class FetchApdexSuccessAction {
  FetchApdexSuccessAction(this.projectId, this.apdex, this.apdexBefore);

  final String projectId;
  final double? apdex;
  final double? apdexBefore;
}

class FetchApdexFailureAction extends ApiFailureAction {
  FetchApdexFailureAction(error, StackTrace stackTrace)
      : super(error, stackTrace);
}

// SentrySdkToggle

class SentrySdkToggleAction {
  SentrySdkToggleAction(this.enabled);
  final bool enabled;
}

// PresentRatingAction

class PresentRatingAction {
  PresentRatingAction();
}

// SelectOrganization

class SelectOrganizationAction {
  SelectOrganizationAction(this.organization);
  final Organization organization;
}

// SelectProject

class SelectProjectAction {
  SelectProjectAction(this.project);
  final Project project;
}
