final _mem = <String, String>{};

String? localGet(String key) => _mem[key];
void localSet(String key, String value) => _mem[key] = value;
void localRemove(String key) => _mem.remove(key);
