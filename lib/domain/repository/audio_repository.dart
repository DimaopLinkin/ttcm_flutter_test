import 'dart:async';

import 'package:ttcm_flutter_test/domain/entity/ttcm_audio.dart';

abstract class AudioRepository {
  Future<List<String>> getTagsList();

  Future<List<TTCMAudio>> getFilteredAudioList({
    required List<String> tagsList,
  });

  Future<void> downloadAudio({
    required TTCMAudio audio,
    required Function(int, int) onReceiveProgress,
    required Completer cancelCompleter,
  });
}
