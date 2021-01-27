import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_example/database.dart';
import 'package:state_notifier/state_notifier.dart';

// user state for the app
final userProvider = FutureProvider.autoDispose<String>((ref) async {
  return ref.read(databaseProvider).getUserData();
});

// counter state for the app
final counterController = StateNotifierProvider.autoDispose<CountNotifier>((ref) => CountNotifier());

class CountNotifier extends StateNotifier<int> {
  CountNotifier() : super(0);

  void add() {
    state = state + 1;
  }

  void subtract() {
    state = state - 1;
  }
}

// async state notifier provider for state that doesn't change in real time
final counterAsyncController = StateNotifierProvider.autoDispose<CountAsyncNotifier>((ref) => CountAsyncNotifier(ref.read));

class CountAsyncNotifier extends StateNotifier<AsyncValue<int>> {
  CountAsyncNotifier(this.read) : super(AsyncLoading()) {
    _init();
  }

  final Reader read;

  void _init() async {
    await read(databaseProvider).initDatabase();
    state = AsyncData(0);
  }

  void add() async {
    state = AsyncLoading();
    int databaseCount = await read(databaseProvider).increment();
    state = AsyncData(databaseCount);
  }

  void subtract() async {
    state = AsyncLoading();
    int databaseCount = await read(databaseProvider).increment();
    state = AsyncData(databaseCount);
  }
}
