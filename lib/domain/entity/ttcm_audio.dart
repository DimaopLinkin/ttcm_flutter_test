import 'package:equatable/equatable.dart';

class TTCMAudio with EquatableMixin {
  final String id;

  final String name;

  final List<String> tags;

  final String url;

  const TTCMAudio({
    required this.id,
    required this.name,
    required this.tags,
    required this.url,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        tags,
        url,
      ];
}
