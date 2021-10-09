import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../utils.dart';
import 'dart:io';

var token =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjU0MWM4M2Q4OWZmNDRmNzY3YTIzYzU0NiI.P1XwTMHP2BIWl-0UvjGAB3_PQB48DWgc6qvtSI_4c4A";

class OppListScreen extends StatefulWidget {
  OppListScreen({Key? key}) : super(key: key);

  @override
  _OppListScreenState createState() => _OppListScreenState();
}

class _OppListScreenState extends State<OppListScreen> {
  bool? _hasMore;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  String? _chosenValue;
  final int _defaultItemsPerPageCount = 10;
  late List<Opportunity> _opps;
  final int _nextPageThreshold = 10;
  final double fontSizeBase = 18;

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _opps = [];
    fetchOpps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("DEALS"), backgroundColor: parseColor("#6b869e")),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            // Container(
            //   // height: 50,
            //   // color: Colors.500],
            //   child: dropDownLs(['Proposal', 'Demo']),
            // ),
            Container(
              constraints: BoxConstraints(
                maxHeight: double.infinity,
              ),
              color: parseColor("#f7f7f7"),
              // color: Colors.white10,
              child: getBodyOpp(),
            ),
          ],
        ));
  }

  Widget dropDownLs(stages) {
    return Container(
        margin: EdgeInsets.only(bottom: 10.0, top: 5, left: 5),
        child: DropdownButton<String>(
          value: _chosenValue,
          elevation: 5,
          style: TextStyle(color: Colors.black),
          items: stages.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: Text(
            "Select a stage",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onChanged: (String? value) {
            setState(() {
              _chosenValue = value;
              print(_chosenValue);
            });
          },
        ));
  }

  Widget getBodyOpp() {
    if (_opps.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
          child: InkWell(
            onTap: () => setState(
              () {
                _loading = true;
                _error = false;
                fetchOpps();
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Text("Error while loading Opps, tap to try again"),
            ),
          ),
        );
      }
    } else {

      return ListView.builder(
        shrinkWrap: true,
        itemCount: _opps.length + (_hasMore! ? 1 : 0),
        itemBuilder: (context, index) {
          print("index--");
          print(index);
          print(_hasMore);
          // if (index == _opps.length - _nextPageThreshold) {
          if (_opps.length > 10) {
            fetchOpps();
          }
          if (index == _opps.length) {
            if (_error) {
              return Center(
                child: InkWell(
                  onTap: () => setState(
                    () {
                      _loading = true;
                      _error = false;
                      fetchOpps();
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Error while loading opps, tap to try again"),
                  ),
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          final Opportunity opp = _opps[index];
          return Card(
              margin: const EdgeInsets.only(bottom: 15),
              child: new InkWell(
                  onTap: () {
                    print("Open opp details");
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Image.network(
                      //   opp.thumbnailUrl,
                      //   fit: BoxFit.fitWidth,
                      //   width: double.infinity,
                      //   height: 160,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          opp.opportunityName!,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: fontSizeBase,
                              color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          opp.amount!,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 32,
                              color: parseColor('#333333')),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          getFormattedDate(opp.closeDate!),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: fontSizeBase,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  )));
        },
      );
    }
    return Container();
  }

  Future<void> fetchOpps() async {

    try {
      final response = await http.post(
        Uri.parse(getBaseUrl() +
            "mobile/reports/get/opportunities/v2?page=$_pageNumber"),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + token,
        },
      );

      List<Opportunity> fetchedOpps =
          Opportunity.parseList(json.decode(response.body));
      print("--fetchedOpps.length---");
      print(fetchedOpps.length);
      setState(
        () {
          _hasMore = fetchedOpps.length >= _defaultItemsPerPageCount;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _opps.addAll(fetchedOpps);
        },
      );
    } catch (e) {
      setState(
        () {
          _loading = false;
          _error = true;
        },
      );
    }
  }
}

class Opportunity {
  String? opportunityName;
  String? userEmailId;
  String? stageName;
  String? closeDate;
  String? amount;

  Opportunity(
    this.opportunityName,
    this.userEmailId,
    this.stageName,
    this.closeDate,
    this.amount,
  );

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      json["opportunityName"],
      json["userEmailId"],
      json["stageName"],
      json["closeDate"],
      json["amount"],
    );
  }

  static List<Opportunity> parseList(List<dynamic> list) {
    return list.map((i) => Opportunity.fromJson(i)).toList();
  }
}
