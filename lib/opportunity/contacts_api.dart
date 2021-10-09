import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:relatasapp/utils.dart';

var token =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjU0MWM4M2Q4OWZmNDRmNzY3YTIzYzU0NiI.P1XwTMHP2BIWl-0UvjGAB3_PQB48DWgc6qvtSI_4c4A";


class ContactService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    if (query.isEmpty && query.length < 3) {
      print('Query needs to be at least 3 chars');
      return Future.value([]);
    }
    var url = Uri.https('api.datamuse.com', '/sug', {'s': query});

    var response = await http.get(url);
    List<Suggestion> suggestions = [];
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body);
      suggestions =
      List<Suggestion>.from(json.map((model) => Suggestion.fromJson(model)));

      print('Number of suggestion: ${suggestions.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(suggestions
        .map((e) => {'name': e.word, 'personEmailId': e.personEmailId.toString()})
        .toList());
  }
}

class ContactServiceV2 {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    if (query.isEmpty && query.length < 3) {
      print('Query needs to be at least 3 chars');
      return Future.value([]);
    }

    String _baseUrl = getBaseUrl();
    const _contactsResource = 'mobile/search/contacts';

    var response = await http
        .get(
        Uri.parse(
          '$_baseUrl$_contactsResource?'
              'contactName=$query',
        ),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + token,
        });

    // var response = await http.get(url);
    List<Contacts> suggestions = [];
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body);
      suggestions =
      List<Contacts>.from(json.map((model) => Contacts.fromJson(model)));

      print('Number of suggestion: ${suggestions.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(suggestions
        .map((e) => {'name': e.personName, 'personEmailId': e.personEmailId})
        .toList());
  }
}

class Suggestion {
  final int personEmailId;
  final String word;

  Suggestion({
    required this.personEmailId,
    required this.word,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      word: json['word'],
      personEmailId: json['personEmailId'],
    );
  }
}

class Contacts {

  Contacts({
    required this.personEmailId,
    required this.personName,});

  factory Contacts.fromJson(Map<String, dynamic> json) =>
      Contacts(
          personEmailId: json['personEmailId'],
          personName: json['personName']
      );

  String personName;
  String personEmailId;

}

class ContactSummary {
  List<Contacts>? contacts;

  ContactSummary({required this.contacts});

  ContactSummary.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      contacts = <Contacts>[];
      json['Data'].forEach((v) {
        contacts!.add(new Contacts.fromJson(v));
      });
    }

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contacts'] = this.contacts;
  }
}