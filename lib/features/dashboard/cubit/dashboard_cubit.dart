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
    return meetings[dayIndex].corporateList
        .map((c) => CorporateSlot(corporateName: c.corporateName, slots: c.meetingSlots))
        .toList();
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
    final Map<String, List<MeetingItem>> grouped = {};
    for (final item in items) {
      grouped.putIfAbsent(item.companyName, () => []).add(item);
    }
    return grouped.entries.map((entry) {
      final first = entry.value.first;
      return Meeting(
        companyName: first.companyName,
        contactPerson: first.contactName1,
        roomNo: first.roomNo,
        attendees: entry.value.map((e) => e.clientName).toList(),
        attendeeCount: entry.value.length,
        fundName: first.fundName,
        natureOfMeeting: first.natureOfMeeting,
        reps: first.reps,
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

  void toggleTimeSlot(int index) {
    final currentState = state;
    if (currentState is! DashboardLoaded) return;
    final updatedSlots = List<TimeSlot>.from(currentState.timeSlots);
    updatedSlots[index] = updatedSlots[index].copyWith(isExpanded: !updatedSlots[index].isExpanded);
    emit(currentState.copyWith(timeSlots: updatedSlots));
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