import 'dart:async';

import 'package:functions_client/functions_client.dart';
import 'package:gotrue/gotrue.dart';
import 'package:http/http.dart';
import 'package:postgrest/postgrest.dart';
import 'package:realtime_client/realtime_client.dart';
import 'package:storage_client/storage_client.dart';
import 'package:supabase/src/constants.dart';
import 'package:supabase/src/supabase_query_builder.dart';

class SupabaseClient {
  final String supabaseUrl;
  final String supabaseKey;
  final String schema;
  final String restUrl;
  final String realtimeUrl;
  final String authUrl;
  final String storageUrl;
  final String functionsUrl;
  final Map<String, String> _headers;
  final Client? _httpClient;

  late final GoTrueClient auth;
  late final RealtimeClient realtime;
  late final PostgrestClient rest;
  String? _changedAccessToken;
  late StreamSubscription<AuthState> _authStateSubscription;

  /// Increment ID of the stream to create different realtime topic for each stream
  int _incrementId = 0;

  SupabaseClient(
    this.supabaseUrl,
    this.supabaseKey, {
    String? schema,
    bool autoRefreshToken = true,
    Map<String, String> headers = Constants.defaultHeaders,
    Client? httpClient,
  })  : restUrl = '$supabaseUrl/rest/v1',
        realtimeUrl = '$supabaseUrl/realtime/v1'.replaceAll('http', 'ws'),
        authUrl = '$supabaseUrl/auth/v1',
        storageUrl = '$supabaseUrl/storage/v1',
        functionsUrl = RegExp(r'(supabase\.co)|(supabase\.in)')
                .hasMatch(supabaseUrl)
            ? '${supabaseUrl.split('.')[0]}.functions.${supabaseUrl.split('.')[1]}.${supabaseUrl.split('.')[2]}'
            : '$supabaseUrl/functions/v1',
        schema = schema ?? 'public',
        _headers = headers,
        _httpClient = httpClient {
    auth = _initSupabaseAuthClient(
      autoRefreshToken: autoRefreshToken,
      headers: headers,
    );
    realtime = _initRealtimeClient(headers: headers);

    _listenForAuthEvents();
  }

  /// Supabase Functions allows you to deploy and invoke edge functions.
  FunctionsClient get functions => FunctionsClient(
        functionsUrl,
        _getAuthHeaders(),
        httpClient: _httpClient,
      );

  /// Supabase Storage allows you to manage user-generated content, such as photos or videos.
  SupabaseStorageClient get storage => SupabaseStorageClient(
        storageUrl,
        _getAuthHeaders(),
        httpClient: _httpClient,
      );

  /// Perform a table operation.
  SupabaseQueryBuilder from(String table) {
    final url = '$restUrl/$table';
    _incrementId++;
    return SupabaseQueryBuilder(
      url,
      realtime,
      headers: _getAuthHeaders(),
      schema: schema,
      table: table,
      httpClient: _httpClient,
      incrementId: _incrementId,
    );
  }

  /// Perform a stored procedure call.
  PostgrestFilterBuilder rpc(String fn, {Map<String, dynamic>? params}) {
    return PostgrestClient(
      '$supabaseUrl/rest/v1',
      headers: _getAuthHeaders(),
      schema: schema,
      httpClient: _httpClient,
    ).rpc(fn, params: params);
  }

  /// Creates a Realtime channel with Broadcast, Presence, and Postgres Changes.
  RealtimeChannel channel(String name,
      {RealtimeChannelConfig opts = const RealtimeChannelConfig()}) {
    return realtime.channel(name, opts);
  }

  /// Returns all Realtime channels.
  List<RealtimeChannel> getChannels() {
    return realtime.getChannels();
  }

  /// Unsubscribes and removes Realtime channel from Realtime client.
  ///
  /// [channel] - The name of the Realtime channel.
  Future<String> removeChannel(RealtimeChannel channel) {
    return realtime.removeChannel(channel);
  }

  ///  Unsubscribes and removes all Realtime channels from Realtime client.
  Future<List<String>> removeAllChannels() {
    return realtime.removeAllChannels();
  }

  void dispose() {
    _authStateSubscription.cancel();
  }

  GoTrueClient _initSupabaseAuthClient({
    bool? autoRefreshToken,
    required Map<String, String> headers,
  }) {
    final authHeaders = {...headers};
    authHeaders['apikey'] = supabaseKey;
    authHeaders['Authorization'] = 'Bearer $supabaseKey';

    return GoTrueClient(
      url: authUrl,
      headers: authHeaders,
      autoRefreshToken: autoRefreshToken,
      httpClient: _httpClient,
    );
  }

  RealtimeClient _initRealtimeClient({
    required Map<String, String> headers,
  }) {
    return RealtimeClient(
      realtimeUrl,
      params: {'apikey': supabaseKey},
      headers: headers,
    );
  }

  Map<String, String> _getAuthHeaders() {
    final authBearer = auth.currentSession?.accessToken ?? supabaseKey;
    final defaultHeaders = {
      'apikey': supabaseKey,
      'Authorization': 'Bearer $authBearer',
    };
    final headers = {...defaultHeaders, ..._headers};
    return headers;
  }

  void _listenForAuthEvents() {
    _authStateSubscription = auth.onAuthStateChange.listen((data) {
      _handleTokenChanged(data.event, data.session?.accessToken);
    });
  }

  void _handleTokenChanged(AuthChangeEvent event, String? token) {
    if (event == AuthChangeEvent.tokenRefreshed ||
        event == AuthChangeEvent.signedIn && _changedAccessToken != token) {
      // Token has changed
      _changedAccessToken = token;
      realtime.setAuth(token);
    } else if (event == AuthChangeEvent.signedOut ||
        event == AuthChangeEvent.userDeleted) {
      // Token is removed
      realtime.setAuth(supabaseKey);
    }
  }
}
