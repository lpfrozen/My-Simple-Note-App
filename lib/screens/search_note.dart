import 'package:flutter/material.dart';
import 'package:test/modal_class/notes.dart';

class NotesSearch extends SearchDelegate<Note?> {
  final List<Note> notes;

  NotesSearch({required this.notes});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Note> matchQuery = [];
    for (var note in notes) {
      if (note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.description!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(note);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchQuery[index].title),
          onTap: () {
            close(context, matchQuery[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Note> suggestionList = query.isEmpty
        ? notes
        : notes
            .where((note) =>
                note.title.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].title),
          onTap: () {
            query = suggestionList[index].title;
            showResults(context);
          },
        );
      },
    );
  }
}
