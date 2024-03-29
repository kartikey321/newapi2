import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:first_api/utis/constants.dart';

import '../../../../createCallCollection/controller.dart';
import '../../../../createCallCollection/models.dart';
import '../../../../createLeads/controller.dart';
import '../../../../createLeads/leadModel.dart';
import '../../../../createLeads/leadOwnerModel.dart';
import '../../../../createLeads/leadPersonalDetailsModel.dart';

Constants constant = Constants();


Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  switch (context.request.method) {
    case HttpMethod.post:
      return fetchCompanyID(context);

    case HttpMethod.delete:
    case HttpMethod.get:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> fetchCompanyID(RequestContext context) async {
  //checking token
  if (context.request.headers['authorization'].toString() !=
      constant.tokenformainapi.toString()) {
    return Response(statusCode: HttpStatus.forbidden);
  }

  //start process

  final body = await context.request.json() as Map<String, dynamic>;
  print(body.toString());

  constant.CIUD = body["uuid"] as String;
  constant.didNumber = body["call_to_number"] as String;
  constant.callerNumber = body["customer_no_with_prefix "] as String;
  constant.callStartStamp = body["start_stamp"] as String;
    constant.callAnsweredStamp = body["answer_stamp"] as String;
    constant.callEndStamp=body["end_stamp"] as String;
        constant.hangUpCause = body["hangup_cause"] as String;
           constant.callDirection = body["direction"] as String;
           constant.callduration=body["duration"] as String;
             constant.answeredAgentNo = body["answered_agent_number"] as String;
            constant.recordingLink = body["recording_url"] as String;
               constant.callStatus = body["call_status"] as String;


  print(body.toString());
  await constant.db
      .collection("masterCollection")
      .document("didNumbers")
      .collection("didNumbers")
      .where("didNo", isEqualTo: constant.didNumber)
      .get()
      .then(
    (value) async {
      constant.companyID = value[0]["companyId"] as String;

      await constant.db
          .collection("Companies")
          .document(constant.companyID!)
          .collection("Employees")
          .where("phoneNo", isEqualTo: constant.answeredAgentNo)
          .get()
          .then((value2) {
        constant.empID = value2[0]["id"].toString();
        constant.empPhoneno = value2[0]["phoneNo"].toString();
        constant.empDesignation = value2[0]["designation"].toString();
        constant.empName = value2[0]["name"].toString();
      });
    },
  );

  return createLead(context);
}

Future<Response> createLead(RequestContext context) async {
  var leadId = DateTime.now().millisecondsSinceEpoch.toString();
  constant.baseID = leadId;

  LeadStatusType statusType = LeadStatusType();
  LeadPersonalDetails leadPersonalDetails = LeadPersonalDetails(
    name: "",
    mobileNo: constant.callerNumber!,
  );
  // LeadOwner leadOwnerData = LeadOwner(
  //     name: constant.empName!,
  //     id: constant.empID!,
  //     designation: constant.empDesignation!);

  Lead leadData = Lead(
      companyId: constant.companyID,
      id: leadId,
      source: "Newspaper",
      status: "Fresh",
      subStatus: "",
      hotLead: false,
      createdOn: DateTime.now(),
      leadStatusType: LeadStatusType.FRESH,
      personalDetails: leadPersonalDetails,
      subsource: "",
      );

  LeadsSection leadsSection = LeadsSection();



await constant.db
      .collection("Companies")
      .document(constant.companyID!)
      .collection("leads")
      .where("personalDetails.mobileNo", isEqualTo: constant.callerNumber)
      .get()
      .then(
    (value) async {
      if (value.toString() == "[]") {

constant.isNewLeadCall=true;
  leadsSection.addLead(leadData);

      }});


  return createCallDetails(context);
}

Future<Response> createCallDetails(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;

  CallRecord callrecord = CallRecord();

  CreateCallCollection callDetails = CreateCallCollection(
      companyID: constant.companyID,
      duration: constant.callduration,
      source: "Sales",
      endStamp: constant.callEndStamp,
      ivrId: "",
      ivrName: "",
      agentPhoneNo: constant.empPhoneno,
      agentName: constant.empName,
      agentDesignation: constant.empDesignation,
      cuid: constant.CIUD,
      callerDid: constant.didNumber,
      callerNumber: constant.callerNumber,
      agentDid: constant.didNumber,
      callStartStamp: constant.callStartStamp,
      callAnswerStamp: constant.callAnsweredStamp,
      callEndStamp: constant.callEndStamp,
      hangUpCause: constant.hangUpCause,
      recordingLink: constant.recordingLink,
      agentid: constant.empID,
      callStatus: constant.callStatus,
      callTranfer: false,
      callTransferIds: [],
      department: "Sales",
      isNewLeadCall: constant.isNewLeadCall,
      baseID: constant.baseID,
      isSmsSent: false,
      callDateTime: DateTime.now().toString(),
      advertisedNumber: false,
      callDirection:constant.callDirection,
      currentCallStatus: "Ended");


      
if(constant.callStatus=="answered")
{
  callrecord.updateCallRecord(callDetails);
} else {

   callrecord.addCallRecord(callDetails);
}

  return Response.json(body: "done");
}
