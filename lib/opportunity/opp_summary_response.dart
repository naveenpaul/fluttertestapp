// class OpportunityResponse {
//   int? page;
//   int? pageCount;
//   List<OpportunitySummary>? opps;
//
//   OpportunityResponse({this.page, this.opps});
//
//   OpportunityResponse.fromJson(Map<String, dynamic> newsJson)
//       : page = newsJson['page'],
//         opps = List.from(newsJson['opps'])
//             .map((article) => OpportunitySummary.fromJson(article))
//             .toList(),
//         pageCount = newsJson['pageCount'];
// }

// https://gist.githubusercontent.com/agarasul/9f080a6caadf97f539d72e16e0ffd0fd/raw/4cd8d8dbac028bf5c42a86c1cf6c7cc578f06e98/news.dart

class OpportunityResponseSummary {
  int? page;
  int? pageCount;
  List<OpportunitySummary>? opps;
  List<Stages>? stages;

  OpportunityResponseSummary({this.page, this.pageCount, required this.opps, required this.stages});

  OpportunityResponseSummary.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    pageCount = json['pageCount'];
    if (json['opps'] != null) {
      opps = <OpportunitySummary>[];
      json['opps'].forEach((v) {
        opps!.add(new OpportunitySummary.fromJson(v));
      });
    }

    if (json['stages'] != null) {
      stages = <Stages>[];
      json['stages'].forEach((v) {
        stages!.add(new Stages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageCount'] = this.pageCount;
    if (this.opps != null) {
      data['opps'] = this.opps!.map((v) => v.toJson()).toList();
    }
    if (this.stages != null) {
      data['stages'] = this.stages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OpportunitySummary {
  // String? userEmailId;
  // String? closeDate;
  // String? amount;
  //
  // OpportunitySummary({this.userEmailId, this.closeDate, this.amount});
  //
  OpportunitySummary.fromJson(Map<String, dynamic> json) {
    userEmailId = json['userEmailId'];
    closeDate = json['closeDate'];
    amount = json['amount'];
  }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['userEmailId'] = this.userEmailId;
  //   data['closeDate'] = this.closeDate;
  //   data['amount'] = this.amount;
  //   return data;
  // }

  OpportunitySummary({
    this.opportunityName,
    this.userEmailId,
    this.stageName,
    this.closeDate,
    this.amount,});

  // factory OpportunitySummary.fromJson(Map<String, dynamic> json) =>
  //     OpportunitySummary(
  //       opportunityName: json['opportunityName'],
  //       userEmailId: json['userEmailId'],
  //       stageName: json['stageName'],
  //       closeDate: json['closeDate'],
  //       amount: json['amount'],
  //     );

  String? opportunityName;
  String? userEmailId;
  String? stageName;
  String? closeDate;
  String? amount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userEmailId'] = this.userEmailId;
    data['closeDate'] = this.closeDate;
    data['amount'] = this.amount;
    return data;
  }

}

class Stages {
  String? name;
  String? oppCount;
  String? amount;

  Stages({this.name, this.oppCount, this.amount});

  Stages.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    oppCount = json['oppCount'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['oppCount'] = this.oppCount;
    data['amount'] = this.amount;
    return data;
  }
}
