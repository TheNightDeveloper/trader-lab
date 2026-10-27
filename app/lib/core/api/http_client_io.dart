import 'dart:io' as io;

import 'package:connectrpc/connect.dart' as connect;
import 'package:connectrpc/io.dart' as cio;

/// VM (tests, tools). The app itself only ships for web.
connect.HttpClient platformHttpClient() => cio.createHttpClient(io.HttpClient());
