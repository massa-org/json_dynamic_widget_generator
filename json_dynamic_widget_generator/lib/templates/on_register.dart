String registrationFnString({
  required String className,
  required String builderName,
  required bool hasOnRegister,
}) {
  return '''
  static void register([JsonWidgetRegistry? registry]){
    (registry ?? JsonWidgetRegistry.instance).registerCustomBuilder(
      $builderName.type,
      JsonWidgetBuilderContainer(
        builder: $builderName.fromDynamic,
      ),
    );
    ${hasOnRegister ? '$className.onRegister($builderName.type);' : ''}
  }
''';
}
