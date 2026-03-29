import 'dart:async';

import 'package:flutter/material.dart';

import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/pages/request/batch_request_permission.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/permission_approval_batcher_models.dart';

class _PendingPermissionGroup {
  final String methodKey;
  final String description;
  final List<Completer<bool>> completers = [];
  bool selected = true;
  bool alwaysAllow = false;

  _PendingPermissionGroup({
    required this.methodKey,
    required this.description,
  });

  int get count => completers.length;
}

class _ClientQueueState {
  final String clientPubkey;
  final void Function(String clientPubkey) onQueueBecameIdle;

  final ValueNotifier<List<BatchPermissionGroupView>> groupsNotifier =
      ValueNotifier<List<BatchPermissionGroupView>>(<BatchPermissionGroupView>[]);

  final Map<String, _PendingPermissionGroup> _groups = {};

  bool _dialogShowing = false;
  Timer? _scheduledTimer;
  int _dialogVersion = 0;

  _ClientQueueState(this.clientPubkey, {required this.onQueueBecameIdle});

  bool get _isIdle => !_dialogShowing && _scheduledTimer == null && _groups.isEmpty;

  List<BatchPermissionGroupView> _buildViews() {
    return _groups.values
        .map((g) => BatchPermissionGroupView(
              methodKey: g.methodKey,
              description: g.description,
              count: g.count,
              selected: g.selected,
              alwaysAllow: g.alwaysAllow,
            ))
        .toList();
  }

  void _notify() {
    groupsNotifier.value = _buildViews();
  }

  void dispose() {
    _scheduledTimer?.cancel();
    _scheduledTimer = null;
    groupsNotifier.dispose();
  }

  void setGroupSelected(String methodKey, bool selected) {
    final group = _groups[methodKey];
    if (group == null) return;
    group.selected = selected;
    _notify();
  }

  void setGroupAlwaysAllow(String methodKey, bool alwaysAllow) {
    final group = _groups[methodKey];
    if (group == null) return;
    group.alwaysAllow = alwaysAllow;
    _notify();
  }

  /// Sets [selected] for every pending group in this batch. Does not change
  /// [alwaysAllow] (same semantics as calling [setGroupSelected] per key).
  void setAllGroupsSelected(bool selected) {
    if (_groups.isEmpty) return;
    for (final g in _groups.values) {
      g.selected = selected;
    }
    _notify();
  }

  List<String> _collectAlwaysAllowKeys(
    Iterable<_PendingPermissionGroup> groups,
  ) {
    final toPersist = <String>[];
    for (final g in groups) {
      if (g.selected && g.alwaysAllow) {
        toPersist.add(g.methodKey);
      }
    }
    return toPersist;
  }

  Future<void> _persistAlwaysAllowIfNeeded(
    ClientAuthDBISAR app,
    List<String> toPersist,
  ) async {
    // Persist always-allow method keys for this app.
    // Only persist for groups selected in this confirmed batch.

    if (toPersist.isEmpty) return;

    final updated = app;
    updated.allowedMethods = List<String>.from(updated.allowedMethods);
    for (final key in toPersist) {
      if (!updated.allowedMethods.contains(key)) {
        updated.allowedMethods.add(key);
      }
    }
    updated.allowedMethods.sort();

    await ClientAuthDBISAR.saveFromDB(updated, isUpdate: true);
    AccountManager.sharedInstance.updateApplicationMap(updated);
  }

  Future<void> _completeAll({required bool approveSelected}) async {
    final app = Account.sharedInstance.authToNostrConnectInfo[clientPubkey] ??
        AccountManager.sharedInstance.applicationMap[clientPubkey]?.value;
    final hasApp = app != null;

    // Snapshot and detach current batch first so new incoming requests are not
    // accidentally completed/cleared by this cycle.
    final groupsSnapshot = _groups.values.toList();
    _groups.clear();
    _notify();

    // Complete completers first to unblock server request handling promptly.
    for (final g in groupsSnapshot) {
      final grant = approveSelected ? g.selected : false;
      for (final c in g.completers) {
        if (!c.isCompleted) c.complete(grant);
      }
    }

    // Persist "always allow" after user confirms.
    if (approveSelected && hasApp) {
      try {
        final toPersist = _collectAlwaysAllowKeys(groupsSnapshot);
        await _persistAlwaysAllowIfNeeded(app, toPersist);
      } catch (e) {
        AegisLogger.warning('Failed to persist always-allow batch permission', e);
      }
    }
    _tryCleanupQueue();
  }

  Future<bool> enqueueApproval({
    required String methodKey,
    required String description,
  }) async {
    final completer = Completer<bool>();

    final group = _groups[methodKey] ??
        (() {
          final created = _PendingPermissionGroup(
            methodKey: methodKey,
            description: description,
          );
          _groups[methodKey] = created;
          return created;
        })();

    // If description differs between requests for the same methodKey, keep the
    // original first one to avoid UI flicker.
    group.completers.add(completer);
    _notify();

    if (!_dialogShowing) {
      _scheduledTimer?.cancel();
      _scheduledTimer = Timer(const Duration(milliseconds: 200), () async {
        // Double-check queue wasn't cleared while waiting.
        if (_groups.isEmpty) {
          _scheduledTimer = null;
          _tryCleanupQueue();
          return;
        }
        await _showDialog();
      });
    }

    return completer.future;
  }

  Future<void> _showDialog() async {
    if (_dialogShowing) return;
    final currentVersion = ++_dialogVersion;
    _dialogShowing = true;
    _scheduledTimer?.cancel();
    _scheduledTimer = null;

    // Wait for user decision in UI.
    try {
      await AegisNavigator.presentPage<void>(
        AegisNavigator.navigatorKey.currentContext,
        (_) => BatchRequestPermission(
          clientPubkey: clientPubkey,
          groupsNotifier: groupsNotifier,
          allowDismiss: false,
          onSetSelected: (methodKey, selected) {
            setGroupSelected(methodKey, selected);
          },
          onSetAllSelected: setAllGroupsSelected,
          onSetAlwaysAllow: (methodKey, alwaysAllow) {
            setGroupAlwaysAllow(methodKey, alwaysAllow);
          },
          onApproveSelected: () async {
            await _completeAll(approveSelected: true);
          },
          onRejectAll: () async {
            await _completeAll(approveSelected: false);
          },
        ),
        fullscreenDialog: true,
      );
    } catch (_) {
      // If navigation/dialog fails, deny all pending requests in this queue.
      await _completeAll(approveSelected: false);
    } finally {
      if (_dialogVersion == currentVersion) {
        _dialogShowing = false;
        // If new requests arrived while the previous dialog was being dismissed,
        // open another batch dialog so requests don't get stuck.
        if (_groups.isNotEmpty) {
          _scheduledTimer?.cancel();
          _scheduledTimer = Timer(const Duration(milliseconds: 50), () async {
            if (_groups.isNotEmpty) {
              await _showDialog();
            } else {
              _scheduledTimer = null;
              _tryCleanupQueue();
            }
          });
        } else {
          _tryCleanupQueue();
        }
      }
    }
  }

  void _tryCleanupQueue() {
    if (_isIdle) {
      onQueueBecameIdle(clientPubkey);
    }
  }
}

/// Singleton that batches manual per-request authorization prompts.
class PermissionApprovalBatcher {
  static final PermissionApprovalBatcher instance =
      PermissionApprovalBatcher._internal();

  PermissionApprovalBatcher._internal();

  final Map<String, _ClientQueueState> _queues = {};

  void _onQueueBecameIdle(String clientPubkey) {
    final queue = _queues.remove(clientPubkey);
    queue?.dispose();
  }

  _ClientQueueState _getQueue(String clientPubkey) {
    return _queues.putIfAbsent(
      clientPubkey,
      () => _ClientQueueState(
        clientPubkey,
        onQueueBecameIdle: _onQueueBecameIdle,
      ),
    );
  }

  /// Request user approval for one permission type (`methodKey`) possibly with
  /// multiple occurrences. When multiple requests of the same app are pending,
  /// they will be shown in a single batch dialog.
  Future<bool> requestApproval({
    required String clientPubkey,
    required String methodKey,
    required String description,
  }) async {
    // Ensure we still have UI context to show dialogs. Otherwise deny.
    final context = AegisNavigator.navigatorKey.currentContext;
    if (context == null) {
      AegisLogger.warning('No navigator context for batch permission dialog');
      return false;
    }

    final app = Account.sharedInstance.authToNostrConnectInfo[clientPubkey] ??
        AccountManager.sharedInstance.applicationMap[clientPubkey]?.value;
    if (app == null) return false;
    if (app.authMode == 2) return true;
    if (app.allowedMethods.contains(methodKey)) return true;

    return _getQueue(clientPubkey).enqueueApproval(
      methodKey: methodKey,
      description: description,
    );
  }

  /// Batch select/deselect every pending permission group for [clientPubkey].
  /// Does not change per-group [alwaysAllow] flags (same as repeated
  /// per-[methodKey] selection updates). No-op if there is no active queue.
  void setAllGroupsSelected(String clientPubkey, bool selected) {
    _queues[clientPubkey]?.setAllGroupsSelected(selected);
  }
}

