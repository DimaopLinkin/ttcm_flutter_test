import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ttcm_flutter_test/domain/entity/ttcm_audio.dart';
import 'package:ttcm_flutter_test/domain/repository/audio_repository.dart';
import 'package:ttcm_flutter_test/logger.dart';

@injectable
class FilteredAudioBloc extends Bloc<FilteredAudioEvent, FilteredAudioState> {
  final AudioRepository _audioRepository;

  Set<String>? _lastFilteredAudio;

  FilteredAudioBloc(this._audioRepository) : super(const FilteredAudioInitial([])) {
    on<FilteredAudioEvent>((event, emit) => _mapEventToState(event, emit));
  }

  void _mapEventToState(FilteredAudioEvent event, Emitter emit) {
    if (state is FilteredAudioLoading) {
      logger.w('FilteredAudioBloc triggered by ${event.runtimeType.toString()} on loading state. Skipping.');
      return;
    }
    if (event is FilteredAudioLoadEvent && (!event.force && _lastFilteredAudio == event.tagsList.toSet())) {
      logger.w(
        'FilteredAudioBloc triggered by ${event.runtimeType.toString()} with equal tags request: ${event.tagsList}',
      );
      return;
    }
    switch (event) {
      case FilteredAudioLoadEvent e:
        _loadAudios(e, emit);
    }
  }

  Future<void> _loadAudios(FilteredAudioLoadEvent event, Emitter emit) async {
    emit(FilteredAudioLoading(state.audiosList));
    try {
      final result = await _audioRepository.getFilteredAudioList(tagsList: event.tagsList);

      emit(FilteredAudioReady(result));
    } catch (err, st) {
      logger.e(
        err,
        stackTrace: st,
      );
      emit(FilteredAudioError(state.audiosList));
    }
  }
}

sealed class FilteredAudioEvent {
  const FilteredAudioEvent();
}

class FilteredAudioLoadEvent extends FilteredAudioEvent with EquatableMixin {
  final List<String> tagsList;

  final bool force;

  const FilteredAudioLoadEvent(
    this.tagsList, {
    this.force = false,
  });

  @override
  List<Object?> get props => [tagsList, force];
}

sealed class FilteredAudioState with EquatableMixin {
  final List<TTCMAudio> audiosList;

  const FilteredAudioState(this.audiosList);

  @override
  List<Object?> get props => [audiosList];
}

class FilteredAudioInitial extends FilteredAudioState {
  const FilteredAudioInitial(super.audiosList);
}

class FilteredAudioLoading extends FilteredAudioState {
  const FilteredAudioLoading(super.audiosList);
}

class FilteredAudioReady extends FilteredAudioState {
  const FilteredAudioReady(super.audiosList);
}

class FilteredAudioError extends FilteredAudioState {
  final String? errorMessage;

  const FilteredAudioError(
    super.audiosList, {
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        super.audiosList,
        errorMessage,
      ];
}
