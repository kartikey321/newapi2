import 'dart:async';
import 'dart:developer';

import 'dart:io';
import 'package:firedart/firedart.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:first_api/utis/constants.dart';

import '../../../createCallCollection/controller.dart';
import '../../../createCallCollection/models.dart';

var constant = Constants();

var mainres;

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
  ;
}

//fetch company id

Future<Response> fetchCompanyID(RequestContext context) async {
  //checking token
  // if (context.request.headers['authorization'].toString() !=
  //     constant.tokenformainapi.toString()) {
  //   return Response(statusCode: HttpStatus.forbidden);
  // }

  //start process

  final body = await context.request.json() as Map<String, dynamic>;
print(body.toString());
  constant.didNumber = body["call_to_number"] as String;
  constant.callerNumber = body["caller_id_number"].toString();

  constant.CIUD = body["call_id"] as String;
  constant.callStartStamp = body["start_stamp"] as String;

  await constant.db
      .collection("masterCollection")
      .document("didNumbers")
      .collection("didNumbers")
      .where("didNo", isEqualTo: constant.didNumber)
      .get()
      .then(
    (value) {
      constant.companyID = value[0]["companyId"] as String;
      constant.source =   constant.companyID = value[0]["distributedAt"] as String;
      // print(constant.companyID);
    },
  );

  return checkLeadExists(context);
}

// check lead exists or not

Future<Response> checkLeadExists(
  RequestContext context,
) async {
  await constant.db
      .collection("Companies")
      .document(constant.companyID!)
      .collection("leads")
      .where("personalDetails.mobileNo", isEqualTo: constant.callerNumber)
      .get()
      .then((value) async {
    if (value.toString() != "[]" && value[0]["owner"]["name"].toString()!="" )  {
      // this means lead exists and data is extracted and now goto emplyee collection to check weather employee is avaialbe or busy
      constant.empID = value[0]["owner"]["id"] as String;
      constant.empName = value[0]["owner"]["name"] as String;
      constant.empDesignation = value[0]["owner"]["designation"] as String;
      constant.baseID = value[0]["id"] as String;

      await constant.db
          .collection("Companies")
          .document(constant.companyID!)
          .collection("Employees")
          .document(constant.empID!)
          .get()
          .then((value2) {
        constant.empPhoneno = value2.map["phoneNo"] as String;

        constant.empStatus = value2.map["status"] as String;
        // now we have extracted the emp phone no and status for exisiting lead

        if (constant.empStatus == "available") {
          constant.agentNumbers.add(constant.empPhoneno);

          var resMap = [
            {
              "transfer": {"type": "number", "data": constant.agentNumbers}
            }
          ];

          //       CallRecord callrecord = CallRecord();
          //       CreateCallCollection callDetails = CreateCallCollection(
          //           companyID: constant.companyID,
          //           cuid: constant.CIUD,
          //           callerDid: constant.didNumber,
          //           callerNumber: constant.callerNumber,
          //           agentDid: "",
          //           callStartStamp: constant.callStartStamp,
          //           recordingLink: "",
          //           agentid: constant.empID,
          //           callStatus: "Started",
          //           callTranfer: false,
          //           callTransferIds: [],
          //           department: "Sales",
          //           isNewLeadCall: false,
          //           baseID: constant.baseID,
          //           isSmsSent: false,
          //           callDateTime: DateTime.now().toString(),
          //           advertisedNumber: false,
          //           callDirection: "inbound",
          //                 duration: "",
          // source: "Sales",
          // endStamp: "",
          // ivrId: "",
          // ivrName: "",);

          //       callrecord.addCallRecord(callDetails);
          print("Number provided to customer : " +
              constant.agentNumbers.toString());



          mainres = resMap;
          constant.agentNumbers = [];
        } else {
          print("agent is busy on another call provided to customer");
          CallRecord callrecord = CallRecord();
          CreateCallCollection callDetails = CreateCallCollection(
              companyID: constant.companyID,
              cuid: constant.CIUD,
              callerDid: constant.didNumber,
              callerNumber: constant.callerNumber,
              agentDid: "",
              callStartStamp: constant.callStartStamp,
              recordingLink: "",
              agentid: constant.empID,
              callStatus: "Ended By IVR",
              callTranfer: false,
              callTransferIds: [],
              department: "Sales",
              isNewLeadCall: false,
              baseID: constant.baseID,
              isSmsSent: false,
              callDateTime: DateTime.now().toString(),
              advertisedNumber: false,
              callDirection: "inbound",
              duration: "",
              source: constant.source,
              endStamp: "",
              ivrId: "11111",
              ivrName: "testivr",
              agentDesignation: constant.empDesignation,
              agentName: constant.empName,
              agentPhoneNo: constant.empPhoneno,
              callAnswerStamp: "",
              callEndStamp: "",
              currentCallStatus: "Ended",
              hangUpCause: "Agent Busy Ended By IVR",
              leadAssigned: false);

          callrecord.addCallRecord(callDetails);

          constant.agentNumbers.add("11111");

          // res = constant.agentNumbers;

          var resMap = [
            {
              "transfer": {"type": "ivr", "data": constant.agentNumbers}
            }
          ];
          mainres = resMap;
        }
      });
    } else {
      mainres = null;
    }
  });

  return leadNotExists(context);
}

// lead not exists

Future<Response> leadNotExists(RequestContext context) async {
  if (mainres != null) {
    return Response.json(body: mainres);
  }
  var resMap;

  {
    // if lead not exists fetch didnumbers under conversations and then telephony

    await constant.db
        .collection("Companies")
        .document(constant.companyID!)
        .collection("conversations")
        .document("telephony")
        .collection("telephony")
        .document(constant.didNumber!)
        .get()
        .then((value) async => {
              //after fetching details of did allocation we need to fetch all agents available for executing conditions like round robin or simantaneous for connecting to the non existing lead

              await constant.db
                  .collection("Companies")
                  .document(constant.companyID!)
                  .collection("conversations")
                  .document("telephony")
                  .collection("telephony")
                  .document("conditions")
                  .collection("conditions")
                  .document(value.map["departmentname"].toString() +
                      "," +
                      value.map["projectId"].toString())
                  .get()
                  .then((value2) async {
                if (value2["callingAlgorithm"].toString() == "ROUND_ROBIN") {
                  var agentNumbers;
                  for (int i = 0;
                      i < int.parse(value2.map["agents"].length.toString());
                      i++) {
                    await constant.db
                        .collection("Companies")
                        .document(constant.companyID!)
                        .collection("Employees")
                        .document(value2.map["agents"]["$i"]["id"].toString())
                        .get()
                        .then((value) {
                      if (value.map["status"].toString() == "available") {
                        constant.agentNumbers
                            .add(value.map["phoneNo"].toString());
                      }
                    });
                  }

                  if (constant.agentNumbers.length != 0) {
                    resMap = [
                      {
                        "transfer": {
                          "type": "number",
                          "ring_type": "order_by",
                          "data": constant.agentNumbers
                        }
                      }
                    ];
                  } else {
                    print("agent is busy on another call");
                    CallRecord callrecord = CallRecord();
                    CreateCallCollection callDetails = CreateCallCollection(
                        companyID: constant.companyID,
                        cuid: constant.CIUD,
                        callerDid: constant.didNumber,
                        callerNumber: constant.callerNumber,
                        agentDid: "",
                        callStartStamp: constant.callStartStamp,
                        recordingLink: "",
                        agentid: constant.empID,
                        callStatus: "Ended By IVR",
                        callTranfer: false,
                        callTransferIds: [],
                        department: "Sales",
                        isNewLeadCall: false,
                        baseID: constant.baseID,
                        isSmsSent: false,
                        callDateTime: DateTime.now().toString(),
                        advertisedNumber: false,
                        callDirection: "inbound",
                        duration: "",
                        source: constant.source,
                        endStamp: "",
                        ivrId: "11111",
                        ivrName: "testivr",
                        agentDesignation: constant.empDesignation,
                        agentName: constant.empName,
                        agentPhoneNo: constant.empPhoneno,
                        callAnswerStamp: "",
                        callEndStamp: "",
                        currentCallStatus: "Ended",
                        hangUpCause: "Agent Busy Ended By IVR");

                    callrecord.addCallRecord(callDetails);

                    constant.agentNumbers.add("11111");

                    // res = constant.agentNumbers;

                    resMap = [
                      {
                        "transfer": {
                          "type": "ivr",
                          "data": constant.agentNumbers
                        }
                      }
                    ];
                  }

                  mainres = resMap;
                  constant.agentNumbers = [];

                  /// swapping now as the condtion is roundrobin
                  CallRecord callrecord = CallRecord();
                  callrecord.updateAgentMap(
                      value2.map["agents"] as Map<String, dynamic>,
                      constant.companyID!,
                      value.map["departmentname"].toString() +
                          "," +
                          value.map["projectId"].toString());
                } else {
                  for (int i = 0;
                      i < int.parse(value2.map["agents"].length.toString());
                      i++) {
                    await constant.db
                        .collection("Companies")
                        .document(constant.companyID!)
                        .collection("Employees")
                        .document(value2.map["agents"]["$i"]["id"].toString())
                        .get()
                        .then((value) {
                      if (value.map["status"].toString() == "available") {
                        constant.agentNumbers
                            .add(value.map["phoneNo"].toString());
                        print(constant.agentNumbers.toString());
                      }
                    });
                  }

                  if (constant.agentNumbers.length != 0) {
                    resMap = [
                      {
                        "transfer": {
                          "type": "number",
                          "ring_type": "simantaneous",
                          "data": constant.agentNumbers
                        }
                      }
                    ];
                  } else {
                    print("agent is busy on another call");
                    CallRecord callrecord = CallRecord();
                    CreateCallCollection callDetails = CreateCallCollection(
                        companyID: constant.companyID,
                        cuid: constant.CIUD,
                        callerDid: constant.didNumber,
                        callerNumber: constant.callerNumber,
                        agentDid: "",
                        callStartStamp: constant.callStartStamp,
                        recordingLink: "",
                        agentid: constant.empID,
                        callStatus: "Ended By IVR",
                        callTranfer: false,
                        callTransferIds: [],
                        department: "Sales",
                        isNewLeadCall: false,
                        baseID: constant.baseID,
                        isSmsSent: false,
                        callDateTime: DateTime.now().toString(),
                        advertisedNumber: false,
                        callDirection: "inbound",
                        duration: "",
                        source: constant.source,
                        endStamp: "",
                        ivrId: "11111",
                        ivrName: "testivr",
                        agentDesignation: constant.empDesignation,
                        agentName: constant.empName,
                        agentPhoneNo: constant.empPhoneno,
                        callAnswerStamp: "",
                        callEndStamp: "",
                        currentCallStatus: "Ended",
                        hangUpCause: "Agent Busy Ended By IVR",
                        leadAssigned: false);

                    callrecord.addCallRecord(callDetails);

                    constant.agentNumbers.add("11111");

                    // res = constant.agentNumbers;

                    resMap = [
                      {
                        "transfer": {
                          "type": "ivr",
                          "data": constant.agentNumbers
                        }
                      }
                    ];
                  }

                  mainres = resMap;
                  constant.agentNumbers = [];
                }
              })
            });
  }
  return Response.json(body: mainres);
}
