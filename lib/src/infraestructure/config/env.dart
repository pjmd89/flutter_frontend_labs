import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:agile_front/infraestructure/env_enum.dart';

class Environment{
  static EnvEnum get env {
    const String currentEnvStr = String.fromEnvironment("env");
    EnvEnum currentEnv = envEnumSet(currentEnvStr);
    return currentEnv;
  }
  static String get backendApiUrl {
    const String mobile = String.fromEnvironment("mobileApiURL");
    const String web = String.fromEnvironment("webApiURL");
    const String desktop = String.fromEnvironment("desktopApiURL");
    return _resolveByPlatform(web: web, mobile: mobile, desktop: desktop);
  }

  static String get backendApiUrlWS {
    const String mobile = String.fromEnvironment("mobileWsURL");
    const String web = String.fromEnvironment("webWsURL");
    const String desktop = String.fromEnvironment("desktopWsURL");
    return _resolveByPlatform(web: web, mobile: mobile, desktop: desktop);
  }

  static String get backendAuthUrl {
    const String mobile = String.fromEnvironment("mobileAuthURL");
    const String web = String.fromEnvironment("webAuthURL");
    const String desktop = String.fromEnvironment("desktopAuthURL");
    return _resolveByPlatform(web: web, mobile: mobile, desktop: desktop);
  }

  static String get webAuthCallbackPath {
    const String callbackPath = String.fromEnvironment("webAuthCallbackPath");
    if (callbackPath.isEmpty) {
      return "/auth/callback";
    }
    return callbackPath.startsWith('/') ? callbackPath : '/$callbackPath';
  }

  static String _resolveByPlatform({required String web, required String mobile, required String desktop}) {
    if (kIsWeb) {
      return web;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      return mobile;
    }
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      return desktop;
    }
    return "Undefined Platform";
  }
}