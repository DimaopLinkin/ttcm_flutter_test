import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ttcm_flutter_test/data/source/local/mock_source.dart';
import 'package:ttcm_flutter_test/data/source/rest_source.dart';
import 'package:ttcm_flutter_test/domain/entity/ttcm_audio.dart';
import 'package:ttcm_flutter_test/domain/repository/audio_repository.dart';

@LazySingleton(as: AudioRepository)
class AudioRepositoryImpl implements AudioRepository {
  final MockSource _mockSource;

  final RestSource _restSource;

  AudioRepositoryImpl(
    this._mockSource,
    this._restSource,
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
    late final Directory? downloadsDirectory;
    if (Platform.isAndroid) {
      downloadsDirectory = await getDownloadsDirectory();
    } else if (Platform.isIOS) {
      downloadsDirectory = await getApplicationCacheDirectory();
    }

    if (downloadsDirectory == null) throw const FileSystemException();

    late final String downloadPath;

    for (var i = 0; true; i++) {
      final file = File('${downloadsDirectory.path}/${audio.name}${i > 0 ? '_$i' : ''}.mp3');

      if (!(await file.exists())) {
        downloadPath = file.path;
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

    if (Platform.isIOS) {
      await Share.shareXFiles([XFile(downloadPath)]);
    }
  }
}
