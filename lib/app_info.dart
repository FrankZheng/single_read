import 'package:package_info/package_info.dart';

class AppInfo {
  static AppInfo shared = AppInfo();

  Future<PackageInfo> get _packageInfo async => PackageInfo.fromPlatform();

  Future<String> get version async => (await _packageInfo).version;
}
