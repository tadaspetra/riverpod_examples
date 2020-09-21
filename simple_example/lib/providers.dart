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

final stateProvider = StateProvider<int>((ref) => 0);

final stateNotifierProvider =
    StateNotifierProvider<CountNotifier>((ref) => CountNotifier(6));

class CountNotifier extends StateNotifier<int> {
  CountNotifier(int state) : super(6);
  void add() {
    state = state + 1;
  }

  void subtract() {
    state = state - 1;
  }
}

final changeNotifierProvider =
    ChangeNotifierProvider<ChangeCount>((ref) => ChangeCount());

class ChangeCount extends ChangeNotifier {
  int number = 6;
  void add() {
    number++;
    notifyListeners();
  }

  void subtract() {
    number--;
    notifyListeners();
  }
}
