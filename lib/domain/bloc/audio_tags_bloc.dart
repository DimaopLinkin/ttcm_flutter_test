import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ttcm_flutter_test/domain/repository/audio_repository.dart';
import 'package:ttcm_flutter_test/logger.dart';

@injectable
class AudioTagsBloc extends Bloc<AudioTagsEvent, AudioTagsState> {
  final AudioRepository _audioRepository;

  AudioTagsBloc(this._audioRepository) : super(const AudioTagsInitial([])) {
    on<AudioTagsEvent>((event, emit) async => await _mapEventToState(event, emit));
  }

  Future<void> _mapEventToState(AudioTagsEvent event, Emitter emit) async {
    if (state is AudioTagsLoading) {
      logger.w('AudioTagsBloc triggered by ${event.runtimeType.toString()} on loading state. Skipping.');
      return;
    }
    switch (event) {
      case AudioTagsLoadEvent e:
        await _loadTags(e, emit);
    }
  }

  Future<void> _loadTags(AudioTagsLoadEvent event, Emitter emit) async {
    emit(AudioTagsLoading(state.tagsList));
    try {
      final result = await _audioRepository.getTagsList();

      emit(AudioTagsReady(result));
    } catch (err, st) {
      logger.e(
        err,
        stackTrace: st,
      );
      emit(AudioTagsError(state.tagsList));
    }
  }
}

sealed class AudioTagsEvent {
  const AudioTagsEvent();
}

class AudioTagsLoadEvent extends AudioTagsEvent {
  const AudioTagsLoadEvent();
}

sealed class AudioTagsState with EquatableMixin {
  final List<String> tagsList;

  const AudioTagsState(this.tagsList);

  @override
  List<Object?> get props => [tagsList];
}

class AudioTagsInitial extends AudioTagsState {
  const AudioTagsInitial(super.tagsList);
}

class AudioTagsLoading extends AudioTagsState {
  const AudioTagsLoading(super.tagsList);
}

class AudioTagsReady extends AudioTagsState {
  const AudioTagsReady(super.tagsList);
}

class AudioTagsError extends AudioTagsState {
  final String? errorMessage;

  const AudioTagsError(
    super.tagsList, {
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        super.tagsList,
        errorMessage,
      ];
}
