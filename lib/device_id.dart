import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const String kDeviceID = 'prefs_device_id';

class DeviceIdProvider {
  static DeviceIdProvider shared = DeviceIdProvider();
  String _deviceId;

  Future<String> get deviceId async {
    if (_deviceId == null) {
      //try to load from shared preference
      //if not, try to generate a unique one and save to the shared preference for future use.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _deviceId = prefs.getString(kDeviceID);
      if (_deviceId == null) {
        _deviceId = Uuid().v4();
        await prefs.setString(kDeviceID, _deviceId);
      }
    }
    return _deviceId;
  }
}
