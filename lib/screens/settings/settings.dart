import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:sentry_mobile/screens/html/html_screen.dart';
import 'package:sentry_mobile/screens/license/license_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../screens/debug/sentry_flutter_screen.dart';
import '../../screens/projects/projects_screen.dart';
import '../../utils/sentry_colors.dart';
import 'settings_header.dart';
import 'settings_view_model.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsViewModel>(
        builder: (_, viewModel) => _content(viewModel),
        converter: (store) => SettingsViewModel.fromStore(store),
        onInitialBuild: (viewModel) =>
            viewModel.fetchAuthenticatedUserIfNeeded());
  }

  Widget _content(SettingsViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SettingsHeader('Projects'),
              ),
              ListTile(
                title: Text(
                  'Bookmarked Projects',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.apply(color: SentryColors.revolver),
                ),
                subtitle: Text(viewModel.bookmarkedProjects,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.apply(color: SentryColors.mamba)),
                leading: Icon(
                  Icons.star,
                  color: SentryColors.lightningYellow,
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProjectsScreen()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SettingsHeader('Info'),
              ),
              ListTile(
                  title: Text(
                    'Privacy Policy',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.apply(color: SentryColors.revolver),
                  ),
                  leading: Icon(
                    Icons.privacy_tip,
                    color: SentryColors.royalBlue,
                  ),
                  onTap: () async {
                    const url = 'https://sentry.io/privacy/';
                    if (await canLaunch(url)) {
                      await launch(url, forceSafariVC: false);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
              ListTile(
                  title: Text(
                    'End User License Agreement',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.apply(color: SentryColors.revolver),
                  ),
                  leading: Icon(
                    Icons.person,
                    color: SentryColors.shamrock,
                  ),
                  onTap: () async {
                    String eulaFilePath;
                    if (Platform.isIOS) {
                      eulaFilePath = 'assets/sentry_eula_ios.md';
                    } else {
                      eulaFilePath = 'assets/sentry_eula_android.md';
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => HtmlScreen(
                              'End User License Agreement', eulaFilePath)),
                    );
                  }),
              ListTile(
                  title: Text(
                    'Licenses',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.apply(color: SentryColors.revolver),
                  ),
                  leading: Icon(
                    Icons.library_books,
                    color: SentryColors.tapestry,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LicenseScreen(viewModel.version)),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SettingsHeader('Application'),
              ),
              ListTile(
                  title: Text(
                    'Rate Sentry Mobile',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.apply(color: SentryColors.revolver),
                  ),
                  leading: Icon(
                    Icons.star,
                    color: SentryColors.lightningYellow,
                  ),
                  onTap: () {
                    inAppReview.openStoreListing(appStoreId: 'id1546709967');
                  }),
              SwitchListTile(
                title: Text(
                  'Sentry SDK',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.apply(color: SentryColors.revolver),
                ),
                value: viewModel.sentrySdkEnabled,
                subtitle: Text(
                    viewModel.sentrySdkEnabled ? 'Enabled' : 'Disabled',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.apply(color: SentryColors.mamba)),
                secondary: Icon(
                  Icons.bug_report_rounded,
                  color: SentryColors.burntSienna,
                ),
                onChanged: (bool value) {
                  StoreProvider.of<AppState>(context)
                      .dispatch(SentrySdkToggleAction(value));
                },
              ),
              ListTile(
                title: Text(
                  'Sign Out',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.apply(color: SentryColors.revolver),
                ),
                subtitle: Text(viewModel.userInfo,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.apply(color: SentryColors.mamba)),
                leading: Icon(
                  Icons.exit_to_app,
                  color: SentryColors.royalBlue,
                ),
                onTap: () => Navigator.pop(context, true),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: GestureDetector(
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => SentryFlutterScreen()),
                        );
                      },
                      child: Text(viewModel.version,
                          style: Theme.of(context).textTheme.caption))),
            ],
          ),
        ),
      ),
    );
  }
}
