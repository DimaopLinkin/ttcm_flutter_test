import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ttcm_flutter_test/data/source/local/hive_source.dart';
import 'package:ttcm_flutter_test/data/source/local/mock_source.dart';
import 'package:ttcm_flutter_test/data/source/rest_source.dart';
import 'package:ttcm_flutter_test/domain/entity/playing_location.dart';
import 'package:ttcm_flutter_test/domain/entity/ttcm_audio.dart';
import 'package:ttcm_flutter_test/domain/enum/audio_location.dart';
import 'package:ttcm_flutter_test/domain/repository/audio_repository.dart';

@LazySingleton(as: AudioRepository)
class AudioRepositoryImpl implements AudioRepository {
  final MockSource _mockSource;

  final RestSource _restSource;

  final HiveSource _hiveSource;

  AudioRepositoryImpl(
    this._mockSource,
    this._restSource,
    this._hiveSource,
  );

  @override
  Future<List<String>> getTagsList() => _mockSource.getTagsList();

  @override
  Future<List<TTCMAudio>> getFilteredAudioList({
    required List<String> tagsList,
  }) =>
      _mockSource.getFilteredAudioList(tagsList);

  @override
  Future<void> downloadAudio({
    required TTCMAudio audio,
    required Function(int, int) onReceiveProgress,
    required Completer cancelCompleter,
  }) async {
    final Directory downloadsDirectory = await getApplicationDocumentsDirectory();

    late final String downloadPath;

    late final String fileName;

    for (var i = 0; true; i++) {
      final file = File('${downloadsDirectory.path}/${audio.name}${i > 0 ? '_$i' : ''}.mp3');

      if (!(await file.exists())) {
        downloadPath = file.path;
        fileName = '${audio.name}${i > 0 ? '_$i' : ''}.mp3';
        break;
      }
      if (i > 10) {
        throw Exception('Too many downloaded copies with name: ${audio.name}.mp3');
      }
    }

    await _restSource.downloadFile(
      urlPath: audio.url,
      downloadPath: downloadPath,
      onReceiveProgress: onReceiveProgress,
      cancelCompleter: cancelCompleter,
    );

    await _hiveSource.setAudioPath(audioId: audio.id, audioPath: fileName);
  }

  @override
  Future<PlayingLocation> getPlayingLocation({
    required TTCMAudio audio,
  }) async {
    final localPath = _hiveSource.getAudioPath(audio.id);

    if (localPath == null) {
      return PlayingLocation(
        path: audio.url,
        audioLocation: AudioLocation.remote,
      );
    }

    final docDirectory = await getApplicationDocumentsDirectory();

    return PlayingLocation(
      path: '${docDirectory.path}/$localPath',
      audioLocation: AudioLocation.local,
    );
  }

  @override
  Stream<List<String>> get cachedAudioIdList => _hiveSource.cachedAudiosStream;
}
