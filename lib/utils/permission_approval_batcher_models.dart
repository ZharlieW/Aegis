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

/// Aggregated selection stats for the current batch permission groups.
class BatchPermissionSelectionStats {
  final int totalGroups;
  final int selectedGroups;
  final int totalRequests;
  final int selectedRequests;

  const BatchPermissionSelectionStats({
    required this.totalGroups,
    required this.selectedGroups,
    required this.totalRequests,
    required this.selectedRequests,
  });

  bool get hasSelection => selectedGroups > 0;

  static BatchPermissionSelectionStats fromGroups(
    List<BatchPermissionGroupView> groups,
  ) {
    final totalGroups = groups.length;
    final selectedGroups = groups.where((g) => g.selected).length;
    final totalRequests = groups.fold<int>(0, (sum, g) => sum + g.count);
    final selectedRequests = groups
        .where((g) => g.selected)
        .fold<int>(0, (sum, g) => sum + g.count);

    return BatchPermissionSelectionStats(
      totalGroups: totalGroups,
      selectedGroups: selectedGroups,
      totalRequests: totalRequests,
      selectedRequests: selectedRequests,
    );
  }
}

