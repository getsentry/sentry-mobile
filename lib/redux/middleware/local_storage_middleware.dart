import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions.dart';
import '../state/app_state.dart';

class LocalStorageMiddleware extends MiddlewareClass<AppState> {
  LocalStorageMiddleware(this.preferences, this.secureStorage);

  final SharedPreferences preferences;
  final FlutterSecureStorage secureStorage;

  final _keyAuthToken = 'authToken';
  final _keySentrySdkEnabled = 'sentrySdkEnabled';
  final _keyNumberOfRatingEvents = 'numberOfRatingEvents';

  @override
  dynamic call(
      Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RehydrateAction) {
      final String? authToken = await secureStorage.read(key: _keyAuthToken);

      final String? sentrySdkEnabledValue =
          await secureStorage.read(key: _keySentrySdkEnabled);
      final bool sentrySdkEnabled = sentrySdkEnabledValue == 'true';

      final packageInfo = await PackageInfo.fromPlatform();
      final version =
          'Version ${packageInfo.version} (${packageInfo.buildNumber})';

      final numberOfRatingEvents =
          await _incrementAndReturnNumberOfRatingEvents();

      store.dispatch(RehydrateSuccessAction(
          authToken, sentrySdkEnabled, version, numberOfRatingEvents));
      if (authToken != null) {
        store.dispatch(FetchAuthenticatedUserAction(authToken));
      }
    }
    if (action is SentrySdkToggleAction) {
      if (action.enabled) {
        await secureStorage.write(key: _keySentrySdkEnabled, value: 'true');
      } else {
        await secureStorage.delete(key: _keySentrySdkEnabled);
      }
    }
    if (action is PresentRatingAction) {
      await _resetNumberOfRatingEvents();
    }
    if (action is LoginSuccessAction) {
      await secureStorage.write(key: _keyAuthToken, value: action.authToken);
      store.dispatch(FetchAuthenticatedUserAction(action.authToken));
    }
    if (action is LogoutAction) {
      await secureStorage.delete(key: _keyAuthToken);
      await secureStorage.delete(key: _keySentrySdkEnabled);
      await preferences.clear();
    }
    next(action);
  }

  Future<int> _incrementAndReturnNumberOfRatingEvents() async {
    final numberOfRatingEventsString =
        await secureStorage.read(key: _keyNumberOfRatingEvents) ?? '0';
    var numberOfRatingEvents = int.parse(numberOfRatingEventsString);
    numberOfRatingEvents += 1;
    await secureStorage.write(
        key: _keyNumberOfRatingEvents, value: '$numberOfRatingEvents');
    return numberOfRatingEvents;
  }

  Future<void> _resetNumberOfRatingEvents() async {
    await secureStorage.write(key: _keyNumberOfRatingEvents, value: '0');
  }
}
