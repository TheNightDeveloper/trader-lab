import 'download_stub.dart' if (dart.library.js_interop) 'download_web.dart' as impl;

/// Saves bytes as a file in the browser (no-op outside the web).
void saveFile(String filename, String mime, List<int> bytes) => impl.saveFile(filename, mime, bytes);
