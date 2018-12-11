import 'package:meta/meta.dart';
import 'helpers.dart';
import 'kuzzle.dart';

class GeoPositionPoint {
  GeoPositionPoint({
    @required this.lon,
    @required this.lat,
    @required this.name,
  });
  GeoPositionPoint.fromMap(Map<String, dynamic> map)
      : lon = map['lon'],
        lat = map['lat'],
        name = map['name'];

  final double lon;
  final double lat;
  final String name;

  Map<String, dynamic> toMap() => {
        'lon': lon,
        'lat': lat,
        'name': name,
      };
}

class MemoryStorage extends KuzzleObject {
  MemoryStorage(Kuzzle kuzzle) : super(null, kuzzle);
  static const String controller = 'ms';

  @override
  String getController() => controller;

  Future<int> append(String key, String value, {bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> bitcount(String key,
          {bool queuable = true, int start, int end}) =>
      addNetworkQuery(
        'bitcount',
        body: {},
        optionalParams: {
          '_id': key,
          'start': start,
          'end': end,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> bitop(
          String destinationKey, String operation, List<String> sourceKeys,
          {bool queuable = true}) =>
      addNetworkQuery(
        'bitop',
        body: {
          'operation': operation,
          'keys': sourceKeys,
        },
        optionalParams: {
          '_id': destinationKey,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> bitpos(String key,
          {int bit = 1, int start, int end, bool queuable = true}) =>
      addNetworkQuery(
        'bitpos',
        body: {},
        optionalParams: {
          '_id': key,
          'bit': bit,
          'start': start,
          'end': end,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> dbsize({bool queuable = true}) => addNetworkQuery(
        'dbsize',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> decr(String key, {bool queuable = true}) => addNetworkQuery(
        'decr',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> decrby(String key, int value, {bool queuable = true}) =>
      addNetworkQuery(
        'decrby',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> del(List<String> keys, {bool queuable = true}) => addNetworkQuery(
        'del',
        body: {
          'keys': keys,
        },
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> exists(List<String> keys, {bool queuable = true}) =>
      addNetworkQuery(
        'exists',
        body: {},
        optionalParams: {
          'keys': keys,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> expire(String key, int seconds, {bool queuable = true}) =>
      addNetworkQuery(
        'expire',
        body: {
          'seconds': seconds,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> expireat(String key, int timestamp, {bool queuable = true}) =>
      addNetworkQuery(
        'expireat',
        body: {
          'timestamp': timestamp,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<String> flushdb({bool queuable = true}) => addNetworkQuery(
        'flushdb',
        body: {},
        optionalParams: {},
        queuable: queuable,
      ).then((response) => response.result as String);

  Future<int> geoadd(String key, List<GeoPositionPoint> points,
          {bool queuable = true}) =>
      addNetworkQuery(
        'geoadd',
        body: {'points': points.map((point) => point.toMap()).toList()},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<double> geodist(String key, String member1, String member2,
          {String unit = 'm', bool queuable = true}) =>
      addNetworkQuery(
        'geodist',
        body: {},
        optionalParams: {
          '_id': key,
          'member1': member1,
          'member2': member2,
          'unit': unit,
        },
        queuable: queuable,
      ).then((response) => double.parse(response.result));

  Future<List<String>> geohash(String key, List<String> members,
          {bool queuable = true}) =>
      addNetworkQuery(
        'geohash',
        body: {},
        optionalParams: {
          '_id': key,
          'members': members,
        },
        queuable: queuable,
      ).then((response) =>
          response.result.map<String>((hash) => hash as String).toList());

  Future<List<GeoPositionPoint>> geopos(String key, List<String> members,
          {bool queuable = true}) =>
      addNetworkQuery(
        'geopos',
        body: {},
        optionalParams: {
          '_id': key,
          'members': members,
        },
        queuable: queuable,
      ).then((response) => response.result
          .map<GeoPositionPoint>((point) => GeoPositionPoint(
                name: members[0],
                lon: double.parse(point[0]),
                lat: double.parse(point[1]),
              ))
          .toList());

  Future<List<int>> georadius(
    String key,
    double lon,
    double lat,
    double distance, {
    String unit = 'm',
    List<String> options,
    bool queuable = true,
  }) =>
      addNetworkQuery(
        'georadius',
        body: {},
        optionalParams: {
          '_id': key,
          'lon': lon,
          'lat': lat,
          'distance': distance,
          'unit': unit,
          'options': options == null ? [] : options,
        },
        queuable: queuable,
      ).then((response) =>
          response.result.map<int>((hash) => hash as int).toList());

  Future<List<String>> georadiusbymember(
    String key,
    String member,
    double distance, {
    String unit = 'm',
    List<String> options,
    bool queuable = true,
  }) =>
      addNetworkQuery(
        'georadiusbymember',
        body: {},
        optionalParams: {
          '_id': key,
          'member': member,
          'distance': distance,
          'unit': unit,
          'options': options == null ? [] : options,
        },
        queuable: queuable,
      ).then((response) =>
          response.result.map<String>((hash) => hash as String).toList());

  /// Returns the value of a key, or null if the key doesn't exist.
  Future<String> get(String key, {bool queuable = true}) => addNetworkQuery(
        'get',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the bit value at offset, in the string value stored in a key.
  Future<int> getbit(String key, int offset, {bool queuable = true}) =>
      addNetworkQuery(
        'getbit',
        body: {},
        optionalParams: {
          '_id': key,
          'offset': offset,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns a substring of a key's value.
  Future<String> getrange(String key, int start, int end,
          {bool queuable = true}) =>
      addNetworkQuery(
        'getrange',
        body: {},
        optionalParams: {
          '_id': key,
          'start': start,
          'end': end,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets a new value for a key and returns the previous stored value.
  Future<String> getset(String key, String value, {bool queuable = true}) =>
      addNetworkQuery(
        'getset',
        body: {
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Removes fields from a hash.
  ///
  /// returns number of removed fields
  Future<int> hdel(String key, List<String> fields, {bool queuable = true}) =>
      addNetworkQuery(
        'hdel',
        body: {
          'fields': fields,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Checks if a field exists in a hash.
  Future<int> hexists(String key, String field, {bool queuable = true}) =>
      addNetworkQuery(
        'hexists',
        body: {},
        optionalParams: {
          '_id': key,
          'field': field,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the field's value of a hash.
  Future<dynamic> hget(String key, String field, {bool queuable = true}) =>
      addNetworkQuery(
        'hget',
        body: {},
        optionalParams: {
          '_id': key,
          'field': field,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns all fields and values of a hash.
  Future<Map<String, dynamic>> hgetall(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'hgetall',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Increments the number stored in a hash field
  /// by the provided integer value.
  Future<int> hincrby(String key, String field,
          {int value = 1, bool queuable = true}) =>
      addNetworkQuery(
        'hincrby',
        body: {
          'field': field,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Increments the number stored in a hash field
  /// by the provided float value.
  Future<String> hincrbyfloat(String key, String field,
          {double value = 1.0, bool queuable = true}) =>
      addNetworkQuery(
        'hincrbyfloat',
        body: {
          'field': field,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  // Returns all field names contained in a hash.
  Future<List<String>> hkeys(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'hkeys',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) =>
          response.result.map<String>((key) => key as String).toList());

  /// Returns the number of fields contained in a hash.
  Future<int> hlen(String key, {bool queuable = true}) => addNetworkQuery(
        'hlen',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the values of the specified hash's fields.
  Future<List<dynamic>> hmget(String key, List<String> fields,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hmget',
        body: {},
        optionalParams: {
          '_id': key,
          'fields': fields,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets multiple fields at once in a hash.
  ///
  /// returns OK
  Future<String> hmset(String key, Map<String, dynamic> entries,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hmset',
        body: {
          'entries': entries.keys
              .map((key) => {
                    'field': key,
                    'value': entries[key],
                  })
              .toList(),
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Identical to [scan], except that hscan
  /// iterates the fields contained in a hash.
  Future<List<dynamic>> hscan(
          String key, String cursor, String match, String count,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hscan',
        body: {},
        optionalParams: {
          '_id': key,
          'cursor': cursor,
          'match': match,
          'count': count,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets a field and its value in a hash.
  ///
  /// If the key does not exist, a new key holding a hash is created.
  /// If the field already exists, its value is overwritten.
  Future<int> hset(String key, String field, dynamic value,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hset',
        body: {
          'field': field,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Sets a field and its value in a hash,
  /// only if the field does not already exist.
  Future<int> hsetnx(String key, String field, String value,
          {bool queuable = true}) =>
      addNetworkQuery(
        'hsetnx',
        body: {
          'field': field,
          'value': value,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns the string length of a field's value in a hash.
  Future<int> hstrlen(String key, String field, {bool queuable = true}) =>
      addNetworkQuery(
        'hstrlen',
        body: {},
        optionalParams: {
          'field': field,
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  /// Returns all values contained in a hash.
  Future<List<dynamic>> hvals(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'hvals',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);

  Future<int> incr(String key, {bool queuable = true}) => addNetworkQuery(
        'incr',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> incrby(String key, {bool queuable = true}) => addNetworkQuery(
        'incrby',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> incrbyfloat(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'append',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> keys(String key, {bool queuable = true}) => addNetworkQuery(
        'keys',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lindex(String key, {bool queuable = true}) => addNetworkQuery(
        'lindex',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> linsert(String key, {bool queuable = true}) => addNetworkQuery(
        'linsert',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> llen(String key, {bool queuable = true}) => addNetworkQuery(
        'llen',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lpop(String key, {bool queuable = true}) => addNetworkQuery(
        'lpop',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lpush(String key, {bool queuable = true}) => addNetworkQuery(
        'lpush',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lpushx(String key, {bool queuable = true}) => addNetworkQuery(
        'lpushx',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lrange(String key, {bool queuable = true}) => addNetworkQuery(
        'lrange',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lrem(String key, {bool queuable = true}) => addNetworkQuery(
        'lrem',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> lset(String key, {bool queuable = true}) => addNetworkQuery(
        'lset',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> ltrim(String key, {bool queuable = true}) => addNetworkQuery(
        'ltrim',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> mget(String key, {bool queuable = true}) => addNetworkQuery(
        'mget',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> mset(String key, {bool queuable = true}) => addNetworkQuery(
        'mset',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> msetnx(String key, {bool queuable = true}) => addNetworkQuery(
        'msetnx',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> object(String key, {bool queuable = true}) => addNetworkQuery(
        'object',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> persist(String key, {bool queuable = true}) => addNetworkQuery(
        'persist',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pexpire(String key, {bool queuable = true}) => addNetworkQuery(
        'pexpire',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pexpireat(String key, {bool queuable = true}) => addNetworkQuery(
        'pexpireat',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pfadd(String key, {bool queuable = true}) => addNetworkQuery(
        'pfadd',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pfcount(String key, {bool queuable = true}) => addNetworkQuery(
        'pfcount',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pfmerge(String key, {bool queuable = true}) => addNetworkQuery(
        'pfmerge',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> ping(String key, {bool queuable = true}) => addNetworkQuery(
        'ping',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> psetex(String key, {bool queuable = true}) => addNetworkQuery(
        'psetex',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> pttl(String key, {bool queuable = true}) => addNetworkQuery(
        'pttl',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> randomkey(String key, {bool queuable = true}) => addNetworkQuery(
        'append',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rename(String key, {bool queuable = true}) => addNetworkQuery(
        'rename',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> renamenx(String key, {bool queuable = true}) => addNetworkQuery(
        'renamenx',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rpop(String key, {bool queuable = true}) => addNetworkQuery(
        'rpop',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rpoplpush(String key, {bool queuable = true}) => addNetworkQuery(
        'rpoplpush',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rpush(String key, {bool queuable = true}) => addNetworkQuery(
        'rpush',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> rpushx(String key, {bool queuable = true}) => addNetworkQuery(
        'rpushx',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sadd(String key, {bool queuable = true}) => addNetworkQuery(
        'sadd',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> scan(String key, {bool queuable = true}) => addNetworkQuery(
        'scan',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> scard(String key, {bool queuable = true}) => addNetworkQuery(
        'scard',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sdiff(String key, {bool queuable = true}) => addNetworkQuery(
        'sdiff',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sdiffstore(String key, {bool queuable = true}) => addNetworkQuery(
        'sdiffstore',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<String> set(String key, String value,
          {int ex, int px, bool nx, bool xx, bool queuable = true}) =>
      addNetworkQuery(
        'set',
        body: {
          'value': value,
          // 'ex': ex,
          // 'px': px,
          // 'nx': nx,
          // 'xx': xx,
        },
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> setex(String key, {bool queuable = true}) => addNetworkQuery(
        'setex',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> setnx(String key, {bool queuable = true}) => addNetworkQuery(
        'setnx',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sinter(String key, {bool queuable = true}) => addNetworkQuery(
        'sinter',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sinterstore(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'sinterstore',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sismember(String key, {bool queuable = true}) => addNetworkQuery(
        'sismember',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> smembers(String key, {bool queuable = true}) => addNetworkQuery(
        'smembers',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> smove(String key, {bool queuable = true}) => addNetworkQuery(
        'smove',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sort(String key, {bool queuable = true}) => addNetworkQuery(
        'sort',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> spop(String key, {bool queuable = true}) => addNetworkQuery(
        'spop',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> srandmember(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'srandmember',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> srem(String key, {bool queuable = true}) => addNetworkQuery(
        'srem',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sscan(String key, {bool queuable = true}) => addNetworkQuery(
        'sscan',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> strlen(String key, {bool queuable = true}) => addNetworkQuery(
        'strlen',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sunion(String key, {bool queuable = true}) => addNetworkQuery(
        'sunion',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> sunionstore(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'sunionstore',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> time(String key, {bool queuable = true}) => addNetworkQuery(
        'time',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> touch(String key, {bool queuable = true}) => addNetworkQuery(
        'touch',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> ttl(String key, {bool queuable = true}) => addNetworkQuery(
        'ttl',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> type(String key, {bool queuable = true}) => addNetworkQuery(
        'type',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zadd(String key, {bool queuable = true}) => addNetworkQuery(
        'zadd',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zcard(String key, {bool queuable = true}) => addNetworkQuery(
        'zcard',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zcount(String key, {bool queuable = true}) => addNetworkQuery(
        'zcount',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zincrby(String key, {bool queuable = true}) => addNetworkQuery(
        'zincrby',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zinterstore(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'zinterstore',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zlexcount(String key, {bool queuable = true}) => addNetworkQuery(
        'zlexcount',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrange(String key, {bool queuable = true}) => addNetworkQuery(
        'zrange',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrangebylex(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'zrangebylex',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrangebyscore(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'zrangebyscore',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrank(String key, {bool queuable = true}) => addNetworkQuery(
        'zrank',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrem(String key, {bool queuable = true}) => addNetworkQuery(
        'zrem',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zremrangebylex(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'zremrangebylex',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zremrangebyrank(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'zremrangebyrank',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zremrangebyscore(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'zremrangebyscore',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrevrange(String key, {bool queuable = true}) => addNetworkQuery(
        'zrevrange',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrevrangebylex(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'zrevrangebylex',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrevrangebyscore(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'zrevrangebyscore',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zrevrank(String key, {bool queuable = true}) => addNetworkQuery(
        'zrevrank',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zscan(String key, {bool queuable = true}) => addNetworkQuery(
        'zscan',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zscore(String key, {bool queuable = true}) => addNetworkQuery(
        'zscore',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
  Future<int> zunionstore(String key, {bool queuable = true}) =>
      addNetworkQuery(
        'zunionstore',
        body: {},
        optionalParams: {
          '_id': key,
        },
        queuable: queuable,
      ).then((response) => response.result);
}
