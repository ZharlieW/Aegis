import 'package:aegis/common/common_image.dart';
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  void _filterEvents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEvents = _events;
      } else {
        _filteredEvents = _events.where((event) {
          return event.eventContent.toLowerCase().contains(query.toLowerCase()) ||
                 (event.applicationName?.toLowerCase().contains(query.toLowerCase()) ?? false);
        }).toList();
      }
    });
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    try {
      if (difference.inDays > 0) {
        return DateFormat('HH:mm:ss - dd MMM').format(date);
      } else {
        return DateFormat('HH:mm:ss').format(date);
      }
    } catch (e) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
    }
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

  String _getEventIdentifier(SignedEventDBISAR event) {
    switch (event.eventKind) {
      case 1:
        return 'TN'; // Text Note
      case 4:
        return 'ED'; // Encrypted Direct Message
      case 24133:
        return 'NC'; // Nostr Connect
      case 22242:
        return 'CA'; // Client Authentication
      case 9734:
        return 'ZP'; // Zap
      case 9735:
        return 'ZR'; // Zap Request
      case 7:
        return 'RT'; // Reaction
      case 6:
        return 'RP'; // Repost
      case 16:
        return 'GR'; // Generic Repost
      case 3:
        return 'CL'; // Contact List
      case 0:
        return 'DL'; // Delete
      case 5:
        return 'ED'; // Event Deletion
      case 2:
        return 'RR'; // Recommend Relay
      case 8:
        return 'BA'; // Badge Award
      case 40:
        return 'CC'; // Channel Creation
      case 41:
        return 'CM'; // Channel Metadata
      case 42:
        return 'CM'; // Channel Message
      case 43:
        return 'CH'; // Channel Hide Message
      case 44:
        return 'CU'; // Channel Mute User
      case 1984:
        return 'RP'; // Reporting
      case 10000:
        return 'ML'; // Mute List
      case 10001:
        return 'PL'; // Pin List
      case 10002:
        return 'RL'; // Relay List Metadata
      case 13194:
        return 'WI'; // Wallet Info
      case 23194:
        return 'WR'; // Wallet Request
      case 23195:
        return 'WS'; // Wallet Response
      case 30000:
        return 'CP'; // Categorized People List
      case 30001:
        return 'CB'; // Categorized Bookmark List
      case 30008:
        return 'PB'; // Profile Badges
      case 30009:
        return 'BD'; // Badge Definition
      case 30017:
        return 'CS'; // Create or update a stall
      case 30018:
        return 'CP'; // Create or update a product
      case 30023:
        return 'LC'; // Long-form Content
      case 30024:
        return 'DC'; // Draft Long-form Content
      case 30030:
        return 'CL'; // Classified Listing
      case 30078:
        return 'AD'; // Application-specific Data
      case 30311:
        return 'LE'; // Live Event
      case 30315:
        return 'US'; // User Statuses
      case 30402:
        return 'CA'; // Community Post Approval
      case 30403:
        return 'CO'; // Community
      case 30404:
        return 'CP'; // Community Post
      case 30405:
        return 'CU'; // Community User
      case 31922:
        return 'DC'; // Date-based Calendar Event
      case 31923:
        return 'TC'; // Time-based Calendar Event
      case 31924:
        return 'CA'; // Calendar
      case 31925:
        return 'CR'; // Calendar Event RSVP
      case 31990:
        return 'HI'; // Handler Information
      case 31991:
        return 'HR'; // Handler Recommendation
      case 31992:
        return 'HC'; // Handler Categorization
      case 34550:
        return 'CL'; // Classified Listing
      case 38000:
        return 'RQ'; // Request
      case 38001:
        return 'RS'; // Response
      case 38002:
        return 'TB'; // Tombstone
      default:
        return 'EV'; // Event (default)
    }
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
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterEvents,
                        decoration: InputDecoration(
                          hintText: 'Search events...',
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          prefixIcon: Icon(
                            Icons.search, 
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Event identifier
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                _getEventIdentifier(event),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Event content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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