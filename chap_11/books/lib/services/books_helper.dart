import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/book.dart';

class BooksHelper {
  final String urlKey = '&key=API_KEY';
  final String urlQuery = 'volumes?q=';
  final String urlBase = 'https://www.googleapis.com/books/v1/';

  Future<List<dynamic>> getBooks(String query) async {
    final String url = urlBase + urlQuery + query + urlKey;
    http.Response result = await http.get(Uri.parse(url));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final booksMap = jsonResponse['items'];
      List<dynamic> books = booksMap.map((item) => Book.fromJson(item)).toList();
      return books;
    } else {
      return <dynamic>[];
    }
  }
}