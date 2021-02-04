import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_example/database.dart';
import 'package:state_notifier/state_notifier.dart';

// user state for the app
final userProvider = FutureProvider.autoDispose.family<String, String>((ref, str) async {
  if (str == "Tadas") {
    return "Good Tadas";
  }
  return ref.read(databaseProvider).getUserData();
});

// counter state notifier for the app
final counterController = StateNotifierProvider<CounterNotifier>((ref) => CounterNotifier());

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void add() {
    state = state + 1;
  }

  void subtract() {
    state = state - 1;
  }
}

// async state notifier provider for state that doesn't change in real time
final counterAsyncController = StateNotifierProvider<CounterAsyncNotifier>((ref) => CounterAsyncNotifier(ref.read));

class CounterAsyncNotifier extends StateNotifier<AsyncValue<int>> {
  CounterAsyncNotifier(this.read) : super(AsyncLoading()) {
    _init();
  }

  final Reader read;

  void _init() async {
    await read(databaseProvider).initDatabase();
    state = AsyncData(0);
  }

  void add() async {
    state = AsyncLoading();
    int count = await read(databaseProvider).increment();
    state = AsyncData(count);
  }

  void subtract() async {
    state = AsyncLoading();
    int count = await read(databaseProvider).decrement();
    state = AsyncData(count);
  }
}
