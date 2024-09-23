part of 'stateful_value_listenable.dart';

class StateManagementProvider<T extends BaseViewModel> extends InheritedWidget {
  final T viewModel;
  final Function(BuildContext context) create;

  StateManagementProvider({
    super.key,
    required this.viewModel,
    required this.create,
  }) : super(child: Builder(builder: (context) => create.call(context)));

  static T of<T extends BaseViewModel>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<StateManagementProvider<T>>();
    //print(provider?.viewModel.runtimeType);
    assert(provider != null, 'No StateManagementProvider<$T> found in context');
    return provider!.viewModel;
  }

  @override
  bool updateShouldNotify(StateManagementProvider<T> oldWidget) {
    return viewModel != oldWidget.viewModel;
  }
}
