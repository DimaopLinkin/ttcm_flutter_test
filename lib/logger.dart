// Package imports:
import 'package:logger/logger.dart';

final logger = Logger(printer: prettyPrinter);

final prettyPrinter = PrettyPrinter(
  methodCount: 3,
  errorMethodCount: 6,
  lineLength: 150,
  printTime: true,
  colors: false,
);
