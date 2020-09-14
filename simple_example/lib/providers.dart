import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final textProvider = Provider<String>((ref) => "hello");

final futureProvider = FutureProvider<int>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  return 5;
});

final streamProvider = StreamProvider<int>((ref) {
  return Stream.periodic(Duration(seconds: 2), (number) {
    if (number < 5) {
      return number + 1;
    } else {
      return 5;
    }
  });
});

/// Providers are declared globally and specifies how to create a state
final counterProvider = StateProvider<int>((ref) => 0);

final stateNotifierProvider =
    StateNotifierProvider<CountNotifier>((ref) => CountNotifier());

class CountNotifier extends StateNotifier<int> {
  CountNotifier() : super(6);

  void add() {
    state = state + 1;
  }

  void subtract() {
    state = state - 1;
  }
}

class CountState {
  final int counter;

  CountState(this.counter);
}

final changeNotifierProvider =
    ChangeNotifierProvider<ChangeCountNotifier>((ref) => ChangeCountNotifier());

class ChangeCountNotifier extends ChangeNotifier {
  int number = 0;
  void add() {
    number++;
    notifyListeners();
  }

  void subtract() {
    number--;
    notifyListeners();
  }
}
