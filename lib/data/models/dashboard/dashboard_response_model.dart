class DashboardResponseModel {
  final bool response;
  final String message;
  final DashboardData? data;

  const DashboardResponseModel({
    required this.response,
    required this.message,
    this.data,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      response: json['Response']?.toString().toLowerCase() == 'true',
      message: json['Message'] ?? '',
      data: json['Data'] != null ? DashboardData.fromJson(json['Data']) : null,
    );
  }
}

class DashboardData {
  final List<AGICMeeting> agicMeetings;

  const DashboardData({required this.agicMeetings});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final list = json['AGICMeeting'] as List<dynamic>? ?? [];
    return DashboardData(
      agicMeetings: list.map((e) => AGICMeeting.fromJson(e)).toList(),
    );
  }
}

class AGICMeeting {
  final String meetingDay;
  final List<MeetingSlot> meetingSlots;

  const AGICMeeting({
    required this.meetingDay,
    required this.meetingSlots,
  });

  factory AGICMeeting.fromJson(Map<String, dynamic> json) {
    final slots = json['MeetingSlot'] as List<dynamic>? ?? [];
    return AGICMeeting(
      meetingDay: json['MeetingDay'] ?? '',
      meetingSlots: slots.map((e) => MeetingSlot.fromJson(e)).toList(),
    );
  }
}

class MeetingSlot {
  final String meetingSlotTime;
  final List<MeetingItem> meetings;

  const MeetingSlot({
    required this.meetingSlotTime,
    required this.meetings,
  });

  factory MeetingSlot.fromJson(Map<String, dynamic> json) {
    final meetings = json['Meeting'] as List<dynamic>? ?? [];
    return MeetingSlot(
      meetingSlotTime: json['MeetingSlotTime'] ?? '',
      meetings: meetings.map((e) => MeetingItem.fromJson(e)).toList(),
    );
  }
}

class MeetingItem {
  final String empCode;
  final String? name;
  final int fundId;
  final String fundName;
  final int clientId;
  final String clientName;
  final String companyName;
  final String roomNo;
  final String contactName1;
  final String contactName2;
  final String startTime;
  final String natureOfMeeting;
  final List<RepresentativeModel> reps;
  final String meetingLastModified;
  final bool isAttended;

  const MeetingItem({
    required this.empCode,
    this.name,
    required this.fundId,
    required this.fundName,
    required this.clientId,
    required this.clientName,
    required this.companyName,
    required this.roomNo,
    required this.contactName1,
    required this.contactName2,
    required this.startTime,
    required this.natureOfMeeting,
    required this.reps,
    required this.meetingLastModified,
    required this.isAttended,
  });

  factory MeetingItem.fromJson(Map<String, dynamic> json) {
    final repList = json['rep'] as List<dynamic>? ?? [];
    return MeetingItem(
      empCode: json['Empcode'] ?? '',
      name: json['Name'],
      fundId: json['fund_id'] ?? 0,
      fundName: json['fund_name'] ?? '',
      clientId: json['client_id'] ?? 0,
      clientName: json['client_name'] ?? '',
      companyName: json['company_name'] ?? '',
      roomNo: json['room_no'] ?? '',
      contactName1: json['contact_name1'] ?? '',
      contactName2: json['contact_name2'] ?? '',
      startTime: json['start_time'] ?? '',
      natureOfMeeting: json['Nature_of_meeting'] ?? '',
      reps: repList.map((e) => RepresentativeModel.fromJson(e)).toList(),
      meetingLastModified: json['MeetingLastModified'] ?? '',
      isAttended: json['IsAttended'] == true || json['IsAttended']?.toString().toLowerCase() == 'true'
    );
  }
}

class RepresentativeModel {
  final String name;
  final String designation;

  const RepresentativeModel({
    required this.name,
    required this.designation,
  });

  factory RepresentativeModel.fromJson(Map<String, dynamic> json) {
    return RepresentativeModel(
      name: json['NAME'] ?? '',
      designation: json['DESIGNATION'] ?? '',
    );
  }
}
