part of 'stateful_value_listenable.dart';

class StateManagementMultiProviders extends StatelessWidget {
  /// The list of provider configurations.
  final List<BaseViewModel> viewModels;

  /// The child widget that will have access to the provided view models.
  final Widget child;

  /// Creates a [StateManagementMultiProviders].
  ///
  /// The [providers] list must not be null or empty.
  /// The [child] is the widget subtree that can access the provided view models.
  const StateManagementMultiProviders({
    super.key,
    required this.viewModels,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget tree = child;
    // Nest the providers by wrapping the child with each provider.
    for (final viwModel in viewModels.reversed) {
      tree = StateManagementProvider(
        viewModel: viwModel,
        create: (context) => this,
      );
    }
    return tree;
  }
}
