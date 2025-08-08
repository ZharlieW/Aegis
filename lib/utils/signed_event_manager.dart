import 'package:aegis/db/signed_event_db_isar.dart';
import 'package:aegis/utils/account.dart';

class SignedEventManager {
  static final SignedEventManager _instance = SignedEventManager._internal();
  factory SignedEventManager() => _instance;
  SignedEventManager._internal();

  static SignedEventManager get sharedInstance => _instance;

  /// Record a signed event
  Future<void> recordSignedEvent({
    required String eventId,
    required int eventKind,
    required String eventContent,
    String? applicationName,
    String? applicationPubkey,
    int status = 1, // 1 = signed
    String? metadata,
  }) async {
    final account = Account.sharedInstance;
    final userPubkey = account.currentPubkey.isNotEmpty 
        ? account.currentPubkey 
        : 'default_user_${DateTime.now().millisecondsSinceEpoch}';
    
    print('🔍 [SignedEventManager] Recording event: $eventContent');
    print('🔍 [SignedEventManager] User pubkey: $userPubkey');
    print('🔍 [SignedEventManager] Event ID: $eventId');

    final event = SignedEventDBISAR(
      eventId: eventId,
      eventKind: eventKind,
      eventContent: eventContent,
      applicationName: applicationName,
      applicationPubkey: applicationPubkey,
      userPubkey: userPubkey,
      signedTimestamp: DateTime.now().millisecondsSinceEpoch,
      status: status,
      metadata: metadata,
    );

    try {
      await SignedEventDBISAR.saveFromDB(event);
      print('✅ [SignedEventManager] Event recorded successfully');
    } catch (e) {
      print('❌ [SignedEventManager] Failed to record event: $e');
      rethrow;
    }
  }

  /// Clean up old events for specific application, keeping only the latest 50
  Future<void> _cleanupOldEventsForApplication(String userPubkey, String applicationPubkey) async {
    try {
      final eventCount = await SignedEventDBISAR.getEventCountByApplicationPubkey(userPubkey, applicationPubkey);
      
      // Cleanup if we have more than 50 events
      if (eventCount > 50) {
        print('🧹 [SignedEventManager] Cleaning up old events for $applicationPubkey (current: $eventCount, keeping latest 50)');
        await SignedEventDBISAR.deleteOldEventsForApplication(userPubkey, applicationPubkey, keepCount: 50);
      } else {
        print('✅ [SignedEventManager] No cleanup needed for $applicationPubkey (current count: $eventCount)');
      }
    } catch (e) {
      print('❌ [SignedEventManager] Failed to cleanup old events for $applicationPubkey: $e');
    }
  }

  /// Get all signed events for current user
  Future<List<SignedEventDBISAR>> getAllSignedEvents() async {
    final account = Account.sharedInstance;
    final userPubkey = account.currentPubkey.isNotEmpty 
        ? account.currentPubkey 
        : 'default_user_${DateTime.now().millisecondsSinceEpoch}';
    
    print('🔍 [SignedEventManager] Getting events for user: $userPubkey');
    
    try {
      final events = await SignedEventDBISAR.getAllFromDB(userPubkey);
      print('✅ [SignedEventManager] Found ${events.length} events');
      return events;
    } catch (e) {
      print('❌ [SignedEventManager] Failed to get events: $e');
      return [];
    }
  }

  /// Get signed events for specific application pubkey
  Future<List<SignedEventDBISAR>> getSignedEventsByPubkey(String applicationPubkey) async {
    final account = Account.sharedInstance;
    final userPubkey = account.currentPubkey.isNotEmpty 
        ? account.currentPubkey 
        : 'default_user_${DateTime.now().millisecondsSinceEpoch}';
    
    print('🔍 [SignedEventManager] Getting events for application: $applicationPubkey');
    
    try {
      final events = await SignedEventDBISAR.getByApplicationPubkey(userPubkey, applicationPubkey);
      print('✅ [SignedEventManager] Found ${events.length} events for application: $applicationPubkey');
      return events;
    } catch (e) {
      print('❌ [SignedEventManager] Failed to get events for application: $applicationPubkey, error: $e');
      return [];
    }
  }





  /// Clean up all applications on app startup
  Future<void> cleanupOnStartup() async {
    final account = Account.sharedInstance;
    final userPubkey = account.currentPubkey.isNotEmpty 
        ? account.currentPubkey 
        : 'default_user_${DateTime.now().millisecondsSinceEpoch}';
    
    print('🚀 [SignedEventManager] Starting startup cleanup for all applications');
    
    try {
      // Get all events to find unique application pubkeys
      final allEvents = await getAllSignedEvents();
      final applicationPubkeys = allEvents
          .where((event) => event.applicationPubkey != null && event.applicationPubkey!.isNotEmpty)
          .map((event) => event.applicationPubkey!)
          .toSet();
      
      print('📊 [SignedEventManager] Found ${applicationPubkeys.length} applications for startup cleanup');
      
      // Clean up each application
      for (final applicationPubkey in applicationPubkeys) {
        await _cleanupOldEventsForApplication(userPubkey, applicationPubkey);
      }
      
      print('✅ [SignedEventManager] Startup cleanup completed for all applications');
    } catch (e) {
      print('❌ [SignedEventManager] Failed to cleanup on startup: $e');
    }
  }

  /// Periodic cleanup for all applications
  Future<void> periodicCleanup() async {
    final account = Account.sharedInstance;
    final userPubkey = account.currentPubkey.isNotEmpty 
        ? account.currentPubkey 
        : 'default_user_${DateTime.now().millisecondsSinceEpoch}';
    
    print('🔄 [SignedEventManager] Starting periodic cleanup for all applications');
    
    try {
      // Get all events to find unique application pubkeys
      final allEvents = await getAllSignedEvents();
      final applicationPubkeys = allEvents
          .where((event) => event.applicationPubkey != null && event.applicationPubkey!.isNotEmpty)
          .map((event) => event.applicationPubkey!)
          .toSet();
      
      print('📊 [SignedEventManager] Found ${applicationPubkeys.length} applications for periodic cleanup');
      
      // Clean up each application
      for (final applicationPubkey in applicationPubkeys) {
        await _cleanupOldEventsForApplication(userPubkey, applicationPubkey);
      }
      
      print('✅ [SignedEventManager] Periodic cleanup completed for all applications');
    } catch (e) {
      print('❌ [SignedEventManager] Failed to periodic cleanup: $e');
    }
  }

  /// Get event kind description
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