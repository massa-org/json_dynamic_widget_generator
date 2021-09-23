Generate builder for widget to use it with json_dynamic_widget
## Features

- generate builders
- process child/children param
- pass key param
- define custom builder name
- serialize material theme classes

## Getting started
Add to pubspec.yaml
```yaml
dependencies:
  json_dynamic_widget_annotation: ^0.0.1

dev_dependencies:
  json_dynamic_widget_generator: ^0.0.1
  
  build_runner: ^2.0.0
```
## Usage

Annotate widget with `@JsonDynamicWidgetAnnotation()` and add part files '*.g.dart' and '*.json_component.dart'

```dart
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as _html;
// import annotation
import 'package:json_dynamic_widget_annotation/json_dynamic_widget_annotation.dart';

part 'html_widget.g.dart';
part 'html_widget.json_component.dart';

// Generated builder has name `${className}Builder` or you can pass name into annotation parameter
// `type` of builder is className in snake_case
@JsonDynamicWidgetAnnotation()
class HtmlWidget extends StatelessWidget {
  const SomeTextWidget(this.html, {Key? key}) : super(key: key);

  final String html;

  @override
  Widget build(BuildContext context) {
    return _html.HtmlWidget(html);
  }
}

// then register builder
HtmlWidgetBuilder.register(JsonWidgetRegistry.instance);

```

Than just run `build_runner`

## Additional info
For more info about widget build process and usage see [json_dynamic_widget](https://pub.dev/packages/json_dynamic_widget)