// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/index.dart' as index;
import '../routes/new/[id].dart' as new_$id;
import '../routes/db/fbse/index.dart' as db_fbse_index;
import '../routes/db/fbse/inbound/callhangup.dart' as db_fbse_inbound_callhangup;
import '../routes/db/fbse/inbound/callansweredbyivr.dart' as db_fbse_inbound_callansweredbyivr;
import '../routes/db/fbse/inbound/callansweredbyagent.dart' as db_fbse_inbound_callansweredbyagent;

import '../routes/_middleware.dart' as middleware;
import '../routes/db/fbse/_middleware.dart' as db_fbse_middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  createServer(address, port);
}

Future<HttpServer> createServer(InternetAddress address, int port) async {
  final handler = Cascade().add(buildRootHandler()).handler;
  final server = await serve(handler, address, port);
  print('\x1B[92m✓\x1B[0m Running on http://${server.address.host}:${server.port}');
  return server;
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/db/fbse/inbound', (context) => buildDbFbseInboundHandler()(context))
    ..mount('/db/fbse', (context) => buildDbFbseHandler()(context))
    ..mount('/new', (context) => buildNewHandler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildDbFbseInboundHandler() {
  final pipeline = const Pipeline().addMiddleware(db_fbse_middleware.middleware);
  final router = Router()
    ..all('/callhangup', (context) => db_fbse_inbound_callhangup.onRequest(context,))..all('/callansweredbyivr', (context) => db_fbse_inbound_callansweredbyivr.onRequest(context,))..all('/callansweredbyagent', (context) => db_fbse_inbound_callansweredbyagent.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildDbFbseHandler() {
  final pipeline = const Pipeline().addMiddleware(db_fbse_middleware.middleware);
  final router = Router()
    ..all('/', (context) => db_fbse_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildNewHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<id>', (context,id,) => new_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

