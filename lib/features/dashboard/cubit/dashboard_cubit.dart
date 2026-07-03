import 'package:conferance_application/data/models/dashboard/corporate_response_model.dart';
import 'package:conferance_application/data/models/dashboard/dashboard_response_model.dart';
import 'package:conferance_application/domain/api_state.dart';
import 'package:conferance_application/domain/respository/dashboard_repository.dart';
import 'package:conferance_application/utils/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository = locator<DashboardRepository>();

  DashboardCubit() : super(DashboardInitial());

  void loadFromModel(DashboardResponseModel responseModel, {String clientCode = ''}) {
    if (responseModel.data == null) {
      emit(const DashboardError('No data available'));
      return;
    }
    final agicMeetings = responseModel.data!.agicMeetings;
    final days = agicMeetings.map((e) => e.meetingDay.toUpperCase()).toList();
    emit(DashboardLoaded(
      selectedDayIndex: 0,
      days: days,
      timeSlots: _buildTimeSlotsForDay(agicMeetings, 0),
      selectedBottomIndex: 0,
      agicMeetings: agicMeetings,
      clientCode: clientCode,
    ));
  }

  Future<void> loadDashboard({String clientCode = '22894'}) async {
    emit(DashboardLoading());
    try {
      final result = await _repository.getDashboardData(clientCode: clientCode);
      if (result is DataSuccess) {
        final responseModel = DashboardResponseModel.fromJson(
          Map<String, dynamic>.from(result.data as Map),
        );
        if (!responseModel.response || responseModel.data == null) {
          emit(DashboardError(responseModel.message.isNotEmpty ? responseModel.message : 'No data available'));
          return;
        }
        final agicMeetings = responseModel.data!.agicMeetings;
        emit(DashboardLoaded(
          selectedDayIndex: 0,
          days: agicMeetings.map((e) => e.meetingDay.toUpperCase()).toList(),
          timeSlots: _buildTimeSlotsForDay(agicMeetings, 0),
          selectedBottomIndex: 0,
          agicMeetings: agicMeetings,
          clientCode: clientCode,
        ));
      } else {
        emit(DashboardError((result as DataError).errorMessage ?? 'Failed to load dashboard'));
      }
    } catch (e) {
      emit(DashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  Future<void> loadCorporateWiseData() async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    emit(currentState.copyWith(selectedBottomIndex: 1));
    try {
      final result = await _repository.getCorporateWiseData(clientCode: currentState.clientCode);
      if (result is DataSuccess) {
        final responseModel = CorporateResponseModel.fromJson(
          Map<String, dynamic>.from(result.data as Map),
        );
        if (!responseModel.response || responseModel.data == null) {
          emit(currentState.copyWith(selectedBottomIndex: 1, corporateMeetings: [], corporateSlots: []));
          return;
        }
        final corporateMeetings = responseModel.data!.agicMeetings;
        final corporateSlots = _buildCorporateSlotsForDay(corporateMeetings, 0);
        emit(currentState.copyWith(
          selectedBottomIndex: 1,
          corporateMeetings: corporateMeetings,
          corporateSlots: corporateSlots,
          selectedDayIndex: 0,
        ));
      }
    } catch (_) {}
  }

  List<CorporateSlot> _buildCorporateSlotsForDay(List<CorporateAGICMeeting> meetings, int dayIndex) {
    if (dayIndex >= meetings.length) return [];
    return meetings[dayIndex].corporateList.map((c) {
      final timeSlots = c.meetingSlots.map((slot) {
        return CorporateTimeSlot(
          time: slot.meetingSlotTime,
          entries: _buildCorporateEntries(slot.meetings),
        );
      }).toList();
      return CorporateSlot(corporateName: c.corporateName, timeSlots: timeSlots);
    }).toList();
  }

  List<CorporateMeetingEntry> _buildCorporateEntries(List<MeetingItem> items) {
    if (items.isEmpty) return [];
    final first = items.first;
    final reps = first.reps;

    final Map<String, List<MeetingItem>> byFund = {};
    for (final item in items) {
      byFund.putIfAbsent(item.fundName, () => []).add(item);
    }
    final fundGroups = byFund.entries.map((e) => FundGroup(
      fundName: e.key,
      clientNames: e.value.map((i) => i.clientName).toList(),
      attendedFlags: e.value.map((i) => i.isAttended).toList(),
      reps: e.value.first.reps,
    )).toList();

    return [
      CorporateMeetingEntry(
        roomNo: first.roomNo,
        contactPerson: reps.isNotEmpty ? reps.first.name : '',
        attendeeCount: reps.length - 1,
        natureOfMeeting: first.natureOfMeeting,
        fundGroups: fundGroups,
        allReps: reps,
      ),
    ];
  }

  List<TimeSlot> _buildTimeSlotsForDay(List<AGICMeeting> agicMeetings, int dayIndex) {
    if (dayIndex >= agicMeetings.length) return [];
    return agicMeetings[dayIndex].meetingSlots.map((slot) {
      return TimeSlot(
        time: slot.meetingSlotTime,
        meetings: _groupMeetingsByCompany(slot.meetings),
      );
    }).toList();
  }

  List<Meeting> _groupMeetingsByCompany(List<MeetingItem> items) {
    final Map<String, List<MeetingItem>> byCompany = {};
    for (final item in items) {
      byCompany.putIfAbsent(item.companyName, () => []).add(item);
    }
    return byCompany.entries.map((entry) {
      final companyItems = entry.value;
      final first = companyItems.first;

      // Group by fund name within this company
      final Map<String, List<MeetingItem>> byFund = {};
      for (final item in companyItems) {
        byFund.putIfAbsent(item.fundName, () => []).add(item);
      }

      final fundGroups = byFund.entries.map((fundEntry) {
        return FundGroup(
          fundName: fundEntry.key,
          clientNames: fundEntry.value.map((e) => e.clientName).toList(),
          reps: fundEntry.value.first.reps,
        );
      }).toList();

      // Representatives are same for all items in the company, use first item's reps
      final reps = first.reps;
      final firstRepName = reps.isNotEmpty ? reps.first.name : '';
      final extraRepCount = reps.length - 1;

      return Meeting(
        companyName: first.companyName,
        contactPerson: firstRepName,
        roomNo: first.roomNo,
        attendeeCount: extraRepCount,
        natureOfMeeting: first.natureOfMeeting,
        fundGroups: fundGroups,
        allReps: reps,
      );
    }).toList();
  }

  void selectDay(int index) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    if (currentState.selectedBottomIndex == 0) {
      emit(currentState.copyWith(
        selectedDayIndex: index,
        timeSlots: _buildTimeSlotsForDay(currentState.agicMeetings, index),
      ));
    } else {
      emit(currentState.copyWith(
        selectedDayIndex: index,
        corporateSlots: _buildCorporateSlotsForDay(currentState.corporateMeetings, index),
      ));
    }
  }

  void selectBottomTab(int index) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    if (index == 1 && currentState.corporateMeetings.isEmpty) {
      loadCorporateWiseData();
    } else {
      emit(currentState.copyWith(selectedBottomIndex: index, selectedDayIndex: 0));
    }
  }

  void toggleMeetingReps(int slotIndex, int meetingIndex) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    final updatedSlots = List<TimeSlot>.from(currentState.timeSlots);
    final updatedMeetings = List<Meeting>.from(updatedSlots[slotIndex].meetings);
    final meeting = updatedMeetings[meetingIndex];
    updatedMeetings[meetingIndex] = meeting.copyWith(isRepsExpanded: !meeting.isRepsExpanded);
    updatedSlots[slotIndex] = updatedSlots[slotIndex].copyWith(meetings: updatedMeetings);
    emit(currentState.copyWith(timeSlots: updatedSlots));
  }

  void toggleTimeSlot(int index) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    final updatedSlots = List<TimeSlot>.from(currentState.timeSlots);
    updatedSlots[index] = updatedSlots[index].copyWith(isExpanded: !updatedSlots[index].isExpanded);
    emit(currentState.copyWith(timeSlots: updatedSlots));
  }

  void toggleCorporateMeetingReps(int slotIndex, int timeSlotIndex, int entryIndex) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    final updatedSlots = List<CorporateSlot>.from(currentState.corporateSlots);
    final updatedTimeSlots = List<CorporateTimeSlot>.from(updatedSlots[slotIndex].timeSlots);
    final updatedEntries = List<CorporateMeetingEntry>.from(updatedTimeSlots[timeSlotIndex].entries);
    final entry = updatedEntries[entryIndex];
    updatedEntries[entryIndex] = entry.copyWith(isRepsExpanded: !entry.isRepsExpanded);
    updatedTimeSlots[timeSlotIndex] = updatedTimeSlots[timeSlotIndex].copyWith(entries: updatedEntries);
    updatedSlots[slotIndex] = updatedSlots[slotIndex].copyWith(timeSlots: updatedTimeSlots);
    emit(currentState.copyWith(corporateSlots: updatedSlots));
  }

  void toggleCorporateSlot(int index) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    final updated = List<CorporateSlot>.from(currentState.corporateSlots);
    updated[index] = updated[index].copyWith(isExpanded: !updated[index].isExpanded);
    emit(currentState.copyWith(corporateSlots: updated));
  }

  Future<void> refreshData() async {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    if (currentState.selectedBottomIndex == 0) {
      final result = await _repository.getDashboardData(clientCode: currentState.clientCode);
      if (result is DataSuccess) {
        final responseModel = DashboardResponseModel.fromJson(
          Map<String, dynamic>.from(result.data as Map),
        );
        if (responseModel.response && responseModel.data != null) {
          final agicMeetings = responseModel.data!.agicMeetings;
          emit(currentState.copyWith(
            agicMeetings: agicMeetings,
            timeSlots: _buildTimeSlotsForDay(agicMeetings, currentState.selectedDayIndex),
          ));
        }
      }
    } else {
      final result = await _repository.getCorporateWiseData(clientCode: currentState.clientCode);
      if (result is DataSuccess) {
        final responseModel = CorporateResponseModel.fromJson(
          Map<String, dynamic>.from(result.data as Map),
        );
        if (responseModel.response && responseModel.data != null) {
          final corporateMeetings = responseModel.data!.agicMeetings;
          emit(currentState.copyWith(
            corporateMeetings: corporateMeetings,
            corporateSlots: _buildCorporateSlotsForDay(corporateMeetings, currentState.selectedDayIndex),
          ));
        }
      }
    }
  }

  void refreshDashboard() => loadDashboard();
}