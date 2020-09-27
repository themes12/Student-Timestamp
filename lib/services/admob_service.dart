import 'dart:io';

class AdManager {
  // TODO: These are all TEST IDs. Replace with your own IDs later.
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6704584190021126~3214101568";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6704584190021126~3748647558";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6704584190021126/9587938223";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6704584190021126/6495403856";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}