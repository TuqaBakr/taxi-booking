import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'logger.dart';

TalkerDioLogger get dioLogger => TalkerDioLogger(
  talker: talker,
  settings: TalkerDioLoggerSettings(
    printRequestHeaders: true,
    printResponseHeaders: true,
    printResponseMessage: true,
    printRequestData: true,
    printResponseTime: true,
    requestFilter: (RequestOptions options) =>
        !options.path.contains('/secure'),
     responseFilter: (response) => response.statusCode != 301,
  ),
);
