part of '../stateful_value_listenable.dart';

extension StateManagementProviderExtension on BuildContext {
  R read<R extends BaseViewModel>() {
    final provider =
        dependOnInheritedWidgetOfExactType<StateManagementProvider<R>>();

    assert(provider != null, 'No StateManagementProvider<$R> found in context');
    return provider!.viewModel;
  }
}
