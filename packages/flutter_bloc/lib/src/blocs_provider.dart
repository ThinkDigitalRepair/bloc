import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

/// A Flutter widget which provides a bloc to its children via `BlocsProvider.of(context)`.
/// It is used as a DI widget so that a single instance of a bloc can be provided
/// to multiple widgets within a subtree.
class BlocsProvider extends InheritedWidget {
  /// The [Bloc] which is to be made available throughout the subtree
  final List<Bloc> blocs;

  /// The [Widget] and its descendants which will have access to the [Bloc].
  final Widget child;

  BlocsProvider({
    Key key,
    @required this.blocs,
    @required this.child,
  })  : assert(blocs != null),
        assert(child != null),
        super(key: key);

  /// Method that allows widgets to access the bloc as long as their `BuildContext`
  /// contains a `BlocsProvider` instance.
  static Bloc of(BuildContext context, Type blocType) {
    final BlocsProvider provider = context
        .ancestorInheritedElementForWidgetOfExactType(BlocsProvider)
        ?.widget;

    Bloc bloc;
    context.visitAncestorElements((element) {
      Widget widget = element.widget;
      if (widget is BlocsProvider) {
        bloc = widget.blocs.firstWhere(
            (Bloc bloc) => bloc.runtimeType == blocType,
            orElse: () => null);
        if (bloc != null) return false;
      }
      return true;
    });
    if (provider == null || bloc == null) {
      throw FlutterError(
          'BlocsProvider.of() called with a context that does not contain a Bloc of type $blocType.\n'
          'No ancestor could be found starting from the context that was passed '
          'to BlocsProvider.of(). This can happen '
          'if the context you use comes from a widget above the BlocsProvider.\n'
          'The context used was:\n'
          '  $context');
    }
    return bloc;
  }

  /// Necessary to obtain generic [Type]
  /// https://github.com/dart-lang/sdk/issues/11923

  @override
  bool updateShouldNotify(BlocsProvider oldWidget) => false;
}
