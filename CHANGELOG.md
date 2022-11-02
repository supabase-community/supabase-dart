## [1.1.0]

- fix: stream filter other than eq is not properly applied. [(#156)](https://github.com/supabase-community/supabase-dart/pull/156)
- fix: update examples [(#157)](https://github.com/supabase-community/supabase-dart/pull/157)
- feat: update gotrue to v1.1.1
  - fail to getSessionFromUrl throws error on `onAuthStateChange`
    ```dart
    supabase.onAuthStateChange.listen((data) {
      // handle auth state change here
    }, onError: (error) {
      // handle error here
    });
    ```
- feat: update postgrest to v1.1.0
  - feat: add generic types to `.select()`
    ```dart
    // data is `List<Map<String, dynamic>>`
    final data = await supabase.from<List<Map<String, dynamic>>>('users').select();

    // data is `Map<String, dynamic>`
    final data = await supabase.from<Map<String, dynamic>>('users').select().eq('id', myId).single();
    ```


## [1.0.1]

- fix: update sample code on readme.md

## [1.0.0]

- chore: v1.0.0 release 🚀
- BREAKING: set minimum SDK of Dart at 2.15.0 [(#150)](https://github.com/supabase-community/supabase-dart/pull/150)
- BREAKING: `.stream()` now takes a named parameter `primaryKey` instead of a positional argument. 
  ```dart
  supabase.from('my_table').stream(primaryKey: ['id']);
  ```
- feat: `.stream()` has 5 additional filters: `neq`, `gt`, `gte`, `lt`, `lte` [(#148)](https://github.com/supabase-community/supabase-dart/pull/148)
- chore: update postgrest to v1.0.0
- chore: update realtime to v1.0.0
- chore: update storage to v1.0.0
- chore: update functions to v1.0.0
- BREAKING: update gotrue to v1.0.0
  - `signUp()` now uses named parameters
  ```dart
    // Before
    final res = await supabase.auth.signUp('example@email.com', 'password');
    // After
    final res = await supabase.auth.signUp(email: 'example@email.com', password: 'password');
  ```
  - `signIn()` is split into different methods
  ```dart
    // Magic link signin
    // Before
    final res = await supabase.auth.signIn(email: 'example@email.com');
    // After
    final res = await supabase.auth.signInWithOtp(email: 'example@email.com');

    // Email and password signin
    // Before
    final res = await supabase.auth.signIn(email: 'example@email.com', password: 'password');
    // After
    final res = await supabase.auth.signInWithPassword(email: 'example@email.com', password: 'password');
  ``` 
  - `onAuthStateChange` is now a stream
  ```dart
    // Before
    supabase.auth.onAuthStateChange((event, session) {
      // ...
    });
    // After
    final subscription = supabase.auth.onAuthStateChange().listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
    });
    // Don't forget to cancel the subscription when you're done
    subscription.cancel();
  ```
  - `update()` is renamed to `updateUser()`
  ```dart
    // Before
    final res = await supabase.auth.update(
        UserAttributes(
          email: 'new@email.com',
          data: {
            'username': 'new_username',
          },
        ),
    );
    // After
    final res = await supabase.auth.updateUser(
        UserAttributes(
          email: 'new@email.com',
          data: {
            'username': 'new_username',
          },
        ),
    );
  ```

## [1.0.0-dev.9]

- fix: update realtime to [v1.0.0-dev.5](https://github.com/supabase-community/realtime-dart/blob/main/CHANGELOG.md#100-dev5)
  - fix: sends null for access_token when not signed in [(#53)](https://github.com/supabase-community/realtime-dart/pull/53)

## [1.0.0-dev.8]

- fix: recreate a `PostgrestClient` with proper auth headers when calling `.rpc()` [(#143)](https://github.com/supabase-community/supabase-dart/pull/143)
- fix: allow custom headers to be set for `SupabaseClient` [(#144)](https://github.com/supabase-community/supabase-dart/pull/144)
- fix: stream error will emit the entire exception and the stack trace [(#145)](https://github.com/supabase-community/supabase-dart/pull/145)
- fix: update realtime to [v1.0.0-dev.4](https://github.com/supabase-community/realtime-dart/blob/main/CHANGELOG.md#100-dev4)
  - fix: bug where it throws exception when listening to postgres changes on old version of realtime server

## [1.0.0-dev.7]

- BREAKING: update relatime to [v1.0.0-dev.3](https://github.com/supabase-community/realtime-dart/blob/main/CHANGELOG.md#100-dev3)
  - update payload shape on old version of realtime server to match the new version
- fix: update gotrue to [v1.0.0-dev.4](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#100-dev4)
  - fix: encoding issue with some languages
- fix: update postgrest to [v1.0.0-dev.4](https://github.com/supabase-community/postgrest-dart/blob/master/CHANGELOG.md#100-dev4)
  - fix: update insert documentation to reflect new `returning` behavior

## [1.0.0-dev.6]

- fix: `.stream()` method typing issue

## [1.0.0-dev.5]

- BREAKING: update realtime to [v1.0.0-dev.2](https://github.com/supabase-community/realtime-dart/blob/main/CHANGELOG.md#100-dev2)
- deprecated: `.execute()` and `.stream()` can be used without it
- BREAKING: filters on `.stream()` no longer takes the realtime syntax. `.eq()` method should be used to apply `eq` filter on `.stream()`. 
```dart
// before
supabase.from('my_table:title=eq.Supabase')
  .stream(['id'])
  .order('created_at')
  .limit(10)
  .execute()
  .listen((payload) {
    // do something with payload here
  });

// now
supabase.from('my_table')
  .stream(['id'])
  .eq('title', 'Supabase')
  .order('created_at')
  .limit(10)
  .listen((payload) {
    // do something with payload here
  });
```

## [1.0.0-dev.4]

- fix: update storage to [v1.0.0-dev.3](https://github.com/supabase-community/storage-dart/blob/main/CHANGELOG.md#100-dev3)
- fix: add `web_socket_channel` to dev dependencies since it is used in tests
- fix: add basic `postgrest` test
- BREAKING: update gotrue to [v1.0.0-dev.3](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#100-dev3)

## [1.0.0-dev.3]

- fix: export storage types
- BREAKING: update postgrest to [v1.0.0-dev.2](https://github.com/supabase-community/postgrest-dart/blob/master/CHANGELOG.md#100-dev2)
- BREAKING: update gotrue to [v1.0.0-dev.2](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#100-dev2)
- feat: update storage to [v1.0.0-dev.2](https://github.com/supabase-community/storage-dart/blob/main/CHANGELOG.md#100-dev2)

## [1.0.0-dev.2]

- feat: custom http client

## [1.0.0-dev.1]

- BREAKING: update postgrest to [v1.0.0-dev.1](https://github.com/supabase-community/postgrest-dart/blob/master/CHANGELOG.md#100-dev1)
- BREAKING: update gotrue to [v1.0.0-dev.1](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#100-dev1)
- BREAKING: update storage to [v1.0.0-dev.1](https://github.com/supabase-community/storage-dart/blob/main/CHANGELOG.md#100-dev1)
- BREAKING: update functions to [v1.0.0-dev.1](https://github.com/supabase-community/functions-dart/blob/main/CHANGELOG.md#100-dev1)

## [0.3.6]

- fix: Calling postgrest endpoints within realtime callback throws exception
- feat: update gotrue to [v0.2.3](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#023)

## [0.3.5]

- fix: update gotrue to [v0.2.2+1](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#0221)
- feat: update postgrest to [v0.1.11](https://github.com/supabase-community/postgrest-dart/blob/master/CHANGELOG.md#0111)
- fix: flaky test on stream()

## [0.3.4+1]

- fix: export type, `SupabaseRealtimePayload`

## [0.3.4]

- fix: update gotrue to [v0.2.2](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#022)

## [0.3.3]

- feat: update gotrue to[v0.2.1](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#021)
- fix: update postgrest to[0.1.10+1](https://github.com/supabase-community/postgrest-dart/blob/master/CHANGELOG.md#01101)

## [0.3.2]

- feat: update postgrest to [v0.1.10](https://github.com/supabase-community/postgrest-dart/blob/master/CHANGELOG.md#0110)
- fix: update functions_client to [v0.0.1-dev.4](https://github.com/supabase-community/functions-dart/blob/main/CHANGELOG.md#001-dev4)

## [0.3.1+1]

- feat: exporting classes of functions_client

## [0.3.1]

- feat: add functions support

## [0.3.0]

- BREAKING: update gotrue_client to [v0.2.0](https://github.com/supabase-community/gotrue-dart/blob/main/CHANGELOG.md#020)

## [0.2.15]

- chore: update gotrue_client to v0.1.6

## [0.2.14]

- chore: update gotrue_client to v0.1.5
- chore: update postgrest to v0.1.9
- chore: update realtime_client to v0.1.15
- chore: update storage_client to v0.0.6+2

## [0.2.13]

- chore: update realtime_client to v0.1.14

## [0.2.12]

- fix: changedAccessToken never initialized error when changing account
- fix: stream replaces the correct row

## [0.2.11]

- feat: listen for auth event and handle token changed
- chore: update gotrue to v0.1.3
- chore: update realtime_client to v0.1.13
- fix: use PostgrestFilterBuilder type for rpc
- docs: correct stream method documentation

## [0.2.10]

- fix: type 'Null' is not a subtype of type 'List<dynamic>' in type cast

## [0.2.9]

- feat: add user_token when creating realtime channel subscription
- fix: typo on Realtime data as Stream on readme.md

## [0.2.8]

- chore: update gotrue to v0.1.2
- chore: update storage_client to v0.0.6
- fix: cleanup imports in `supabase_stream_builder` to remove analysis error

## [0.2.7]

- chore: update postgrest to v0.1.8

## [0.2.6]

- chore: add `X-Client-Info` header
- chore: update gotrue to v0.1.1
- chore: update postgrest to v0.1.7
- chore: update realtime_client to v0.1.11
- chore: update storage_client to v0.0.5

## [0.2.5]

- chore: update realtime_client to v0.1.10

## [0.2.4]

- chore: update postgrest to v0.1.6

## [0.2.3]

- chore: update realtime_client to v0.1.9

## [0.2.2]

- fix: bug where `stream()` tries to emit data when `StreamController` is closed

## [0.2.1]

- chore: update realtime_client to v0.1.8

## [0.2.0]

- feat: added `stream()` method to listen to realtime updates as stream

## [0.1.0]

- chore: update gotrue to v0.1.0
- feat: add phone auth

## [0.0.8]

- chore: update postgrest to v0.1.5
- chore: update storage_client to v0.0.4

## [0.0.7]

- chore: update realtime_client to v0.1.7

## [0.0.6]

- chore: update realtime_client to v0.1.6

## [0.0.5]

- chore: update realtime_client to v0.1.5

## [0.0.4]

- chore: update realtime_client to v0.1.4

## [0.0.3]

- chore: update storage_client to v0.0.3

## [0.0.2]

- chore: update gotrue to v0.0.7
- chore: update postgrest to v0.1.4
- chore: update storage_client to v0.0.2

## [0.0.1]

- chore: update storage_client to v0.0.1
- Initial Release

## [0.0.1-dev.27]

- chore: update realtime to v0.1.3

## [0.0.1-dev.26]

- chore: update gotrue to v0.0.6

## [0.0.1-dev.25]

- chore: update realtime to v0.1.2

## [0.0.1-dev.24]

- fix: export postgrest classes

## [0.0.1-dev.23]

- chore: update realtime to v0.1.1

## [0.0.1-dev.22]

- chore: update gotrue to v0.0.5

## [0.0.1-dev.21]

- chore: update realtime to v0.1.0

## [0.0.1-dev.20]

- chore: update gotrue to v0.0.4

## [0.0.1-dev.19]

- chore: update gotrue to v0.0.3

## [0.0.1-dev.18]

- chore: update gotrue to v0.0.2
- chore: update postgrest to v0.1.3
- chore: update storage_client to v0.0.1-dev.3

## [0.0.1-dev.17]

- chore: update realtime to v0.0.9
- chore: update postgrest to v0.1.2

## [0.0.1-dev.16]

- chore: update storage_client to v0.0.1-dev.2
- chore: update gotrue to v0.0.1

## [0.0.1-dev.15]

- chore: update postgrest to v0.1.1
- chore: update gotrue to v0.0.1-dev.11

## [0.0.1-dev.14]

- refactor: use storage_client package v0.0.1-dev.1

## [0.0.1-dev.13]

- fix: package dependencies

## [0.0.1-dev.12]

- feat: implement Storage API
- chore: update postgrest to v0.1.0
- chore: update gotrue to v0.0.1-dev.10

## [0.0.1-dev.11]

- fix: aligned exports with supabase-js

## [0.0.1-dev.10]

- chore: migrate to null-safety

## [0.0.1-dev.9]

- fix: rpc to return PostgrestTransformBuilder
- chore: update postgrest to v0.0.7
- chore: expose gotrue User as AuthUser
- chore: expose 'RealtimeSubscription'
- chore: update lib description

## [0.0.1-dev.8]

- fix: rpc method missing param name

## [0.0.1-dev.8]

- chore: update postgrest ^0.0.6

## [0.0.1-dev.6]

- chore: update gotrue v0.0.1-dev.7
- chore: update realtime_client v0.0.7

## [0.0.1-dev.5]

- refactor: SupabaseRealtimePayload variable names

## [0.0.1-dev.4]

- fix: export SupabaseEventTypes
- chore: include realtime supscription code in example

## [0.0.1-dev.3]

- fix: SupabaseRealtimeClient client and payload parsing bug
- update: realtime_client to v0.0.5

## [0.0.1-dev.2]

- fix: builder method not injecting table in the url

## [0.0.1-dev.1]

- Initial pre-release.
