library json_dynamic_widget;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:json_dynamic_widget_annotation/annotation.dart';
import 'package:json_dynamic_widget_generator/templates/child_param.dart';
import 'package:json_dynamic_widget_generator/templates/template_zero_arguments.dart';
import 'package:source_gen/source_gen.dart';

import 'templates/template.dart';

/// generate all json component code
class JsonComponentGenerator
    extends GeneratorForAnnotation<JsonDynamicWidgetAnnotation> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw 'Json Component generation can only apply to class elements';
    }
    final constructor = element.unnamedConstructor!;

    ChildType type = ChildType.none;

    final childParam = constructor.parameters
        .cast<ParameterElement?>()
        .firstWhere((e) => e?.name == 'child', orElse: () => null);

    final childrenParam = constructor.parameters
        .cast<ParameterElement?>()
        .firstWhere((e) => e?.name == 'children', orElse: () => null);

    if (childParam != null && childrenParam != null) {
      throw "DynamicWidget can't has child and children param in same time";
    }

    if (childParam != null) {
      type = childParam.isRequiredNamed
          ? ChildType.requiredChild
          : ChildType.child;
    }
    if (childrenParam != null) type = ChildType.children;

    if (childParam?.isRequiredNamed ?? false) {
      type = ChildType.requiredChild;
    }

    bool hasKey = constructor.parameters.any((e) => e.name == 'key');

    final hasOnRegister =
        element.lookUpMethod('onRegister', element.library) != null;

    final parameters = constructor.parameters
        .where((e) => !{'key', 'child', 'children'}.contains(e.name));

    final enrich =
        parameters.isEmpty ? enrichTemplateZeroArguments : enrichTemplate;
    return enrich(
      className: element.name,
      required: parameters.where((e) => e.isRequiredPositional).toList(),
      optional: parameters.where((e) => e.isOptionalPositional).toList(),
      named: parameters.where((e) => e.isNamed).toList(),
      builderName: annotation.peek('builderName')?.stringValue,
      childType: type,
      hasKey: hasKey,
      hasOnRegister: hasOnRegister,
    );
  }
}

Builder generateJsonComponent(BuilderOptions options) => PartBuilder(
      [JsonComponentGenerator()],
      '.json_component.dart',
      header: '// ignore_for_file: annotate_overrides, unused_element',
    );
