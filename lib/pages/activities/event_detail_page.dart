
import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/utils/took_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../db/clientAuthDB_isar.dart';
import '../../utils/account_manager.dart';

class EventDetailPage extends StatefulWidget {
  final SignedEventDBISAR event;
  
  const EventDetailPage({super.key, required this.event});

  @override
  EventDetailPageState createState() => EventDetailPageState();
}

class EventDetailPageState extends State<EventDetailPage> {
  ClientAuthDBISAR? _clientAuthDBISAR;

  @override
  void initState() {
    super.initState();
    _loadClientInfo();
  }

  void _loadClientInfo() {
    if (widget.event.applicationPubkey != null) {
      _clientAuthDBISAR = AccountManager.sharedInstance.applicationMap[widget.event.applicationPubkey!]?.value;
    }
  }

  String _formatTimestamp(int timestamp) {
    return TookKit.formatTimestamp(timestamp);
  }

  String _getEventKindDescription(int eventKind) {
    return SignedEventManager.sharedInstance.getEventKindDescription(eventKind);
  }

  String _getStatusDescription(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Signed';
      case 2:
        return 'Failed';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getConnectionTypeDescription() {
    if (_clientAuthDBISAR == null) return 'Unknown';
    
    bool isBunker = _clientAuthDBISAR!.connectionType == EConnectionType.bunker.toInt;
    return isBunker ? 'Bunker' : 'Nostr Connect';
  }

  Widget _buildInfoSection(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isCopyable = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isCopyable && value.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.copy,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          IconButton(
            onPressed: () {
              // Share event details
              final eventDetails = '''
                Event Details:
                - Event ID: ${widget.event.eventId}
                - Event Kind: ${_getEventKindDescription(widget.event.eventKind)} (${widget.event.eventKind})
                - Content: ${widget.event.eventContent}
                - Application: ${widget.event.applicationName ?? 'Unknown'}
                - Signed: ${_formatTimestamp(widget.event.signedTimestamp)}
                - Status: ${_getStatusDescription(widget.event.status)}
              ''';
              Clipboard.setData(ClipboardData(text: eventDetails));
              ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                          content: Text('Event details copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
              );
            },
            icon: Icon(
              Icons.share,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event header with icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.event.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getStatusIcon(widget.event.status),
                        color: _getStatusColor(widget.event.status),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getEventKindDescription(widget.event.eventKind),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStatusDescription(widget.event.status),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _getStatusColor(widget.event.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Event details
              _buildInfoSection(
                'Event Details',
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Event ID', widget.event.eventId, isCopyable: true),
                      _buildInfoRow('Event Kind', '${_getEventKindDescription(widget.event.eventKind)} (${widget.event.eventKind})'),
                      _buildInfoRow('Status', _getStatusDescription(widget.event.status)),
                      _buildInfoRow('Signed Time', _formatTimestamp(widget.event.signedTimestamp)),
                      _buildInfoRow('User Pubkey', widget.event.userPubkey, isCopyable: true),
                    ],
                  ),
                ),
              ),

              // Application details
              if (widget.event.applicationName != null || widget.event.applicationPubkey != null)
                _buildInfoSection(
                  'Application Details',
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (widget.event.applicationName != null)
                          _buildInfoRow('Name', widget.event.applicationName!),
                        if (widget.event.applicationPubkey != null)
                          _buildInfoRow('Pubkey', widget.event.applicationPubkey!, isCopyable: true),
                        if (_clientAuthDBISAR != null)
                          _buildInfoRow('Connection Type', _getConnectionTypeDescription()),
                      ],
                    ),
                  ),
                ),

              // Metadata
              if (widget.event.metadata != null && widget.event.metadata!.isNotEmpty)
                _buildInfoSection(
                  'Metadata',
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Raw metadata section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Raw Metadata:',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: widget.event.metadata!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Raw metadata copied to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.copy,
                                size: 18,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Text(
                            widget.event.metadata!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.schedule;
      case 1:
        return Icons.check_circle;
      case 2:
        return Icons.error;
      default:
        return Icons.help;
    }
  }
}
