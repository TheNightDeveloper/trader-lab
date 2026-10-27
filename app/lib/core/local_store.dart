import 'local_store_stub.dart' if (dart.library.js_interop) 'local_store_web.dart' as impl;

/// Small per-browser key/value storage (localStorage on the web, memory elsewhere).
/// For UI drafts only, never for engine data.
String? localGet(String key) => impl.localGet(key);
void localSet(String key, String value) => impl.localSet(key, value);
void localRemove(String key) => impl.localRemove(key);
