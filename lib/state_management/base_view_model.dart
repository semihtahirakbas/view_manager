part of 'stateful_value_listenable.dart';

abstract class BaseViewModel<T> {
  BaseViewModel();

  final StatefulValueNotifier<T> _item = StatefulValueNotifier();

  StatefulValueListenable<T> get listeningItem => _item;
}
