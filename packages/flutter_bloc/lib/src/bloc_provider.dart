import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

/// A Flutter widget which provides a bloc to its children via `BlocProvider.of(context)`.
/// It is used as a DI widget so that a single instance of a bloc can be provided
/// to multiple widgets within a subtree.
class BlocProvider<T extends Bloc<dynamic, dynamic>> extends StatelessWidget {
  /// The Bloc which is to be made available throughout the subtree
  final T bloc;
  final List<T> blocs;

  /// The Widget and its descendants which will have access to the Bloc.
  final Widget child;
  BlocProvider({
    Key key,
    this.bloc,
    this.blocs,
    @required this.child,
  })
      : assert(bloc !=null && (blocs != null && blocs.isNotEmpty && !blocs.contains(null))),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return stackBlocs(blocs, child);
  }

  BlocProvider<dynamic> stackBlocs(List<Bloc> blocStack, Widget child) {
    print(blocStack);
    if (blocStack.length == 1)
      return BlocProvider(bloc:blocStack.first, child: child,);
    else
      return BlocProvider(bloc: blocStack.removeAt(0), child: stackBlocs(blocStack, child));

  }

  /// Method that allows widgets to access the bloc as long as their `BuildContext`
  /// contains a `BlocProvider` instance.
  static T of<T extends Bloc<dynamic, dynamic>>(BuildContext context) {
    BlocProvider<T> provider =
    context.ancestorWidgetOfExactType(_typeOf<BlocProvider<T>>());
    T bloc = provider.blocs[provider.blocs.indexWhere((bloc) => bloc is T)];
    if (bloc == null) {
      throw FlutterError(
          'BlocProvider.of() called with a context that does not contain a Bloc of type $T.\n'
              'No $T ancestor could be found starting from the context that was passed '
              'to BlocProvider.of(). This can happen '
              'if the context you use comes from a widget above your Bloc.\n'
              'The context used was:\n'
              '  $context'
      );
    }
    return bloc;
  }

  static Type _typeOf<T>() => T;
}
