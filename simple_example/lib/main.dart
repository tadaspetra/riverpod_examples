import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_example/providers.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final text = useProvider(textProvider);
    final future = useProvider(futureProvider);
    final stream = useProvider(streamProvider);
    final state = useProvider(stateProvider);

    final int stateNotifierState = useProvider(stateNotifierProvider.state);
    final stateNotifier = useProvider(stateNotifierProvider);

    final changeNotifier = useProvider(changeNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Text Provider: " + text),
            SizedBox(height: 20),
            future.when(
              data: (config) {
                return Text("Future Provider: " + config.toString());
              },
              loading: () => CircularProgressIndicator(),
              error: (err, stack) => Text("Error: " + err),
            ),
            SizedBox(height: 20),
            stream.when(
              data: (config) {
                return Text("Stream Provider: " + config.toString());
              },
              loading: () => CircularProgressIndicator(),
              error: (err, stack) => Text("Error: " + err),
            ),
            SizedBox(height: 20),
            Text("State Provider: " + state.state.toString()),
            SizedBox(height: 20),
            Text("StateNotifier Provider: " + stateNotifierState.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () {
                    stateNotifier.add();
                  },
                  child: Text("add"),
                ),
                RaisedButton(
                  onPressed: () {
                    context.read(stateNotifierProvider).subtract();
                  },
                  child: Text("subtract"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
                "ChangeNotifier Provider: " + changeNotifier.number.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () {
                    changeNotifier.add();
                  },
                  child: Text("add"),
                ),
                RaisedButton(
                  onPressed: () {
                    changeNotifier.subtract();
                  },
                  child: Text("subtract"),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // The read method is an utility to read a provider without listening to it
        onPressed: () {
          state.state++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
