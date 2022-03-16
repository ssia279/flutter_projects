class Book {
  String id;
  String title;
  String authors;
  String description;
  String publisher;

  Book(this.id, this.title, this.authors, this.description, this.publisher);

  factory Book.fromJson(Map<String, dynamic> parseJson) {
    final String id = parseJson['id'];
    final String title = parseJson['volumeInfo']['title'];
    String authors = (parseJson['volumeInfo']['authors'] == null) ? ''
        : parseJson['volumeInfo']['authors'].toString();
    authors = authors.replaceAll('[', '');
    authors = authors.replaceAll(']', '');
    final String description = (parseJson['volumeInfo']['description'] == null) ? ''
        : parseJson['volumeInfo']['description'];
    final String publisher = (parseJson['volumeInfo']['publisher'] == null) ? ''
        : parseJson['volumeInfo']['publisher'];

    return Book(id, title, authors, description, publisher);
  }

  Map <String, dynamic> toJson() {

    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'publisher': publisher
    };
  }
}