import 'package:analyzer/dart/element/element.dart';
import 'package:json_dynamic_widget_generator/templates/child_param.dart';
import 'package:json_dynamic_widget_generator/templates/on_register.dart';
import 'package:recase/recase.dart';

/// templatet to widget without arguments
String enrichTemplateZeroArguments({
  required String className,
  required List<ParameterElement> required,
  required List<ParameterElement> optional,
  required List<ParameterElement> named,
  required String? builderName,
  required ChildType childType,
  required bool hasKey,
  required bool hasOnRegister,
}) {
  final all = required.followedBy(optional).followedBy(named).toList();
  final positional = required.followedBy(optional).toList();

  final String argumentName = '_${className}Arguments';
  final String _builderName = builderName ?? '${className}Builder';

  final String childVar = getChildString(childType);
  final String childParam = getChildParamString(childType);
  final String childCount = getChildCount(childType);

  return '''
// generate for widget without arguments
class $_builderName extends JsonWidgetBuilder {
  $_builderName() : super(numSupportedChildren: $childCount);

  static const type = '${ReCase(className).snakeCase}';

  static $_builderName? fromDynamic(
    dynamic map, {
    JsonWidgetRegistry? registry,
  }) {
    if (map == null) return null;

    return $_builderName();
  }

  @override
  Widget buildCustom({
    Widget Function(BuildContext context, Widget child)? childBuilder,
    required BuildContext context,
    required JsonWidgetData data,
    Key? key,
  }) {
    $childVar

    return $className(
      ${hasKey ? 'key: key,' : ''}
      $childParam
    );
  }

${registrationFnString(className: className, builderName: _builderName, hasOnRegister: hasOnRegister)}
}
''';
}
