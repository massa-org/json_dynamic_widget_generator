library theme_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:json_dynamic_widget_annotation/annotation.dart';
import 'package:json_dynamic_widget_generator/templates/child_param.dart';
import 'package:json_dynamic_widget_generator/templates/template_zero_arguments.dart';
import 'package:source_gen/source_gen.dart';

import 'templates/template.dart';

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

    bool setType(ChildType _type) {
      type = _type;
      return true;
    }

    bool hasKey = false;
    bool setKey() {
      hasKey = true;
      return true;
    }

    bool _omit(ParameterElement e) {
      return (e.isNamed && e.isOptional && e.name == 'key' && setKey()) ||
          (e.isNamed &&
              e.name == 'child' &&
              setType(
                e.isRequiredNamed ? ChildType.requiredChild : ChildType.child,
              )) ||
          (e.isNamed && e.name == 'children' && setType(ChildType.children));
    }

    final onRegister = element.lookUpMethod('onRegister', element.library);

    final parameters = constructor.parameters.where((e) => !_omit(e));

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
      hasOnRegister: onRegister != null,
    );
  }
}

Builder generateJsonComponent(BuilderOptions options) => PartBuilder(
      [JsonComponentGenerator()],
      '.json_component.dart',
      header: '// ignore_for_file: annotate_overrides, unused_element',
    );
