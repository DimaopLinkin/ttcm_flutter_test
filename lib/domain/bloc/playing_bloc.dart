import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ttcm_flutter_test/domain/entity/ttcm_audio.dart';
import 'package:ttcm_flutter_test/domain/enum/audio_location.dart';
import 'package:ttcm_flutter_test/domain/repository/audio_repository.dart';

@injectable
class PlayingBloc extends Bloc<PlayingEvent, PlayingState> {
  final AudioRepository _audioRepository;

  static final _player = AudioPlayer();

  PlayingBloc(this._audioRepository)
      : super(PlayingState(
          audio: null,
          playing: false,
          player: _player,
        )) {
    on<PlayingEvent>((event, emit) async => await _mapEventToState(event, emit));
  }

  Future<void> _mapEventToState(PlayingEvent event, Emitter emit) async {
    switch (event) {
      case PlayPlayingEvent e:
        await _play(e, emit);
        break;
      case PausePlayingEvent e:
        await _pause(e, emit);
    }
  }

  Future<void> _play(PlayPlayingEvent event, Emitter emit) async {
    if (state.audio == event.audio) {
      _player.play();
    } else {
      final playingLocation = await _audioRepository.getPlayingLocation(audio: event.audio);

      switch (playingLocation.audioLocation) {
        case AudioLocation.local:
          await _player.setAudioSource(AudioSource.file(playingLocation.path));
          _player.play();
          break;
        case AudioLocation.remote:
          await _player.setAudioSource(AudioSource.uri(Uri.parse(playingLocation.path)));
          _player.play();
          break;
        default:
      }
    }
    emit(PlayingState(audio: event.audio, playing: true, player: _player));
  }

  Future<void> _pause(PausePlayingEvent event, Emitter emit) async {
    await _player.pause();
    emit(PlayingState(audio: state.audio, playing: false, player: _player));
  }

  @override
  Future<void> close() async {
    await _player.dispose();
    return super.close();
  }
}

sealed class PlayingEvent {
  const PlayingEvent();
}

class PlayPlayingEvent extends PlayingEvent with EquatableMixin {
  final TTCMAudio audio;

  PlayPlayingEvent({
    required this.audio,
  });

  @override
  List<Object?> get props => [audio];
}

class PausePlayingEvent extends PlayingEvent {
  const PausePlayingEvent();
}

class PlayingState with EquatableMixin {
  final TTCMAudio? audio;
  final bool playing;
  final AudioPlayer player;

  PlayingState({
    required this.audio,
    required this.playing,
    required this.player,
  });

  @override
  List<Object?> get props => [
        audio,
        playing,
        player,
      ];
}
