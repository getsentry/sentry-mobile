import 'dart:io';

import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';
import 'package:sentry_mobile/types/release.dart';

class RehydrateAction {
  RehydrateAction();
}

class SwitchTabAction {
  SwitchTabAction(this.payload);
  final int payload;
}

class LoginAction {
  LoginAction(this.payload);
  final Cookie payload;
}

class LogoutAction {
  LogoutAction();
}

class TitleAction {
  TitleAction(this.payload);
  final String payload;
}

class FetchOrganizationsAction {
  FetchOrganizationsAction();
}

class FetchOrganizationsSuccessAction {
  FetchOrganizationsSuccessAction(this.payload);
  final List<Organization> payload;
}

class FetchOrganizationsFailureAction {
  FetchOrganizationsFailureAction(this.error);
  final dynamic error;
}

class SelectOrganizationAction {
  SelectOrganizationAction(this.payload);
  final Organization payload;
}

class FetchProjectsAction {
  FetchProjectsAction(this.payload);
  final Organization payload;
}

class FetchProjectsSuccessAction {
  FetchProjectsSuccessAction(this.payload);
  final List<Project> payload;
}

class FetchProjectsFailureAction {
  FetchProjectsFailureAction(this.error);
  final dynamic error;
}

class SelectProjectAction {
  SelectProjectAction(this.payload);
  final Project payload;
}

class FetchReleasesAction {
  FetchReleasesAction(this.projectId);
  final String projectId;
}

class FetchReleasesSuccessAction {
  FetchReleasesSuccessAction(this.payload);
  final List<Release> payload;
}

class FetchReleasesFailureAction {
  FetchReleasesFailureAction(this.error);
  final dynamic error;
}

class FetchReleaseAction {
  FetchReleaseAction(this.projectId, this.releaseId);
  final String projectId;
  final String releaseId;
}

class FetchReleaseSuccessAction {
  FetchReleaseSuccessAction(this.payload);
  final Release payload;
}

class FetchReleaseFailureAction {
  FetchReleaseFailureAction(this.error);
  final dynamic error;
}