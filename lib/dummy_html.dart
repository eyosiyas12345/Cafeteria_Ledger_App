// ignore_for_file: camel_case_types

/// This is a "Dummy" file used to prevent Android/iOS build errors.
/// When the app runs on Android, it uses this file instead of the real dart:html.
class window {
  static void open(String url, String target) {
    // This does nothing on Android, which is what we want!
  }
}
