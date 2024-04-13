import 'package:equatable/equatable.dart';
import 'package:ttcm_flutter_test/domain/enum/audio_location.dart';

class PlayingLocation with EquatableMixin {
  final String path;

  final AudioLocation audioLocation;

  PlayingLocation({
    required this.path,
    required this.audioLocation,
  });

  @override
  List<Object?> get props => [
        path,
        audioLocation,
      ];
}
