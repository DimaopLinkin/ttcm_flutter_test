import 'package:injectable/injectable.dart';
import 'package:ttcm_flutter_test/domain/entity/ttcm_audio.dart';

@lazySingleton
class MockSource {
  Future<List<TTCMAudio>> getFilteredAudioList(List<String> tagsList) async {
    var derivedData = [..._mockAudio];

    if (tagsList.isNotEmpty) {
      final Set<TTCMAudio> newDataSet = {};
      for (var tag in tagsList) {
        newDataSet.addAll(derivedData.where((element) => element.tags.contains(tag)).toList());
      }
      return newDataSet.toList();
    } else {
      return derivedData;
    }
  }

  Future<List<String>> getTagsList() async {
    final Set<String> tagsSet = {};

    for (var audio in _mockAudio) {
      tagsSet.addAll(audio.tags);
    }

    return tagsSet.toList();
  }
}

List<TTCMAudio> _mockAudio = [
  ..._inTheZone,
  ..._hybridTheory,
  ..._meteora,
  ..._whatHappensNext,
];

List<TTCMAudio> _inTheZone = [
  const TTCMAudio(
    id: '0',
    name: 'Britney Spears - Toxic',
    tags: [
      '2003',
      'Britney Spears',
      'Pop',
      'In The Zone',
      'Favorite',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Britney%20Spears%20-%20Toxic.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '1',
    name: 'Britney Spears - Touch Of My Hand',
    tags: [
      '2003',
      'Britney Spears',
      'Pop',
      'In The Zone',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Britney%20Spears%20-%20Touch%20Of%20My%20Hand.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '2',
    name: 'Britney Spears - The Hook Up',
    tags: [
      '2003',
      'Britney Spears',
      'Pop',
      'In The Zone',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Britney%20Spears%20-%20The%20Hook%20Up.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '3',
    name: 'Britney Spears - The Answer',
    tags: [
      '2003',
      'Britney Spears',
      'Pop',
      'In The Zone',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Britney%20Spears%20-%20The%20Answer.mp3?alt=media',
  ),
];

List<TTCMAudio> _hybridTheory = [
  const TTCMAudio(
    id: '4',
    name: 'Linkin Park - Crawling',
    tags: [
      '2001',
      'Linkin Park',
      'Rock',
      'Hybrid Theory',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Linkin%20Park%20-%20Crawling.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '5',
    name: 'Linkin Park - In The End',
    tags: [
      '2001',
      'Linkin Park',
      'Rock',
      'Hybrid Theory',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Linkin%20Park%20-%20In%20The%20End.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '6',
    name: 'Linkin Park - One Step Closer',
    tags: [
      '2001',
      'Linkin Park',
      'Rock',
      'Hybrid Theory',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Linkin%20Park%20-%20One%20Step%20Closer.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '7',
    name: 'Linkin Park - With You',
    tags: [
      '2001',
      'Linkin Park',
      'Rock',
      'Hybrid Theory',
      'Favorite',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Linkin%20Park%20-%20With%20You.mp3?alt=media',
  ),
];

List<TTCMAudio> _meteora = [
  const TTCMAudio(
    id: '8',
    name: 'Linkin Park - Breaking the Habit',
    tags: [
      '2003',
      'Linkin Park',
      'Rock',
      'Meteora',
      'Favorite',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Linkin%20Park%20-%20Breaking%20the%20Habit.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '9',
    name: 'Linkin Park - Faint',
    tags: [
      '2003',
      'Linkin Park',
      'Rock',
      'Meteora',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Linkin%20Park%20-%20Faint.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '10',
    name: 'Linkin Park - From the Inside',
    tags: [
      '2003',
      'Linkin Park',
      'Rock',
      'Meteora',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Linkin%20Park%20-%20From%20the%20Inside.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '11',
    name: 'Linkin Park - Numb',
    tags: [
      '2003',
      'Linkin Park',
      'Rock',
      'Meteora',
      'Favorite',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Linkin%20Park%20-%20Numb.mp3?alt=media',
  ),
];

List<TTCMAudio> _whatHappensNext = [
  const TTCMAudio(
    id: '12',
    name: 'Joe Satriani - Smooth Soul',
    tags: [
      '2018',
      'Joe Satriani',
      'Instrumental',
      'What Happens Next',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Joe%20Satriani%20-%20Smooth%20Soul.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '13',
    name: 'Joe Satriani - Super Funky Badass',
    tags: [
      '2018',
      'Joe Satriani',
      'Instrumental',
      'What Happens Next',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Joe%20Satriani%20-%20Super%20Funky%20Badass.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '14',
    name: 'Joe Satriani - Thunder High On The Mountain',
    tags: [
      '2018',
      'Joe Satriani',
      'Instrumental',
      'What Happens Next',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Joe%20Satriani%20-%20Thunder%20High%20On%20The%20Mountain.mp3?alt=media',
  ),
  const TTCMAudio(
    id: '15',
    name: 'Joe Satriani - What Happens Next',
    tags: [
      '2018',
      'Joe Satriani',
      'Instrumental',
      'What Happens Next',
    ],
    url:
        'https://firebasestorage.googleapis.com/v0/b/ttcm-flutter-test.appspot.com/o/Joe%20Satriani%20-%20What%20Happens%20Next.mp3?alt=media',
  ),
];
