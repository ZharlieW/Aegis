import 'package:aegis/common/common_image.dart';
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/utils/took_kit.dart';
import 'package:flutter/material.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  ActivitiesState createState() => ActivitiesState();
}

class ActivitiesState extends State<Activities> {
  List<SignedEventDBISAR> _events = [];
  List<SignedEventDBISAR> _filteredEvents = [];
  bool _isLoading = true;
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
    });

    try {
      final events = await SignedEventManager.sharedInstance.getAllSignedEvents();
      setState(() {
        _events = events;
        _filteredEvents = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }



  String _formatTimestamp(int timestamp) {
    return TookKit.formatTimestamp(timestamp);
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
        title: const Text('Activities'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          Text(
            '${_filteredEvents.length}/${_events.length}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
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
            'No signed events',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Signed events will appear here when you sign them',
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
    String name = event.applicationName ?? '--';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _getEventContent(event),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(event.signedTimestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Success checkmark
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
} 