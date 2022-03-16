import 'package:books/services/books_helper.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';

class BooksTable extends StatelessWidget {
  final List<dynamic> books;
  final bool isFavorite;
  final BooksHelper helper = BooksHelper();

  BooksTable(this.books, this.isFavorite);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: books.map((book) {
        return TableRow(
          children: [
            TableCell(child: TableText(book.title)),
            TableCell(child: TableText(book.authors)),
            TableCell(child: TableText(book.publisher)),
            TableCell(child: IconButton(
              color: (isFavorite) ? Colors.red : Colors.amber,
              tooltip: (isFavorite) ? 'Remove from favorites' : 'Add to favorites',
              icon: Icon(Icons.star),
              onPressed: () {}
            ))
          ]);
      }).toList(),
    );
  }

}

class TableText extends StatelessWidget {
  final String text;
  TableText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(text,
        style: TextStyle(color: Theme.of(context).primaryColorDark),
      ),
    );
  }


}