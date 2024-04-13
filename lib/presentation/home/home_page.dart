import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttcm_flutter_test/domain/bloc/audio_tags_bloc.dart';
import 'package:ttcm_flutter_test/domain/bloc/download_audio_bloc.dart';
import 'package:ttcm_flutter_test/domain/bloc/filtered_audio_bloc.dart';
import 'package:ttcm_flutter_test/domain/bloc/playing_bloc.dart';
import 'package:ttcm_flutter_test/domain/cubit/cached_audio_cubit.dart';
import 'package:ttcm_flutter_test/injection.dart';
import 'package:ttcm_flutter_test/presentation/home/widget/audio_body/audio_body_widget.dart';
import 'package:ttcm_flutter_test/presentation/home/widget/player_widget/player_widget.dart';
import 'package:ttcm_flutter_test/presentation/home/widget/tags_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _audioTagsBloc = getIt.get<AudioTagsBloc>();
  final _filteredAudioBloc = getIt.get<FilteredAudioBloc>();
  final _downloadAudioBloc = getIt.get<DownloadAudioBloc>();
  final _playingBloc = getIt.get<PlayingBloc>();
  final _cachedAudioCubit = getIt.get<CachedAudioCubit>();

  final _selectedTagsNotifier = ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    _audioTagsBloc.add(const AudioTagsLoadEvent());

    _selectedTagsNotifier.addListener(_tagsChangedListener);
  }

  @override
  void dispose() {
    _selectedTagsNotifier.dispose();
    _downloadAudioBloc.close();
    _filteredAudioBloc.close();
    _audioTagsBloc.close();
    _playingBloc.close();
    _cachedAudioCubit.close();
    super.dispose();
  }

  void _tagsChangedListener() {
    final tagsToFilter = _selectedTagsNotifier.value;

    _filteredAudioBloc.add(FilteredAudioLoadEvent(tagsToFilter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _audioTagsBloc),
            BlocProvider.value(value: _filteredAudioBloc),
            BlocProvider.value(value: _downloadAudioBloc),
            BlocProvider.value(value: _playingBloc),
            BlocProvider.value(value: _cachedAudioCubit),
          ],
          child: BlocConsumer<AudioTagsBloc, AudioTagsState>(
            listener: (context, state) {
              if (state is AudioTagsReady) {
                _selectedTagsNotifier.value = [];
                _filteredAudioBloc.add(const FilteredAudioLoadEvent([], force: true));
              }
            },
            builder: (context, state) {
              if (state is AudioTagsReady) {
                return Column(
                  children: [
                    TagsWidget(
                      tagsList: state.tagsList,
                      selectedTagsNotifier: _selectedTagsNotifier,
                    ),
                    const SizedBox(height: 8.0),
                    const Expanded(
                      child: AudioBody(),
                    ),
                    const PlayerWidget(),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
