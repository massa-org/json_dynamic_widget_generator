enum ChildType {
  none,
  child,
  requiredChild,
  children,
}

String getChildString(ChildType type) {
  switch (type) {
    case ChildType.none:
      return '';
    case ChildType.child:
      return '''
      final child = (data.children?.isEmpty ?? true)
        ? null
        : data.children!.first
            .build(context: context, childBuilder: childBuilder);
            ''';
    case ChildType.requiredChild:
      return 'final child = getChild(data).build(context: context, childBuilder: childBuilder);';
    case ChildType.children:
      return '''
      final children = data.children
            ?.map(
              (e) => e.build(
                context: context,
                childBuilder: childBuilder,
              ),
            )
            .toList() ??
        <Widget>[];
      ''';
  }
}

String getChildParamString(ChildType type) {
  switch (type) {
    case ChildType.none:
      return '';
    case ChildType.child:
    case ChildType.requiredChild:
      return 'child: child,';
    case ChildType.children:
      return 'children: children,';
  }
}

String getChildCount(ChildType type) {
  switch (type) {
    case ChildType.none:
      return '0';
    case ChildType.child:
      return '1';
    case ChildType.requiredChild:
      return '1';
    case ChildType.children:
      return '-1';
  }
}
