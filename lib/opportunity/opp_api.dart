import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'opp_summary.dart';
// import 'opp_summary_response.dart';
import 'package:http/http.dart' as http;
import '../utils.dart';

var token =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjU0MWM4M2Q4OWZmNDRmNzY3YTIzYzU0NiI.P1XwTMHP2BIWl-0UvjGAB3_PQB48DWgc6qvtSI_4c4A";

class RemoteOppApi {

  static Future<OpportunityResponseSummary> getData(
      int offset,
      int limit, {
        String? searchTerm,
        String? stageName,
      }) async {

     var data = await http
        .post(
        _ApiUrlBuilder.oppSummary(offset, limit, searchTerm: searchTerm,stageName:stageName),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + token,
        });

     return OpportunityResponseSummary.fromJson(json.decode(data.body));
  }

  static Future<OpportunityResponseSummary> getOppDataById(
      String oppId) async {

    var data = await http
        .post(
        _ApiUrlBuilder.oppDataById(oppId),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + token,
        });

    return OpportunityResponseSummary.fromJson(json.decode(data.body));
  }

  static Future<List<OpportunitySummary>> getOppList(
    int offset,
    int limit, {
    String? searchTerm,
    String? stageName,
  }) async =>
      http
          .post(
            _ApiUrlBuilder.oppList(offset, limit, searchTerm: searchTerm,stageName:stageName),
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ' + token,
            },
          )
          .mapFromResponse<List<OpportunitySummary>, List<dynamic>>(
            (jsonArray) => _parseItemListFromJsonArray(
              jsonArray!,
              (jsonObject) => OpportunitySummary.fromJson(jsonObject),
            ),
          );

  static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}

class _ApiUrlBuilder {
  static String _baseUrl = getBaseUrl();
  static const _charactersResource = 'mobile/reports/get/opportunities/v2';
  static const _summaryResource = 'mobile/reports/get/opp/summary';
  static const _oppByIdResource = 'mobile/reports/get/opp/by/id';
  static const _stagesResource = 'mobile/get/stagelist';
  static const _contactsResource = 'mobile/search/contacts';

  static Uri getStageList() =>
      Uri.parse(
          '$_baseUrl$_stagesResource');

  static Uri oppSummary(
      int offset,
      int limit, {
        String? searchTerm,
        String? stageName,
      }) =>
      Uri.parse(
        '$_baseUrl$_summaryResource?'
            'offset=$offset'
            '&page=$offset'
            '&limit=$limit'
            '&stageName=$stageName'
            '${_buildSearchTermQuery(searchTerm)}',
      );

  static Uri contactData(
      String contactName) =>
      Uri.parse(
        '$_baseUrl$_contactsResource?'
            'contactName=$contactName',
      );

  static Uri oppDataById(
      String oppId) =>
      Uri.parse(
        '$_baseUrl$_oppByIdResource?'
            'oppId=$oppId',
      );

  static Uri oppList(
    int offset,
    int limit, {
    String? searchTerm,
    String? stageName,
  }) =>
      Uri.parse(
        '$_baseUrl$_charactersResource?'
        'offset=$offset'
        '&page=$offset'
        '&limit=$limit'
        '&stageName=$stageName'
        '${_buildSearchTermQuery(searchTerm)}',
      );

  static String _buildSearchTermQuery(String? searchTerm) =>
      searchTerm != null && searchTerm.isNotEmpty
          ? '&name=${searchTerm.replaceAll(' ', '+').toLowerCase()}'
          : '';
}

extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T?) jsonParser) async {
    try {
      final response = await this;
      if (response.statusCode == 200) {
        return jsonParser(jsonDecode(response.body));
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }
}
