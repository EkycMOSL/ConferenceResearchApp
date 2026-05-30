import 'package:conferance_application/data/models/dashboard/corporate_response_model.dart';
import 'package:conferance_application/data/models/dashboard/dashboard_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int selectedDayIndex;
  final List<String> days;
  final List<TimeSlot> timeSlots;
  final int selectedBottomIndex;
  final List<AGICMeeting> agicMeetings;
  final List<CorporateAGICMeeting> corporateMeetings;
  final List<CorporateSlot> corporateSlots;
  final String clientCode;

  const DashboardLoaded({
    required this.selectedDayIndex,
    required this.days,
    required this.timeSlots,
    required this.selectedBottomIndex,
    required this.agicMeetings,
    required this.clientCode,
    this.corporateMeetings = const [],
    this.corporateSlots = const [],
  });

  @override
  List<Object?> get props => [selectedDayIndex, days, timeSlots, selectedBottomIndex, agicMeetings, corporateMeetings, corporateSlots, clientCode];

  DashboardLoaded copyWith({
    int? selectedDayIndex,
    List<String>? days,
    List<TimeSlot>? timeSlots,
    int? selectedBottomIndex,
    List<AGICMeeting>? agicMeetings,
    List<CorporateAGICMeeting>? corporateMeetings,
    List<CorporateSlot>? corporateSlots,
    String? clientCode,
  }) {
    return DashboardLoaded(
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      days: days ?? this.days,
      timeSlots: timeSlots ?? this.timeSlots,
      selectedBottomIndex: selectedBottomIndex ?? this.selectedBottomIndex,
      agicMeetings: agicMeetings ?? this.agicMeetings,
      corporateMeetings: corporateMeetings ?? this.corporateMeetings,
      corporateSlots: corporateSlots ?? this.corporateSlots,
      clientCode: clientCode ?? this.clientCode,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class CorporateSlot extends Equatable {
  final String corporateName;
  final bool isExpanded;
  final List<CorporateTimeSlot> timeSlots;

  const CorporateSlot({
    required this.corporateName,
    required this.timeSlots,
    this.isExpanded = false,
  });

  @override
  List<Object?> get props => [corporateName, isExpanded, timeSlots];

  CorporateSlot copyWith({String? corporateName, bool? isExpanded, List<CorporateTimeSlot>? timeSlots}) {
    return CorporateSlot(
      corporateName: corporateName ?? this.corporateName,
      isExpanded: isExpanded ?? this.isExpanded,
      timeSlots: timeSlots ?? this.timeSlots,
    );
  }
}

class CorporateTimeSlot extends Equatable {
  final String time;
  final List<CorporateMeetingEntry> entries;

  const CorporateTimeSlot({required this.time, required this.entries});

  @override
  List<Object?> get props => [time, entries];

  CorporateTimeSlot copyWith({String? time, List<CorporateMeetingEntry>? entries}) {
    return CorporateTimeSlot(
      time: time ?? this.time,
      entries: entries ?? this.entries,
    );
  }
}

class CorporateMeetingEntry extends Equatable {
  final String roomNo;
  final String contactPerson;
  final int attendeeCount;
  final String natureOfMeeting;
  final List<FundGroup> fundGroups;
  final List<RepresentativeModel> allReps;
  final bool isRepsExpanded;

  const CorporateMeetingEntry({
    required this.roomNo,
    required this.contactPerson,
    required this.attendeeCount,
    this.natureOfMeeting = '',
    this.fundGroups = const [],
    this.allReps = const [],
    this.isRepsExpanded = false,
  });

  CorporateMeetingEntry copyWith({
    String? roomNo,
    String? contactPerson,
    int? attendeeCount,
    String? natureOfMeeting,
    List<FundGroup>? fundGroups,
    List<RepresentativeModel>? allReps,
    bool? isRepsExpanded,
  }) {
    return CorporateMeetingEntry(
      roomNo: roomNo ?? this.roomNo,
      contactPerson: contactPerson ?? this.contactPerson,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      natureOfMeeting: natureOfMeeting ?? this.natureOfMeeting,
      fundGroups: fundGroups ?? this.fundGroups,
      allReps: allReps ?? this.allReps,
      isRepsExpanded: isRepsExpanded ?? this.isRepsExpanded,
    );
  }

  @override
  List<Object?> get props => [roomNo, contactPerson, attendeeCount, natureOfMeeting, fundGroups, allReps, isRepsExpanded];
}

class TimeSlot extends Equatable {
  final String time;
  final bool isExpanded;
  final List<Meeting> meetings;

  const TimeSlot({
    required this.time,
    this.isExpanded = false,
    this.meetings = const [],
  });

  @override
  List<Object?> get props => [time, isExpanded, meetings];

  TimeSlot copyWith({
    String? time,
    bool? isExpanded,
    List<Meeting>? meetings,
  }) {
    return TimeSlot(
      time: time ?? this.time,
      isExpanded: isExpanded ?? this.isExpanded,
      meetings: meetings ?? this.meetings,
    );
  }
}

class FundGroup extends Equatable {
  final String fundName;
  final List<String> clientNames;
  final List<RepresentativeModel> reps;

  const FundGroup({
    required this.fundName,
    required this.clientNames,
    this.reps = const [],
  });

  @override
  List<Object?> get props => [fundName, clientNames, reps];
}

class Meeting extends Equatable {
  final String companyName;
  final String contactPerson;
  final String roomNo;
  final int attendeeCount;
  final String natureOfMeeting;
  final List<FundGroup> fundGroups;
  final List<RepresentativeModel> allReps;
  final bool isRepsExpanded;

  const Meeting({
    required this.companyName,
    required this.contactPerson,
    required this.roomNo,
    required this.attendeeCount,
    this.natureOfMeeting = '',
    this.fundGroups = const [],
    this.allReps = const [],
    this.isRepsExpanded = false,
  });

  Meeting copyWith({
    String? companyName,
    String? contactPerson,
    String? roomNo,
    int? attendeeCount,
    String? natureOfMeeting,
    List<FundGroup>? fundGroups,
    List<RepresentativeModel>? allReps,
    bool? isRepsExpanded,
  }) {
    return Meeting(
      companyName: companyName ?? this.companyName,
      contactPerson: contactPerson ?? this.contactPerson,
      roomNo: roomNo ?? this.roomNo,
      attendeeCount: attendeeCount ?? this.attendeeCount,
      natureOfMeeting: natureOfMeeting ?? this.natureOfMeeting,
      fundGroups: fundGroups ?? this.fundGroups,
      allReps: allReps ?? this.allReps,
      isRepsExpanded: isRepsExpanded ?? this.isRepsExpanded,
    );
  }

  @override
  List<Object?> get props => [companyName, contactPerson, roomNo, attendeeCount, natureOfMeeting, fundGroups, allReps, isRepsExpanded];
}