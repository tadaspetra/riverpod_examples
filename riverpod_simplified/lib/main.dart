import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riverpod Simplified")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer(
              builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
                return watch(userProvider("Tadas")).maybeWhen(
                  data: (String value) {
                    return Text(value);
                  },
                  orElse: () {
                    return CircularProgressIndicator();
                  },
                );
              },
            ),
            SizedBox(
              height: 100,
            ),
            Consumer(
              builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
                return Text("Basic: " + watch(counterController.state).toString());
              },
            ),
            SizedBox(
              height: 100,
            ),
            Consumer(
              builder: (BuildContext context, T Function<T>(ProviderBase<Object, T>) watch, Widget child) {
                return watch(counterAsyncController.state).when(
                  data: (int value) {
                    return Text("AsyncValue: " + value.toString());
                  },
                  error: (Object error, StackTrace stackTrace) {
                    return Text("error");
                  },
                  loading: () {
                    return CircularProgressIndicator();
                  },
                );
              },
            ),
            SizedBox(
              height: 100,
            ),
            RaisedButton(
              child: Text("Add"),
              onPressed: () {
                context.read(counterController).add();
                context.read(counterAsyncController).add();
              },
            ),
            RaisedButton(
              child: Text("Subtract"),
              onPressed: () {
                context.read(counterController).subtract();
                context.read(counterAsyncController).subtract();
              },
            )
          ],
        ),
      ),
    );
  }
}
