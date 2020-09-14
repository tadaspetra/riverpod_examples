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
      title: 'Riverpod Demo',
      home: Home(),
    );
  }
}

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final text = useProvider(textProvider);
    final counter = useProvider(counterProvider);
    final future = useProvider(futureProvider);
    final stream = useProvider(streamProvider);
    final int stateNotifierState = useProvider(stateNotifierProvider.state);
    final stateNotifier = useProvider(stateNotifierProvider);
    final changeNotifier = useProvider(changeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Provider: " + text),
            SizedBox(
              height: 20,
            ),
            future.when(
              data: (config) {
                return Text("FutureProvider: " + config.toString());
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
            // (future.data == null)
            //     ? CircularProgressIndicator()
            //     : Text(future.data.value.toString()),

            Consumer(
              builder: (BuildContext context,
                  T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
                var config = watch(futureProvider);

                return config.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                  data: (config) {
                    return Text("FutureProvider: " + config.toString());
                  },
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            stream.when(
              data: (config) {
                return Text("StreamProvider: " + config.toString());
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
            SizedBox(
              height: 20,
            ),
            // Consumer is a widget that allows you reading providers.
            // You could also use the hook "useProvider" if you uses flutter_hooks
            Text("StateProvider: " + counter.state.toString()),
            Consumer(builder: (context, watch, _) {
              final count = watch(counterProvider).state;
              return Text('StateProvider: $count');
            }),
            SizedBox(
              height: 20,
            ),
            //TODO: This part does not rebuild, what am i doing wrong?
            Text("StateNotifierProvider: " + stateNotifierState.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    stateNotifier.add();
                  },
                  child: Text("add"),
                ),
                RaisedButton(
                  onPressed: () {
                    stateNotifier.subtract();
                  },
                  child: Text("subtract"),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("ChangeNotifierProvider: " + changeNotifier.number.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // The read method is an utility to read a provider without listening to it
        onPressed: () => counter.state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Counter example')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Consumer is a widget that allows you reading providers.
//             // You could also use the hook "useProvider" if you uses flutter_hooks
//             Consumer(builder: (context, watch, _) {
//               final count = watch(counterProvider).state;
//               return Text('$count');
//             }),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         // The read method is an utility to read a provider without listening to it
//         onPressed: () => context.read(counterProvider).state++,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
