import 'package:web/web.dart' as web;

String? localGet(String key) => web.window.localStorage.getItem(key);
void localSet(String key, String value) => web.window.localStorage.setItem(key, value);
void localRemove(String key) => web.window.localStorage.removeItem(key);
