import 'package:aegis/common/common_image.dart';
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/utils/tool_kit.dart';
import 'package:flutter/material.dart';

import 'package:aegis/db/clientAuthDB_isar.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'package:aegis/navigator/navigator.dart';
import 'event_detail_page.dart';

class Activities extends StatefulWidget {
  final ClientAuthDBISAR? clientAuthDBISAR;
  final String? applicationPubkey; // For NIP-07 applications
  
  const Activities({
    super.key,
    this.clientAuthDBISAR,
    this.applicationPubkey,
  });

  @override
  ActivitiesState createState() => ActivitiesState();
}

class ActivitiesState extends State<Activities> {
  List<SignedEventDBISAR> _filteredEvents = [];
  bool _isLoading = true;
  bool _hasLoadError = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _hasLoadError = false;
    });

    try {
      List<SignedEventDBISAR> events;

      if (widget.clientAuthDBISAR != null) {
        events = await SignedEventManager.sharedInstance.getSignedEventsByPubkey(widget.clientAuthDBISAR!.clientPubkey);
      } else if (widget.applicationPubkey != null && widget.applicationPubkey!.isNotEmpty) {
        events = await SignedEventManager.sharedInstance.getSignedEventsByPubkey(widget.applicationPubkey!);
      } else {
        events = await SignedEventManager.sharedInstance.getAllSignedEvents();
      }

      if (mounted) {
        setState(() {
          _filteredEvents = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasLoadError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.activitiesLoadFailed)),
        );
      }
    }
  }



  String _formatTimestamp(int timestamp) {
    return ToolKit.formatTimestamp(timestamp);
  }

  String _getAppBarTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.clientAuthDBISAR != null) {
      return widget.clientAuthDBISAR?.name ?? l10n.activities;
    } else if (widget.applicationPubkey != null && widget.applicationPubkey!.isNotEmpty) {
      if (_filteredEvents.isNotEmpty && _filteredEvents.first.applicationName != null) {
        return _filteredEvents.first.applicationName!;
      }
      try {
        final uri = Uri.tryParse(widget.applicationPubkey!);
        if (uri != null && uri.host.isNotEmpty) {
          return uri.host;
        }
      } catch (_) {}
      return widget.applicationPubkey!;
    }
    return l10n.activities;
  }

  String _getEventContent(SignedEventDBISAR event) {
    if (event.eventContent.isNotEmpty) {
      return event.eventContent;
    }

    final kindDesc = SignedEventManager.sharedInstance.getEventKindDescription(event.eventKind);
    if (event.applicationName != null) {
      return '$kindDesc - ${event.applicationName}';
    }
    return kindDesc;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_getAppBarTitle(context)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          const SizedBox(width: 8),
          IconButton(
            onPressed: _loadEvents,
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [

            // Main content area
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    // Search bar
                    // Container(
                    //   margin: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(context).colorScheme.surfaceContainer,
                    //     borderRadius: BorderRadius.circular(12),
                    //     border: Border.all(
                    //       color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    //     ),
                    //   ),
                    //   child: TextField(
                    //     controller: _searchController,
                    //     onChanged: _filterEvents,
                    //     decoration: InputDecoration(
                    //       hintText: 'Search events...',
                    //       hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    //       border: InputBorder.none,
                    //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    //       prefixIcon: Icon(
                    //         Icons.search,
                    //         color: Theme.of(context).colorScheme.onSurfaceVariant,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //
                    // Events list
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _hasLoadError
                              ? _buildLoadErrorState()
                              : _filteredEvents.isEmpty
                                  ? _buildEmptyState()
                                  : _buildEventsList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadErrorState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.activitiesLoadFailed,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loadEvents,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonImage(
            iconName: 'aegis_logo.png',
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noSignedEvents,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.signedEventsEmptyHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredEvents.length,
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return _buildEventItem(event);
      },
    );
  }

  Widget _buildEventItem(SignedEventDBISAR event) {

    return GestureDetector(
      onTap: () {
        AegisNavigator.pushPage(context, (context) => EventDetailPage(event: event));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _getEventContent(event),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatTimestamp(event.signedTimestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 