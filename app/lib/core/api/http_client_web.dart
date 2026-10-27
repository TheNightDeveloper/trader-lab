import 'package:connectrpc/connect.dart' as connect;
import 'package:connectrpc/web.dart' as web;

/// Browser fetch; supports Connect server streaming.
connect.HttpClient platformHttpClient() => web.createHttpClient();
