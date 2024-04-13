import 'package:flutter/material.dart';

class TagsWidget extends StatefulWidget {
  final List<String> tagsList;
  final ValueNotifier<List<String>> selectedTagsNotifier;

  const TagsWidget({
    super.key,
    required this.tagsList,
    required this.selectedTagsNotifier,
  });

  @override
  State<TagsWidget> createState() => _TagsWidgetState();
}

class _TagsWidgetState extends State<TagsWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (var tag in widget.tagsList)
          ValueListenableBuilder<List<String>>(
            valueListenable: widget.selectedTagsNotifier,
            builder: (context, selectedTags, child) {
              return InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  if (selectedTags.contains(tag)) {
                    final newList = [...selectedTags];
                    newList.remove(tag);
                    widget.selectedTagsNotifier.value = [...newList];
                  } else {
                    final newList = [...selectedTags];
                    newList.add(tag);
                    widget.selectedTagsNotifier.value = [...newList];
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: selectedTags.contains(tag)
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
