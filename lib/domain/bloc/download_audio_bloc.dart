import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ttcm_flutter_test/domain/entity/ttcm_audio.dart';
import 'package:ttcm_flutter_test/domain/repository/audio_repository.dart';
import 'package:ttcm_flutter_test/logger.dart';

@injectable
class DownloadAudioBloc extends Bloc<DownloadAudioEvent, DownloadAudioState> {
  final AudioRepository _audioRepository;

  final _cancelCompletersMap = <String, Completer>{};

  DownloadAudioBloc(this._audioRepository)
      : super(
          DownloadAudioInitial(downloadedAudio: {}),
        ) {
    on<DownloadAudioEvent>((event, emit) async => await _mapEventToState(event, emit));
  }

  Future<void> _mapEventToState(DownloadAudioEvent event, Emitter emit) async {
    if (event is StartDownloadAudioEvent && _cancelCompletersMap[event.audio.id] != null) {
      logger.w('DownloadAudioBloc triggered by ${event.runtimeType.toString()} with processing audio. Skipping.');
      return;
    }
    if (event is StopDownloadAudioEvent && _cancelCompletersMap[event.audio.id] == null) {
      logger.w('DownloadAudioBloc triggered by ${event.runtimeType.toString()} with no processing audio. Skipping.');
      return;
    }
    switch (event) {
      case StartDownloadAudioEvent e:
        await _downloadAudio(e, emit);
        break;
      case StopDownloadAudioEvent e:
        await _stopDownloadAudio(e, emit);
    }
  }

  Future<void> _downloadAudio(StartDownloadAudioEvent event, Emitter emit) async {
    final audioId = event.audio.id;
    final cancelCompleter = _cancelCompletersMap[audioId];

    if (cancelCompleter != null) {
      logger.w('DownloadAudioBloc triggered by ${event.runtimeType.toString()} with processing audio. Skipping.');
      return;
    }

    final newCancelCompleter = Completer();

    _cancelCompletersMap[audioId] = newCancelCompleter;

    try {
      final loadingMap = {...state.downloadedAudio};
      loadingMap[audioId] = false;
      emit(
        DownloadAudioProcessing(
          downloadedAudio: {
            ...loadingMap,
          },
        ),
      );
      await _audioRepository.downloadAudio(
        audio: event.audio,
        onReceiveProgress: (int count, int total) => _onReceiveProgress(
          count,
          total,
          audioId: audioId,
          emit: emit,
        ),
        cancelCompleter: newCancelCompleter,
      );

      final loadedMap = {...state.downloadedAudio};
      loadedMap[audioId] = true;
      emit(DownloadAudioProcessing(downloadedAudio: {...loadedMap}));
    } catch (err, st) {
      logger.e(
        err,
        stackTrace: st,
      );
      newCancelCompleter.complete();
      _cancelCompletersMap.remove(audioId);

      final newStateData = {...state.downloadedAudio};
      newStateData.remove(audioId);
      emit(
        DownloadAudioProcessing(
          downloadedAudio: newStateData,
        ),
      );
    }
  }

  void _onReceiveProgress(
    int count,
    int total, {
    required String audioId,
    required Emitter emit,
  }) {
    // final progress = count * 100 ~/ total;
  }

  Future<void> _stopDownloadAudio(StopDownloadAudioEvent event, Emitter emit) async {
    final audioId = event.audio.id;
    final cancelCompleter = _cancelCompletersMap[audioId];

    if (cancelCompleter == null) {
      logger.w('DownloadAudioBloc triggered by ${event.runtimeType.toString()} with no processing audio. Skipping.');
      return;
    }

    cancelCompleter.complete();

    _cancelCompletersMap.remove(audioId);

    final newStateData = {...state.downloadedAudio};

    newStateData.remove(audioId);

    if (newStateData.isEmpty) {
      emit(DownloadAudioInitial(downloadedAudio: {}));
    } else {
      emit(DownloadAudioProcessing(downloadedAudio: newStateData));
    }
  }
}

sealed class DownloadAudioEvent with EquatableMixin {
  final TTCMAudio audio;

  const DownloadAudioEvent(this.audio);

  @override
  List<Object?> get props => [audio];
}

class StartDownloadAudioEvent extends DownloadAudioEvent {
  const StartDownloadAudioEvent(super.audio);
}

class StopDownloadAudioEvent extends DownloadAudioEvent {
  const StopDownloadAudioEvent(super.audio);
}

class DownloadAudioState with EquatableMixin {
  final Map<String, bool> downloadedAudio;

  const DownloadAudioState({
    required this.downloadedAudio,
  });

  @override
  List<Object?> get props => [
        downloadedAudio,
      ];
}

class DownloadAudioInitial extends DownloadAudioState {
  DownloadAudioInitial({
    required super.downloadedAudio,
  });
}

class DownloadAudioProcessing extends DownloadAudioState {
  DownloadAudioProcessing({
    required super.downloadedAudio,
  });
}
