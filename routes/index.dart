import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  if (context.request.method == HttpMethod.post) {
    return Response(body: 'Welcome to Dart Frog!');
  } else {
    return Response(body: 'halua!', statusCode: HttpStatus.methodNotAllowed);
  }
}
