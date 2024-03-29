import 'package:dart_frog/dart_frog.dart';
import 'package:first_api/cors.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(corsHeaders());
}
