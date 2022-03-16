import 'package:books/services/books_helper.dart';
import 'package:flutter/material.dart';

class BooksList extends StatelessWidget {
  final List<dynamic> books;
  final bool isFavorite;
  final BooksHelper helper = BooksHelper();

  BooksList(this.books, this.isFavorite);

  @override
  Widget build(BuildContext context) {
    final int booksCount = books.length;

    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      child: ListView.builder(
          itemCount: (booksCount == null) ? 0 : booksCount,
          itemBuilder: (BuildContext context, int position) {
            return ListTile(
              title: Text(books[position].title),
              subtitle: Text(books[position].authors),
              trailing: IconButton(
                color: (isFavorite) ? Colors.red : Colors.amber,
                tooltip: (isFavorite) ? 'Remove from favorites' : 'Add to favorite',
                icon: Icon(Icons.star),
                onPressed: () {},
              ),
            );
          }),
    );
  }

}