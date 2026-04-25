import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/account_manager.dart';
import 'package:aegis/utils/logger.dart';

class SignedEventManager {
  static final SignedEventManager _instance = SignedEventManager._internal();
  factory SignedEventManager() => _instance;
  SignedEventManager._internal();

  static SignedEventManager get sharedInstance => _instance;

  String _maskValue(
    String? value, {
    int prefix = 6,
    int suffix = 4,
    String fallback = '<empty>',
  }) {
    if (value == null) return fallback;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return fallback;
    if (trimmed.length <= prefix + suffix) return '${trimmed.substring(0, 2)}***';
    final start = trimmed.substring(0, prefix);
    final end = trimmed.substring(trimmed.length - suffix);
    return '$start...$end';
  }

  String _maskContent(String? content, {int maxLength = 48}) {
    if (content == null) return '<empty>';
    final trimmed = content.trim();
    if (trimmed.isEmpty) return '<empty>';
    final collapsed = trimmed.replaceAll(RegExp(r'\s+'), ' ');
    if (collapsed.length <= maxLength) return collapsed;
    return '${collapsed.substring(0, maxLength)}...';
  }

  Future<void> recordSignedEvent({
    required String eventId,
    required int eventKind,
    required String eventContent,
    String? applicationName,
    String? applicationPubkey,
    String? methodKey,
    int status = 1, // 1 = signed
    String? metadata,
  }) async {
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty) {
      AegisLogger.warning('[SignedEventManager] Skip recordSignedEvent: user not logged in');
      return;
    }

    final userPubkey = AccountManager.sharedInstance.applicationMap[applicationPubkey]?.value.pubkey ?? account.currentPubkey;

    AegisLogger.debug(
      '[SignedEventManager] Recording event kind=$eventKind '
      'eventId=${_maskValue(eventId)} '
      'userPubkey=${_maskValue(userPubkey)} '
      'applicationPubkey=${_maskValue(applicationPubkey)} '
      'methodKey=${_maskValue(methodKey, prefix: 4, suffix: 2)} '
      'contentPreview=${_maskContent(eventContent)}',
    );

    final event = SignedEventDBISAR(
      eventId: eventId,
      eventKind: eventKind,
      eventContent: eventContent,
      applicationName: applicationName,
      applicationPubkey: applicationPubkey,
      methodKey: methodKey,
      userPubkey: userPubkey,
      signedTimestamp: DateTime.now().millisecondsSinceEpoch,
      status: status,
      metadata: metadata,
    );

    try {
      await SignedEventDBISAR.saveFromDB(event);
      AegisLogger.info('[SignedEventManager] Event recorded successfully eventId=${_maskValue(eventId)}');
    } catch (e) {
      AegisLogger.error('[SignedEventManager] Failed to record eventId=${_maskValue(eventId)}', e);
      rethrow;
    }
  }

  Future<void> _cleanupOldEventsForApplication(String userPubkey, String applicationPubkey) async {
    try {
      final eventCount = await SignedEventDBISAR.getEventCountByApplicationPubkey(userPubkey, applicationPubkey);
      
      if (eventCount > 50) {
        AegisLogger.info(
          '[SignedEventManager] Cleaning up old events '
          'applicationPubkey=${_maskValue(applicationPubkey)} '
          '(current: $eventCount, keeping latest 50)',
        );
        await SignedEventDBISAR.deleteOldEventsForApplication(userPubkey, applicationPubkey, keepCount: 50);
      } else {
        AegisLogger.debug(
          '[SignedEventManager] No cleanup needed '
          'applicationPubkey=${_maskValue(applicationPubkey)} '
          '(current count: $eventCount)',
        );
      }
    } catch (e) {
      AegisLogger.error(
        '[SignedEventManager] Failed to cleanup old events '
        'applicationPubkey=${_maskValue(applicationPubkey)}',
        e,
      );
    }
  }

  Future<List<SignedEventDBISAR>> getAllSignedEvents() async {
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty) {
      AegisLogger.warning('[SignedEventManager] Skip getAllSignedEvents: user not logged in');
      return [];
    }
    final userPubkey = account.currentPubkey;

    AegisLogger.debug('[SignedEventManager] Getting events for user=${_maskValue(userPubkey)}');
    
    try {
      final events = await SignedEventDBISAR.getAllFromDB(userPubkey);
      AegisLogger.info('[SignedEventManager] Found ${events.length} events for current user');
      return events;
    } catch (e) {
      AegisLogger.error('[SignedEventManager] Failed to get events for user=${_maskValue(userPubkey)}', e);
      return [];
    }
  }

  Future<List<SignedEventDBISAR>> getSignedEventsByPubkey(String applicationPubkey) async {
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty) {
      AegisLogger.warning('[SignedEventManager] Skip getSignedEventsByPubkey: user not logged in');
      return [];
    }
    final userPubkey = account.currentPubkey;

    AegisLogger.debug(
      '[SignedEventManager] Getting events for applicationPubkey=${_maskValue(applicationPubkey)} '
      'user=${_maskValue(userPubkey)}',
    );
    
    try {
      final events = await SignedEventDBISAR.getByApplicationPubkey(userPubkey, applicationPubkey);
      AegisLogger.info(
        '[SignedEventManager] Found ${events.length} events for '
        'applicationPubkey=${_maskValue(applicationPubkey)}',
      );
      return events;
    } catch (e) {
      AegisLogger.error(
        '[SignedEventManager] Failed to get events for '
        'applicationPubkey=${_maskValue(applicationPubkey)}',
        e,
      );
      return [];
    }
  }

  Future<void> cleanupOnStartup() async {
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty) {
      AegisLogger.warning('[SignedEventManager] Skip cleanupOnStartup: user not logged in');
      return;
    }
    final userPubkey = account.currentPubkey;

    AegisLogger.info('[SignedEventManager] Starting startup cleanup for user=${_maskValue(userPubkey)}');
    
    try {
      final allEvents = await getAllSignedEvents();
      final applicationPubkeys = allEvents
          .where((event) => event.applicationPubkey != null && event.applicationPubkey!.isNotEmpty)
          .map((event) => event.applicationPubkey!)
          .toSet();
      
      AegisLogger.info(
        '[SignedEventManager] Found ${applicationPubkeys.length} applications for startup cleanup',
      );
      
      for (final applicationPubkey in applicationPubkeys) {
        await _cleanupOldEventsForApplication(userPubkey, applicationPubkey);
      }
      
      AegisLogger.info('[SignedEventManager] Startup cleanup completed');
    } catch (e) {
      AegisLogger.error('[SignedEventManager] Failed to cleanup on startup', e);
    }
  }

  Future<void> periodicCleanup() async {
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty) {
      AegisLogger.warning('[SignedEventManager] Skip periodicCleanup: user not logged in');
      return;
    }
    final userPubkey = account.currentPubkey;

    AegisLogger.info('[SignedEventManager] Starting periodic cleanup for user=${_maskValue(userPubkey)}');
    
    try {
      final allEvents = await getAllSignedEvents();
      final applicationPubkeys = allEvents
          .where((event) => event.applicationPubkey != null && event.applicationPubkey!.isNotEmpty)
          .map((event) => event.applicationPubkey!)
          .toSet();
      
      AegisLogger.info(
        '[SignedEventManager] Found ${applicationPubkeys.length} applications for periodic cleanup',
      );
      
      for (final applicationPubkey in applicationPubkeys) {
        await _cleanupOldEventsForApplication(userPubkey, applicationPubkey);
      }
      
      AegisLogger.info('[SignedEventManager] Periodic cleanup completed');
    } catch (e) {
      AegisLogger.error('[SignedEventManager] Failed periodic cleanup', e);
    }
  }

  String getEventKindDescription(int eventKind) {
    switch (eventKind) {
      case 0:
        return 'Delete';
      case 1:
        return 'Text Note';
      case 2:
        return 'Recommend Relay';
      case 3:
        return 'Contact List';
      case 4:
        return 'Encrypted Direct Message';
      case 5:
        return 'Event Deletion';
      case 6:
        return 'Repost';
      case 7:
        return 'Reaction';
      case 8:
        return 'Badge Award';
      case 16:
        return 'Generic Repost';
      case 40:
        return 'Channel Creation';
      case 41:
        return 'Channel Metadata';
      case 42:
        return 'Channel Message';
      case 43:
        return 'Channel Hide Message';
      case 44:
        return 'Channel Mute User';
      case 1984:
        return 'Reporting';
      case 9734:
        return 'Zap';
      case 9735:
        return 'Zap Request';
      case 10000:
        return 'Mute List';
      case 10001:
        return 'Pin List';
      case 10002:
        return 'Relay List Metadata';
      case 13194:
        return 'Wallet Info';
      case 22242:
        return 'Client Authentication';
      case 23194:
        return 'Wallet Request';
      case 23195:
        return 'Wallet Response';
      case 24133:
        return 'Nostr Connect';
      case 30000:
        return 'Categorized People List';
      case 30001:
        return 'Categorized Bookmark List';
      case 30008:
        return 'Profile Badges';
      case 30009:
        return 'Badge Definition';
      case 30017:
        return 'Create or update a stall';
      case 30018:
        return 'Create or update a product';
      case 30023:
        return 'Long-form Content';
      case 30024:
        return 'Draft Long-form Content';
      case 30030:
        return 'Classified Listing';
      case 30078:
        return 'Application-specific Data';
      case 30311:
        return 'Live Event';
      case 30315:
        return 'User Statuses';
      case 30402:
        return 'Community Post Approval';
      case 30403:
        return 'Community';
      case 30404:
        return 'Community Post';
      case 30405:
        return 'Community User';
      case 31922:
        return 'Date-based Calendar Event';
      case 31923:
        return 'Time-based Calendar Event';
      case 31924:
        return 'Calendar';
      case 31925:
        return 'Calendar Event RSVP';
      case 31990:
        return 'Handler Information';
      case 31991:
        return 'Handler Recommendation';
      case 31992:
        return 'Handler Categorization';
      case 34550:
        return 'Classified Listing';
      case 38000:
        return 'Request';
      case 38001:
        return 'Response';
      case 38002:
        return 'Tombstone';
      default:
        return 'Unknown Event Kind ($eventKind)';
    }
  }
} 