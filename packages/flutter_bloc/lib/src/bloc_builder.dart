import 'package:flutter/widgets.dart';

import 'package:bloc/bloc.dart';

/// A function that will be run which takes the [BuildContext] and state
/// and is responsible for returning a [Widget] which is to be rendered.
/// This is analogous to the `builder` function in [StreamBuilder].
typedef Widget BlocWidgetBuilder<E, S>(BuildContext context, S state);

/// A Flutter widget which requires a [Bloc] and a [BlocWidgetBuilder] `builder` function.
/// [BlocBuilder] handles building the widget in response to new states.
/// BlocBuilder analogous to [StreamBuilder] but has simplified API
/// to reduce the amount of boilerplate code needed.
class BlocBuilder<E, S> extends StatelessWidget {
  final Bloc<E, S> bloc;
  final BlocWidgetBuilder<E, S> builder;

  const BlocBuilder({Key key, @required this.bloc, @required this.builder})
      : assert(bloc != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      initialData: bloc.initialState,
      stream: bloc.state,
      builder: (BuildContext context, AsyncSnapshot<S> snapshot) {
        return builder(context, snapshot.data);
      },
    );
  }
}
