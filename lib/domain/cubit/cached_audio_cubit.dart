import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ttcm_flutter_test/domain/repository/audio_repository.dart';

@injectable
class CachedAudioCubit extends Cubit<List<String>> {
  final AudioRepository _audioRepository;

  late final StreamSubscription<List<String>> _cachedAudioStreamSubscription;

  CachedAudioCubit(this._audioRepository) : super([]) {
    _cachedAudioStreamSubscription = _audioRepository.cachedAudioIdList.listen((event) {
      emit(event);
    });
  }

  @override
  Future<void> close() async {
    await _cachedAudioStreamSubscription.cancel();
    return super.close();
  }
}
