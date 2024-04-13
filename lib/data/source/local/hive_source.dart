import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@preResolve
@lazySingleton
class HiveSource {
  static const _cachedAudioBoxId = 'cachedAudioBox';

  late final Box<String> _cachedAudioBox;

  final _cachedAudioIds = BehaviorSubject<List<String>>.seeded([]);

  HiveSource._();

  @factoryMethod
  static Future<HiveSource> create() async {
    await Hive.initFlutter();

    final instance = HiveSource._();

    instance._cachedAudioBox = await Hive.openBox<String>(_cachedAudioBoxId);

    instance._cachedAudioIds.add((instance._cachedAudioBox.keys.toList()).cast<String>());

    return instance;
  }

  String? getAudioPath(String auidoId) => _cachedAudioBox.get(auidoId);

  Future<void> setAudioPath({
    required String audioId,
    required String audioPath,
  }) async {
    await _cachedAudioBox.put(audioId, audioPath);

    _cachedAudioIds.add((_cachedAudioBox.keys.toList()).cast<String>());
  }

  Future<void> clearCache() async {
    await _cachedAudioBox.clear();
    _cachedAudioIds.add([]);
  }

  Stream<List<String>> get cachedAudiosStream => _cachedAudioIds.asBroadcastStream();
}
