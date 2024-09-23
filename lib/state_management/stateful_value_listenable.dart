library view_manager;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

part 'base_view_model.dart';
part 'value_state.dart';
part 'state_management_multi_providers.dart';
part 'stateful_value_notifier.dart';
part 'state_management_provider.dart';
part 'extension/state_management_provider_extension.dart';

/// A builder function that builds a widget based on the provided value.
typedef ValueWidgetBuilder<T> = Widget Function(BuildContext context, T? value);

/// A builder function that builds a widget based on the provided error and last known value.
typedef ErrorWidgetBuilder<T> = Widget Function(
    BuildContext context, Object? error, T? lastKnownValue);

/// A widget that builds itself based on the latest value of a [StatefulValueListenable].
///
/// It rebuilds whenever the [valueListenable] notifies its listeners.
///
/// **Usage example**:
/// ```dart
/// // Create a StatefulValueNotifier with an initial value
/// final valueNotifier = StatefulValueNotifier<int>(0);
///
/// // Use the StatefulValueListenableBuilder in your widget tree
/// StatefulValueListenableBuilder<int>(
///   valueListenable: valueNotifier,
///   idleBuilder: (context, value) {
///     return Column(
///       mainAxisAlignment: MainAxisAlignment.center,
///       children: [
///         Text('Idle State. Value: \$value'),
///         ElevatedButton(
///           onPressed: () {
///             // Simulate loading state
///             valueNotifier.setLoading();
///             Future.delayed(Duration(seconds: 2), () {
///               // Update to a new idle state with incremented value
///               valueNotifier.setIdle((value ?? 0) + 1);
///             });
///           },
///           child: Text('Increment Value'),
///         ),
///       ],
///     );
///   },
///   loadingBuilder: (context, lastKnownValue) {
///     return Center(
///       child: CircularProgressIndicator(),
///     );
///   },
///   errorBuilder: (context, error, lastKnownValue) {
///     return Column(
///       mainAxisAlignment: MainAxisAlignment.center,
///       children: [
///         Text('Error: \$error'),
///         ElevatedButton(
///           onPressed: () {
///             // Retry by setting the last known value
///             valueNotifier.setIdle(lastKnownValue);
///           },
///           child: Text('Retry'),
///         ),
///       ],
///     );
///   },
/// );
/// ```
///
/// In this example:
/// - The `idleBuilder` displays the current value and a button to increment it.
/// - The `loadingBuilder` shows a `CircularProgressIndicator` while loading.
/// - The `errorBuilder` displays the error message and a retry button.
class StatefulValueListenableBuilder<T> extends StatefulWidget {
  /// The [StatefulValueListenable] to listen to.
  final StatefulValueListenable<T> valueListenable;

  /// The builder function for the idle state.
  final ValueWidgetBuilder<T> idleBuilder;

  /// The builder function for the loading state.
  final ValueWidgetBuilder<T> loadingBuilder;

  /// The builder function for the error state.
  final ErrorWidgetBuilder<T> errorBuilder;

  /// An optional child widget that does not depend on the [valueListenable].
  final Widget? child;

  ///
  final Function(BuildContext context, T? value)? listen;

  /// Creates a [StatefulValueListenableBuilder].
  ///
  /// The [valueListenable] and the builder functions are required.
  const StatefulValueListenableBuilder({
    super.key,
    this.listen,
    required this.valueListenable,
    required this.idleBuilder,
    required this.loadingBuilder,
    required this.errorBuilder,
    this.child,
  });

  @override
  State<StatefulWidget> createState() =>
      _StatefulValueListenableBuilderState<T>();
}

class _StatefulValueListenableBuilderState<T>
    extends State<StatefulValueListenableBuilder<T>> {
  late ValueState<T> _valueState;

  @override
  void initState() {
    super.initState();
    _valueState = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(StatefulValueListenableBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.valueListenable != oldWidget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      _valueState = widget.valueListenable.value;

      widget.listen?.call(context, widget.valueListenable.currentValue);
    }
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      _valueState = widget.valueListenable.value;
      widget.listen?.call(context, widget.valueListenable.currentValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _valueState.when(
      idle: (value) => widget.idleBuilder(context, value),
      loading: (lastKnownValue) =>
          widget.loadingBuilder(context, lastKnownValue),
      error: (error, lastKnownValue) =>
          widget.errorBuilder(context, error, lastKnownValue),
    );
  }
}
