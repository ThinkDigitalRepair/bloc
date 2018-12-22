import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final CounterBloc _counterBloc = CounterBloc();
  final CounterBloc2 _counterBloc2 = CounterBloc2();
  Bloc currentBloc;
  String title;

  Widget _body;
  @override
  void initState() {
    currentBloc = _counterBloc;
    _body = CounterPage();
    title = 'Counter';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: BlocProvider(
        blocs: [_counterBloc, _counterBloc2],
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      _body = CounterPage2();
                      currentBloc = _counterBloc2;
                      title = "Counter2";
                    });
                  },
                  icon: Icon(Icons.keyboard_arrow_right),
                  label: Text("Go to #2"))
            ],
          ),
          body: _body,
          floatingActionButton: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    currentBloc.dispatch(currentBloc is CounterBloc
                        ? Increment()
                        : Increment2());
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: FloatingActionButton(
                  child: Icon(Icons.remove),
                  onPressed: () {
                    currentBloc.dispatch(currentBloc is CounterBloc
                        ? Decrement()
                        : Decrement2());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _counterBloc.dispose();
    super.dispose();
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);

    return BlocBuilder<CounterEvent, int>(
      bloc: _counterBloc,
      builder: (BuildContext context, int count) {
        return Center(
          child: Text(
            '$count',
            style: TextStyle(fontSize: 24.0),
          ),
        );
      },
    );
  }
}

class CounterPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc2 _counterBloc2 = BlocProvider.of<CounterBloc2>(context);

    return BlocBuilder<Counter2Event, int>(
      bloc: _counterBloc2,
      builder: (BuildContext context, int count) {
        return Center(
          child: Text(
            '$count',
            style: TextStyle(fontSize: 24.0),
          ),
        );
      },
    );
  }
}

abstract class CounterEvent {}

class Increment extends CounterEvent {
  @override
  String toString() => 'Increment';
}

class Decrement extends CounterEvent {
  @override
  String toString() => 'Decrement';
}

class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(int currentState, CounterEvent event) async* {
    if (event is Increment) {
      yield currentState + 1;
    }
    if (event is Decrement) {
      yield currentState - 1;
    }
  }
}

abstract class Counter2Event {}

class Increment2 extends Counter2Event {
  @override
  String toString() => 'Increment2';
}

class Decrement2 extends Counter2Event {
  @override
  String toString() => 'Decrement2';
}

class CounterBloc2 extends Bloc<Counter2Event, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(int currentState, Counter2Event event) async* {
    if (event is Increment2) {
      yield currentState + 1;
    }
    if (event is Decrement2) {
      yield currentState - 1;
    }
  }
}
