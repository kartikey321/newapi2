// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';



import 'leadOwnerModel.dart';
import 'leadPersonalDetailsModel.dart';

class LeadStatusType {
  static const String UNALLOCATED = 'Unallocated';
  static const String IN_CALL_CENTER = 'In Call-Center';

  static const String FRESH = 'Fresh';
  static const String INTERESTED = 'Interested';
  static const String MEETING_DONE = 'Meeting Done';
  static const String SITE_VISIT_SCHEDULED = 'Site Visit Scheduled';
  static const String SITE_VISIT_DONE = 'Site Visit Done';
  static const String NEGOTIATION = 'Negotiation';
  static const String EOI = 'EOI';
  static const String FAILED = 'Failed';
  static const String JUNK = 'Junk';

  static List<String> get allTypes => [
        UNALLOCATED,
        IN_CALL_CENTER,
        FRESH,
        INTERESTED,
        MEETING_DONE,
        SITE_VISIT_SCHEDULED,
        SITE_VISIT_DONE,
        NEGOTIATION,
        EOI,
        FAILED,
        JUNK
      ];
}

class Lead {
  String? companyId;
  String id;
  // List<Project>? projects;
  String source;
  LeadOwner? owner;
  
  // List<LeadOwner>? coOwners;
  String? subsource;
  String status;
  String subStatus;
  LeadPersonalDetails personalDetails;
  String? purposeOfPurchase;
  List<String>? interestedPropertyTypes;
  String? possession;
  double? startBudget;
  double? endBudget;
  bool? firstProperty;
  String? note;
  bool hotLead;
  DateTime createdOn;
  String leadStatusType;

  Lead({
    required this.companyId,
    required this.id,
    // required this.projects,
    required this.source,
    this.owner,
    // this.coOwners,
    this.subsource,
    required this.status,
    required this.subStatus,
    required this.personalDetails,
    this.purposeOfPurchase,
    this.interestedPropertyTypes,
    this.possession,
    this.startBudget,
    this.endBudget,
    this.firstProperty,
    this.note,
    required this.hotLead,
    required this.createdOn,
    required this.leadStatusType,
  });

  Lead copyWith({
  
  String? companyId,
    String? id,
  
    // List<Project>? projects,
    String? source,
    LeadOwner? owner,
    // List<LeadOwner>? coOwners,
    String? subsource,
    String? status,
    String? subStatus,
    LeadPersonalDetails? personalDetails,
    String? purposeOfPurchase,
    List<String>? interestedPropertyTypes,
    String? possession,
    double? startBudget,
    double? endBudget,
    bool? firstProperty,
    String? note,
    bool? hotLead,
    DateTime? createdOn,
    String? leadStatusType,
  }) {
    return Lead(
      companyId: companyId?? this.companyId,
      id: id ?? this.id,
      // projects: projects ?? this.projects,
      source: source ?? this.source,
      owner: owner ?? this.owner,
      // coOwners: coOwners ?? this.coOwners,
      subsource: subsource ?? this.subsource,
      status: status ?? this.status,
      subStatus: subStatus ?? this.subStatus,
      personalDetails: personalDetails ?? this.personalDetails,
      purposeOfPurchase: purposeOfPurchase ?? this.purposeOfPurchase,
      interestedPropertyTypes:
          interestedPropertyTypes ?? this.interestedPropertyTypes,
      possession: possession ?? this.possession,
      startBudget: startBudget ?? this.startBudget,
      endBudget: endBudget ?? this.endBudget,
      firstProperty: firstProperty ?? this.firstProperty,
      note: note ?? this.note,
      hotLead: hotLead ?? this.hotLead,
      createdOn: createdOn ?? this.createdOn,
      leadStatusType: leadStatusType ?? this.leadStatusType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'companyiId': companyId,
      'id': id,
      // 'projects': projects?.map((x) => x.toMap()).toList(),
      'source': source,
      'owner': owner?.toMap(),
      // 'coOwners': coOwners?.map((x) => x.toMap()).toList(),
      'subsource': subsource,
      'status': status,
      'subStatus': subStatus,
      'personalDetails': personalDetails.toMap(),
      'purposeOfPurchase': purposeOfPurchase,
      'interestedPropertyTypes': interestedPropertyTypes,
      'possession': possession,
      'startBudget': startBudget,
      'endBudget': endBudget,
      'firstProperty': firstProperty,
      'note': note,
      'hotLead': hotLead,
      'createdOn': createdOn.toIso8601String(),
      'leadStatusType': leadStatusType,
    };
  }

  factory Lead.fromMap(map) {
    return Lead(
      companyId: map['companyId'] as String,
      id: map['id'] as String,
      // projects: List<Project>.from(
      //     map['projects']?.map((x) => Project.fromMap(x)) ?? const []),
      source: map['source'] as String,
      owner: map['owner'] != null
          ? LeadOwner.fromMap(map['owner'] as Map<String, dynamic>)
          : null,
      // coOwners: List<LeadOwner>.from(
      //     map['coOwners']?.map((x) => LeadOwner.fromMap(x)) ?? const []),
      subsource: map['subsource'] != null ? map['subsource'] as String : null,
      status: map['status'] as String,
      subStatus: map['subStatus'] as String,
      personalDetails: LeadPersonalDetails.fromMap(
          map['personalDetails'] as Map<String, dynamic>),
      purposeOfPurchase: map['purposeOfPurchase'] != null
          ? map['purposeOfPurchase'] as String
          : null,
      interestedPropertyTypes: map['interestedPropertyTypes'] != null
          ? List<String>.from(map['interestedPropertyTypes'] as List<dynamic>)
          : null,
      possession:
          map['possession'] != null ? map['possession'] as String : null,
      startBudget:
          map['startBudget'] != null ? map['startBudget'] as double : null,
      endBudget: map['endBudget'] != null ? map['endBudget'] as double : null,
      firstProperty:
          map['firstProperty'] != null ? map['firstProperty'] as bool : null,
      note: map['note'] != null ? map['note'] as String : null,
      hotLead: map['hotLead'] as bool,
      createdOn: DateTime.parse(map['createdOn'] as String),
      leadStatusType: map['leadStatusType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lead.fromJson(String source) =>
      Lead.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Lead(compnayId: $companyId,id: $id, source: $source, owner: $owner,subsource: $subsource, status: $status, subStatus: $subStatus, personalDetails: $personalDetails, purposeOfPurchase: $purposeOfPurchase, interestedPropertyTypes: $interestedPropertyTypes, possession: $possession, startBudget: $startBudget, endBudget: $endBudget, firstProperty: $firstProperty, note: $note, hotLead: $hotLead, createdOn: $createdOn, leadStatusType: $leadStatusType)';
  }

  @override
  bool operator ==(covariant Lead other) {
    if (identical(this, other)) return true;

    return other.companyId== companyId &&
     other.id == id &&
        // other.projects == projects &&
        other.source == source &&
        other.owner == owner &&
        // other.coOwners == coOwners &&
        other.subsource == subsource &&
        other.status == status &&
        other.subStatus == subStatus &&
        other.personalDetails == personalDetails &&
        other.purposeOfPurchase == purposeOfPurchase &&
        other.interestedPropertyTypes == interestedPropertyTypes &&
        other.possession == possession &&
        other.startBudget == startBudget &&
        other.endBudget == endBudget &&
        other.firstProperty == firstProperty &&
        other.note == note &&
        other.hotLead == hotLead &&
        other.createdOn == createdOn &&
        other.leadStatusType == leadStatusType;
  }

  @override
  int get hashCode {
    return companyId.hashCode ^ 
    id.hashCode ^
        // projects.hashCode ^
        source.hashCode ^
        owner.hashCode ^
        // coOwners.hashCode ^
        subsource.hashCode ^
        status.hashCode ^
        subStatus.hashCode ^
        personalDetails.hashCode ^
        purposeOfPurchase.hashCode ^
        interestedPropertyTypes.hashCode ^
        possession.hashCode ^
        startBudget.hashCode ^
        endBudget.hashCode ^
        firstProperty.hashCode ^
        note.hashCode ^
        hotLead.hashCode ^
        createdOn.hashCode ^
        leadStatusType.hashCode;
  }
}


