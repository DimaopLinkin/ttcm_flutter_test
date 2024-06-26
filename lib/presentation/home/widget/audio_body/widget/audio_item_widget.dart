import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttcm_flutter_test/domain/bloc/download_audio_bloc.dart';
import 'package:ttcm_flutter_test/domain/bloc/playing_bloc.dart';
import 'package:ttcm_flutter_test/domain/cubit/cached_audio_cubit.dart';
import 'package:ttcm_flutter_test/domain/entity/ttcm_audio.dart';

class AudioItemWidget extends StatelessWidget {
  final TTCMAudio audioItem;

  const AudioItemWidget({
    super.key,
    required this.audioItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          BlocBuilder<PlayingBloc, PlayingState>(
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  if (state.audio?.id == audioItem.id && state.playing) {
                    context.read<PlayingBloc>().add(const PausePlayingEvent());
                  } else {
                    context.read<PlayingBloc>().add(PlayPlayingEvent(audio: audioItem));
                  }
                },
                child: Icon(
                  state.audio?.id == audioItem.id && state.playing ? Icons.pause : Icons.play_arrow,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  size: 32.0,
                ),
              );
            },
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  audioItem.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  audioItem.tags.join('   '),
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          BlocBuilder<CachedAudioCubit, List<String>>(
            builder: (context, cachedAudioList) {
              final isCached = cachedAudioList.contains(audioItem.id);
              return BlocBuilder<DownloadAudioBloc, DownloadAudioState>(
                builder: (context, state) {
                  final processingState = state.downloadedAudio[audioItem.id];
                  if (processingState != true && !isCached) {
                    return InkWell(
                      onTap: () {
                        if (processingState == null) {
                          context.read<DownloadAudioBloc>().add(StartDownloadAudioEvent(audioItem));
                        } else {
                          context.read<DownloadAudioBloc>().add(StopDownloadAudioEvent(audioItem));
                        }
                      },
                      child: Icon(
                        processingState == null ? Icons.download : Icons.downloading,
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        size: 32.0,
                      ),
                    );
                  } else {
                    return Icon(
                      Icons.download_done,
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      size: 32.0,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
