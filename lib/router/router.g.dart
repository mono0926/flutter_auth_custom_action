// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $homeRoute,
    ];

GoRoute get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'action',
          factory: $AuthActionRouteExtension._fromState,
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext buildContext) => buildContext.go(location, extra: this);
}

extension $AuthActionRouteExtension on AuthActionRoute {
  static AuthActionRoute _fromState(GoRouterState state) => AuthActionRoute(
        mode: _$convertMapValue(
          'mode',
          state.queryParams,
          _$AuthActionModeEnumMap._$fromName,
        ),
        oobCode: state.queryParams['oob-code'],
        apiKey: state.queryParams['api-key'],
      );

  String get location => GoRouteData.$location(
        '/action',
        queryParams: {
          if (mode != null) 'mode': _$AuthActionModeEnumMap[mode!]!,
          if (oobCode != null) 'oob-code': oobCode!,
          if (apiKey != null) 'api-key': apiKey!,
        },
      );

  void go(BuildContext buildContext) => buildContext.go(location, extra: this);
}

const _$AuthActionModeEnumMap = {
  AuthActionMode.resetPassword: 'reset-password',
};

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) =>
      entries.singleWhere((element) => element.value == value).key;
}
