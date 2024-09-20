// Note model class
class Note {
  String title;
  String content;
  List<String> links;
  bool pinned;
  DateTime lastEdited;

  Note({
    required this.title,
    required this.content,
    required this.links,
    this.pinned = false,
    required this.lastEdited,
  });
// Convert Note object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'links': links,
      'pinned': pinned,
      'lastEdited': lastEdited.toIso8601String(),
    };
  }

  // Create Note object from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      content: json['content'],
      links: List<String>.from(json['links']),
      pinned: json['pinned'],
      lastEdited: DateTime.parse(json['lastEdited']),
    );
  }
  // Calculate character count
  int get characterCount => content.length + title.length;
}
