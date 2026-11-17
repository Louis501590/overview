/// Nicht-Web-Plattformen: Download wird nicht unterstützt (App ist eine PWA).
Future<void> downloadTextFile(String filename, String content) async {
  throw UnsupportedError('Download wird nur im Browser unterstützt.');
}
