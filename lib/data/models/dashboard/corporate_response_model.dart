import 'package:conferance_application/data/models/dashboard/dashboard_response_model.dart';

class CorporateResponseModel {
  final bool response;
  final String message;
  final CorporateData? data;

  const CorporateResponseModel({
    required this.response,
    required this.message,
    this.data,
  });

  factory CorporateResponseModel.fromJson(Map<String, dynamic> json) {
    return CorporateResponseModel(
      response: json['Response']?.toString().toLowerCase() == 'true',
      message: json['Message'] ?? '',
      data: json['Data'] != null ? CorporateData.fromJson(json['Data']) : null,
    );
  }
}

class CorporateData {
  final List<CorporateAGICMeeting> agicMeetings;

  const CorporateData({required this.agicMeetings});

  factory CorporateData.fromJson(Map<String, dynamic> json) {
    final list = json['AGICMeeting'] as List<dynamic>? ?? [];
    return CorporateData(
      agicMeetings: list.map((e) => CorporateAGICMeeting.fromJson(e)).toList(),
    );
  }
}

class CorporateAGICMeeting {
  final String meetingDay;
  final List<CorporateItem> corporateList;

  const CorporateAGICMeeting({
    required this.meetingDay,
    required this.corporateList,
  });

  factory CorporateAGICMeeting.fromJson(Map<String, dynamic> json) {
    final list = json['CorporateList'] as List<dynamic>? ?? [];
    return CorporateAGICMeeting(
      meetingDay: json['MeetingDay'] ?? '',
      corporateList: list.map((e) => CorporateItem.fromJson(e)).toList(),
    );
  }
}

class CorporateItem {
  final String corporateName;
  final List<CorporateMeetingSlot> meetingSlots;

  const CorporateItem({
    required this.corporateName,
    required this.meetingSlots,
  });

  factory CorporateItem.fromJson(Map<String, dynamic> json) {
    final slots = json['MeetingSlot'] as List<dynamic>? ?? [];
    return CorporateItem(
      corporateName: json['CorporateName'] ?? '',
      meetingSlots: slots.map((e) => CorporateMeetingSlot.fromJson(e)).toList(),
    );
  }
}

class CorporateMeetingSlot {
  final String meetingSlotTime;
  final List<MeetingItem> meetings;

  const CorporateMeetingSlot({
    required this.meetingSlotTime,
    required this.meetings,
  });

  factory CorporateMeetingSlot.fromJson(Map<String, dynamic> json) {
    final meetings = json['Meeting'] as List<dynamic>? ?? [];
    return CorporateMeetingSlot(
      meetingSlotTime: json['MeetingSlotTime'] ?? '',
      meetings: meetings.map((e) => MeetingItem.fromJson(e)).toList(),
    );
  }
}
