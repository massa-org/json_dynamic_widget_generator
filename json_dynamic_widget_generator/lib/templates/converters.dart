import 'package:theme_json_converter/type_converter_mapping.dart';

// TODO add ability to add custom converters

/// list of supported json converters
final converters =
    typeConverterMapping.map((key, value) => MapEntry(key, '@$value()'));
