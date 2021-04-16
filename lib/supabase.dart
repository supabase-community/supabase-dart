/// A dart client for Supabase. It supports database query, authenticate users
/// and listen for realtime changes. This client makes it simple for developers
/// to build secure and scalable products.
///
library supabase;

export 'package:realtime_client/src/realtime_subscription.dart'
    show RealtimeSubscription;
export 'src/auth_user.dart';
export 'src/storage/types.dart' show FileOptions, SearchOptions, SortBy;
export 'src/supabase.dart';
export 'src/supabase_event_types.dart';
export 'src/supabase_storage_client.dart';
