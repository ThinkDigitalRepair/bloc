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
  final navigationBloc = NavigationBloc();
  runApp(BlocsProvider(blocs: [navigationBloc], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final _counterBloc = CounterBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocsProvider(
      blocs: [SayHiBloc()],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: BlocProvider<CounterBloc>(
          bloc: _counterBloc,
          child: Scaffold(
            body: BlocBuilder<NavigationEvent, int>(
                bloc:
                    BlocsProvider.of(context, NavigationBloc) as NavigationBloc,
                builder: (BuildContext context, int state) {
                  return [CounterPage(), SecondPage()][state];
                }),
            bottomNavigationBar: BlocBuilder<NavigationEvent, int>(
              bloc: BlocsProvider.of(context, NavigationBloc) as NavigationBloc,
              builder: (BuildContext context, int state) {
                return BottomNavigationBar(
                  currentIndex: state,
                  onTap: (int index) =>
                      BlocsProvider.of(context, NavigationBloc)
                          .dispatch(NavigateTo(index)),
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.looks_one),
                      title: Text("Single Bloc"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.looks_two),
                      title: Text("Multiple Bloc"),
                    ),
                  ],
                );
              },
            ),
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

    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: BlocBuilder<CounterEvent, int>(
        bloc: _counterBloc,
        builder: (BuildContext context, int count) {
          return Center(
            child: Text(
              '$count',
              style: TextStyle(fontSize: 24.0),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _counterBloc.dispatch(Increment());
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: () {
                _counterBloc.dispatch(Decrement());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SayHiBloc sayHiBloc = BlocsProvider.of(context, SayHiBloc);
    return Center(
      child: BlocBuilder<SayHiEvent, String>(
        bloc: sayHiBloc,
        builder: (BuildContext context, String state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                child: TextField(
                  decoration: InputDecoration(labelText: "Name"),
                  onChanged: (String text) => sayHiBloc.dispatch(SayHiTo(text)),
                ),
              ),
              Text(state)
            ],
          );
        },
      ),
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

class NavigationBloc extends Bloc<NavigationEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(int currentState, event) async* {
    if (event is NavigateTo)
      yield event.index;
    else
      yield currentState;
  }
}

class NavigationEvent {}

class NavigateTo extends NavigationEvent {
  final int index;

  NavigateTo(this.index);
}

class SayHiBloc extends Bloc<SayHiEvent, String> {
  @override
  String get initialState => "No one";

  @override
  void onTransition(Transition<SayHiEvent, String> transition) {
    print(transition);
  }

  @override
  Stream<SayHiEvent> transform(Stream<SayHiEvent> events) {
    return events.transform(
        StreamTransformer.fromHandlers(handleData: (SayHiEvent event, sink) {
      if (event is SayHiTo) {
        sink.add(SayHiTo("Hi, " + event.name));
      }
    }));
  }

  @override
  Stream<String> mapEventToState(String currentState, event) async* {
    if (event is SayHiTo)
      yield event.name;
    else
      yield currentState;
  }
}

class SayHiEvent {}

class SayHiTo extends SayHiEvent {
  final String name;

  SayHiTo(this.name);

  @override
  String toString() {
    return "Saying hi to name $name";
  }
}
