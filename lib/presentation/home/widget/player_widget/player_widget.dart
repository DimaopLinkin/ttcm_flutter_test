import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttcm_flutter_test/domain/bloc/playing_bloc.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayingBloc, PlayingState>(
      builder: (context, state) {
        if (state.audio != null) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8.0),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (state.playing) {
                          context.read<PlayingBloc>().add(const PausePlayingEvent());
                        } else {
                          context.read<PlayingBloc>().add(PlayPlayingEvent(audio: state.audio!));
                        }
                      },
                      child: Icon(
                        state.playing ? Icons.pause : Icons.play_arrow,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        state.audio!.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
