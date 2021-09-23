import 'package:example/test_widget.dart';
import 'package:flutter/material.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    SomeTextWidgetBuilder.register();
    WRChildBuilder.register();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const JsonWidget({
        'type': 'w_r_child',
        'args': {
          'color': '#00ff00',
        },
        'child': {
          'type': 'center',
          'child': {
            'type': 'some_text_widget',
            'args': {
              'html': 'someHtml',
              'color': '#ff0000',
            },
          }
        }
      }),
    );
  }
}

class JsonWidget extends StatefulWidget {
  const JsonWidget(this.json, {Key? key}) : super(key: key);

  final Map<String, dynamic> json;

  @override
  State<JsonWidget> createState() => _JsonWidgetState();
}

class _JsonWidgetState extends State<JsonWidget> {
  late final JsonWidgetData _data;
  @override
  void initState() {
    super.initState();
    _data = JsonWidgetData.fromDynamic(widget.json)!;
  }

  @override
  Widget build(BuildContext context) {
    return _data.build(context: context);
  }
}
