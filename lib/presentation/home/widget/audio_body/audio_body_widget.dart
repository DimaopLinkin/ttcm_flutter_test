import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttcm_flutter_test/domain/bloc/filtered_audio_bloc.dart';
import 'package:ttcm_flutter_test/presentation/home/widget/audio_body/widget/audio_item_widget.dart';

class AudioBody extends StatelessWidget {
  const AudioBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredAudioBloc, FilteredAudioState>(
      builder: (context, state) {
        final audios = state.audiosList;
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0 + MediaQuery.of(context).viewPadding.bottom),
          itemCount: audios.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => AudioItemWidget(audioItem: audios[index]),
        );
      },
    );
  }
}
