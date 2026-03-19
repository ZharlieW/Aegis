/// View model for one pending permission type inside the batch dialog.
class BatchPermissionGroupView {
  final String methodKey;
  final String description;
  final int count;
  final bool selected;
  final bool alwaysAllow;

  const BatchPermissionGroupView({
    required this.methodKey,
    required this.description,
    required this.count,
    required this.selected,
    required this.alwaysAllow,
  });
}

