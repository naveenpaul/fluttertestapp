class OpportunityResponseSummary {
  int? page;
  int? pageCount;
  List<OpportunitySummary>? opps;
  List<OpportunityStage>? stages;

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
      stages = <OpportunityStage>[];
      json['stages'].forEach((v) {
        stages!.add(new OpportunityStage.fromJson(v));
      });
    }

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageCount'] = this.pageCount;
    data['opps'] = this.opps;
    data['stages'] = this.stages;
  }
}

// class OpportunityDetails {
//   List<OpportunitySummary>? opp;
//   List<CompanySummary>? company;
//
//   OpportunityDetails({this.company, this.opp});
//
//   OpportunityDetails.fromJson(Map<String, dynamic> json) {
//
//     if (json['opp'] != null) {
//       opp = <OpportunitySummary>[];
//       json['opp'].forEach((v) {
//         opp!.add(new OpportunitySummary.fromJson(v));
//       });
//     }
//
//     if (json['company'] != null) {
//       company = <OpportunityStage>[];
//       json['stages'].forEach((v) {
//         stages!.add(new OpportunityStage.fromJson(v));
//       });
//     }
//
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['opp'] = this.opp;
//     data['company'] = this.company;
//   }
// }

class OpportunitySummary {

  OpportunitySummary({
    this.opportunityName,
    this.opportunityId,
    this.userEmailId,
    this.stageName,
    this.closeDate,
    this.currency,
    // this.vertical,
    // this.productType,
    // this.closeReasonDescription,
    // this.closeReasons,
    // this.netGrossMargin,
    // this.geoLocation,
    // this.sourceType,
    // this.notes,
    // this.partners,
    // this.decisionMakers,
    // this.influencers,
    // this.competitor,
    // this.businessUnit,
    // this.solution,
    this.amount,});

  factory OpportunitySummary.fromJson(Map<String, dynamic> json) =>
      OpportunitySummary(
      opportunityName: json['opportunityName'],
      userEmailId: json['userEmailId'],
      stageName: json['stageName'],
      closeDate: json['closeDate'],
      amount: json['amount'],
      opportunityId: json['opportunityId'],
      currency: json['currency'],
      // vertical: json['vertical'],
      // productType: json['productType'],
      // closeReasonDescription: json['closeReasonDescription'],
      // closeReasons: json['closeReasons'],
      // netGrossMargin: json['netGrossMargin'],
      // geoLocation: json['geoLocation'],
      // sourceType: json['sourceType'],
      // notes: json['notes'],
      // partners: json['partners'],
      // decisionMakers: json['decisionMakers'],
      // influencers: json['influencers'],
      // competitor: json['competitor'],
      // businessUnit: json['businessUnit'],
      // solution: json['solution'],

    );

  String? opportunityId;
  String? opportunityName;
  String? userEmailId;
  String? stageName;
  String? closeDate;
  String? amount;
  String? currency;
  String? vertical;
  String? productType;
  String? closeReasonDescription;
  String? closeReasons;
  String? netGrossMargin;
  String? geoLocation;
  String? sourceType;
  String? notes;
  String? partners;
  String? decisionMakers;
  String? influencers;
  String? competitor;
  String? businessUnit;
  String? solution;

}

class OpportunityStage {

  OpportunityStage({
    this.name,
    this.amount,
    required this.selected,
    this.oppCount});

  factory OpportunityStage.fromJson(Map<String, dynamic> json) =>
      OpportunityStage(
        name: json['name'],
        oppCount: json['oppCount'],
        amount: json['amount'],
        selected: false
      );

  String? name;
  String? oppCount;
  String? amount;
  bool selected;

}

// class Company {
//
//   Company({
//     this.name,
//     this.amount,
//     this.oppCount});
//
//   factory Company.fromJson(Map<String, dynamic> json) =>
//       OpportunityStage(
//         name: json['name'],
//         oppCount: json['oppCount'],
//         amount: json['amount'],
//       );
//
//   String? name;
//   String? oppCount;
//   String? amount;
//
// }