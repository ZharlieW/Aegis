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

  /// Get recent signed events for current user
  Future<List<SignedEventDBISAR>> getRecentSignedEvents({int limit = 50}) async {
    final account = Account.sharedInstance;
    final userPubkey = account.currentPubkey.isNotEmpty 
        ? account.currentPubkey 
        : 'default_user_${DateTime.now().millisecondsSinceEpoch}';

    return await SignedEventDBISAR.getRecentFromDB(userPubkey, limit: limit);
  }

  /// Search signed events by content
  Future<List<SignedEventDBISAR>> searchSignedEvents(String query) async {
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty) return [];

    final allEvents = await getAllSignedEvents();
    return allEvents.where((event) {
      return event.eventContent.toLowerCase().contains(query.toLowerCase()) ||
             (event.applicationName?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  /// Clear all signed events for current user
  Future<void> clearAllSignedEvents() async {
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty) return;

    await SignedEventDBISAR.clearAllFromDB(account.currentPubkey);
  }

  /// Delete a specific signed event
  Future<void> deleteSignedEvent(String eventId) async {
    final account = Account.sharedInstance;
    if (account.currentPubkey.isEmpty) return;

    await SignedEventDBISAR.deleteFromDB(account.currentPubkey, eventId);
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
      case 39000:
        return 'Regular Expression';
      case 39001:
        return 'Regular Expression Alternative';
      case 39002:
        return 'Regular Expression Replacement';
      case 39003:
        return 'Regular Expression Like';
      case 39004:
        return 'Regular Expression Match';
      case 39005:
        return 'Regular Expression Flag';
      case 39006:
        return 'Regular Expression Split';
      case 39007:
        return 'Regular Expression Replace';
      case 39008:
        return 'Regular Expression Test';
      case 39009:
        return 'Regular Expression Exec';
      case 39010:
        return 'Regular Expression Search';
      case 39011:
        return 'Regular Expression Match All';
      case 39012:
        return 'Regular Expression Replace All';
      case 39013:
        return 'Regular Expression Split All';
      case 39014:
        return 'Regular Expression Test All';
      case 39015:
        return 'Regular Expression Exec All';
      case 39016:
        return 'Regular Expression Search All';
      case 39017:
        return 'Regular Expression Match All Global';
      case 39018:
        return 'Regular Expression Replace All Global';
      case 39019:
        return 'Regular Expression Split All Global';
      case 39020:
        return 'Regular Expression Test All Global';
      case 39021:
        return 'Regular Expression Exec All Global';
      case 39022:
        return 'Regular Expression Search All Global';
      case 39023:
        return 'Regular Expression Match All Sticky';
      case 39024:
        return 'Regular Expression Replace All Sticky';
      case 39025:
        return 'Regular Expression Split All Sticky';
      case 39026:
        return 'Regular Expression Test All Sticky';
      case 39027:
        return 'Regular Expression Exec All Sticky';
      case 39028:
        return 'Regular Expression Search All Sticky';
      case 39029:
        return 'Regular Expression Match All Unicode';
      case 39030:
        return 'Regular Expression Replace All Unicode';
      case 39031:
        return 'Regular Expression Split All Unicode';
      case 39032:
        return 'Regular Expression Test All Unicode';
      case 39033:
        return 'Regular Expression Exec All Unicode';
      case 39034:
        return 'Regular Expression Search All Unicode';
      case 39035:
        return 'Regular Expression Match All Unicode Global';
      case 39036:
        return 'Regular Expression Replace All Unicode Global';
      case 39037:
        return 'Regular Expression Split All Unicode Global';
      case 39038:
        return 'Regular Expression Test All Unicode Global';
      case 39039:
        return 'Regular Expression Exec All Unicode Global';
      case 39040:
        return 'Regular Expression Search All Unicode Global';
      case 39041:
        return 'Regular Expression Match All Unicode Sticky';
      case 39042:
        return 'Regular Expression Replace All Unicode Sticky';
      case 39043:
        return 'Regular Expression Split All Unicode Sticky';
      case 39044:
        return 'Regular Expression Test All Unicode Sticky';
      case 39045:
        return 'Regular Expression Exec All Unicode Sticky';
      case 39046:
        return 'Regular Expression Search All Unicode Sticky';
      case 39047:
        return 'Regular Expression Match All Unicode Global Sticky';
      case 39048:
        return 'Regular Expression Replace All Unicode Global Sticky';
      case 39049:
        return 'Regular Expression Split All Unicode Global Sticky';
      case 39050:
        return 'Regular Expression Test All Unicode Global Sticky';
      case 39051:
        return 'Regular Expression Exec All Unicode Global Sticky';
      case 39052:
        return 'Regular Expression Search All Unicode Global Sticky';
      case 39053:
        return 'Regular Expression Match All Unicode Global Sticky Unicode';
      case 39054:
        return 'Regular Expression Replace All Unicode Global Sticky Unicode';
      case 39055:
        return 'Regular Expression Split All Unicode Global Sticky Unicode';
      case 39056:
        return 'Regular Expression Test All Unicode Global Sticky Unicode';
      case 39057:
        return 'Regular Expression Exec All Unicode Global Sticky Unicode';
      case 39058:
        return 'Regular Expression Search All Unicode Global Sticky Unicode';
      case 39059:
        return 'Regular Expression Match All Unicode Global Sticky Unicode Global';
      case 39060:
        return 'Regular Expression Replace All Unicode Global Sticky Unicode Global';
      case 39061:
        return 'Regular Expression Split All Unicode Global Sticky Unicode Global';
      case 39062:
        return 'Regular Expression Test All Unicode Global Sticky Unicode Global';
      case 39063:
        return 'Regular Expression Exec All Unicode Global Sticky Unicode Global';
      case 39064:
        return 'Regular Expression Search All Unicode Global Sticky Unicode Global';
      case 39065:
        return 'Regular Expression Match All Unicode Global Sticky Unicode Global Sticky';
      case 39066:
        return 'Regular Expression Replace All Unicode Global Sticky Unicode Global Sticky';
      case 39067:
        return 'Regular Expression Split All Unicode Global Sticky Unicode Global Sticky';
      case 39068:
        return 'Regular Expression Test All Unicode Global Sticky Unicode Global Sticky';
      case 39069:
        return 'Regular Expression Exec All Unicode Global Sticky Unicode Global Sticky';
      case 39070:
        return 'Regular Expression Search All Unicode Global Sticky Unicode Global Sticky';
      case 39071:
        return 'Regular Expression Match All Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39072:
        return 'Regular Expression Replace All Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39073:
        return 'Regular Expression Split All Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39074:
        return 'Regular Expression Test All Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39075:
        return 'Regular Expression Exec All Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39076:
        return 'Regular Expression Search All Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39077:
        return 'Regular Expression Match All Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39078:
        return 'Regular Expression Replace All Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39079:
        return 'Regular Expression Split All Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39080:
        return 'Regular Expression Test All Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39081:
        return 'Regular Expression Exec All Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39082:
        return 'Regular Expression Search All Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39083:
        return 'Regular Expression Match All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky';
      case 39084:
        return 'Regular Expression Replace All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky';
      case 39085:
        return 'Regular Expression Split All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky';
      case 39086:
        return 'Regular Expression Test All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky';
      case 39087:
        return 'Regular Expression Exec All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky';
      case 39088:
        return 'Regular Expression Search All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky';
      case 39089:
        return 'Regular Expression Match All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39090:
        return 'Regular Expression Replace All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39091:
        return 'Regular Expression Split All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39092:
        return 'Regular Expression Test All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39093:
        return 'Regular Expression Exec All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39094:
        return 'Regular Expression Search All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode';
      case 39095:
        return 'Regular Expression Match All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39096:
        return 'Regular Expression Replace All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39097:
        return 'Regular Expression Split All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39098:
        return 'Regular Expression Test All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39099:
        return 'Regular Expression Exec All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode Global';
      case 39100:
        return 'Regular Expression Search All Unicode Global Sticky Unicode Global Sticky Unicode Global Sticky Unicode Global';
      default:
        return 'Unknown Event Kind ($eventKind)';
    }
  }
} 