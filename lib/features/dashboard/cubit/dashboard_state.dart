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

  const DashboardLoaded({
    required this.selectedDayIndex,
    required this.days,
    required this.timeSlots,
    required this.selectedBottomIndex,
  });

  @override
  List<Object?> get props => [selectedDayIndex, days, timeSlots, selectedBottomIndex];

  DashboardLoaded copyWith({
    int? selectedDayIndex,
    List<String>? days,
    List<TimeSlot>? timeSlots,
    int? selectedBottomIndex,
  }) {
    return DashboardLoaded(
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      days: days ?? this.days,
      timeSlots: timeSlots ?? this.timeSlots,
      selectedBottomIndex: selectedBottomIndex ?? this.selectedBottomIndex,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
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

class Meeting extends Equatable {
  final String companyName;
  final String contactPerson;
  final String roomNo;
  final List<String> attendees;
  final int attendeeCount;

  const Meeting({
    required this.companyName,
    required this.contactPerson,
    required this.roomNo,
    required this.attendees,
    required this.attendeeCount,
  });

  @override
  List<Object?> get props => [companyName, contactPerson, roomNo, attendees, attendeeCount];
}