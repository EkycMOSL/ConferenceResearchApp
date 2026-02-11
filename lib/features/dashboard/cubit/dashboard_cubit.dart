import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  void loadDashboard() {
    emit(DashboardLoading());
    
    try {
      final days = ['DAY 1', 'DAY 2', 'DAY 3'];
      final timeSlots = [
        TimeSlot(
          time: '08:00 AM',
          meetings: [
            const Meeting(
              companyName: 'RADICO KHAITAN LTD',
              contactPerson: 'DILIP K BANTHIYA',
              roomNo: '5108',
              attendees: ['Oxbow Capital Management (HK)', 'AMITOJ SAINI', 'SHALABH AGRAWAL'],
              attendeeCount: 1,
            ),
          ],
        ),
        TimeSlot(
          time: '09:00 AM',
          meetings: [
            const Meeting(
              companyName: 'KAYNES TECHNOLOGY INDIA LTD',
              contactPerson: 'JAIRAM P SAMPATH',
              roomNo: '5127',
              attendees: ['PGIM India Mutual Fund', 'NEEL NADKARNI', 'Pan View Capital', 'SREERAM VISWAMANI', 'Oxbow Capital', 'PRITESH VAKIL', 'AKSHAY SAWANT', 'NILESH LOWARE'],
              attendeeCount: 1,
            ),
            const Meeting(
              companyName: 'KAYNES TECHNOLOGY INDIA LTD',
              contactPerson: 'JAIRAM P SAMPATH',
              roomNo: '5127',
              attendees: ['PGIM India Mutual Fund', 'NEEL NADKARNI', 'Pan View Capital', 'SREERAM VISWAMANI', 'Oxbow Capital', 'PRITESH VAKIL', 'AKSHAY SAWANT', 'NILESH LOWARE'],
              attendeeCount: 1,
            )
          ],
        ),
        TimeSlot(
          time: '10:00 AM',
          meetings: [
            const Meeting(
              companyName: 'AU SMALL FINANCE BANK LTD',
              contactPerson: 'GAURAV JAIN',
              roomNo: '5890',
              attendees: ['ICICI Pru Life', 'DEEP TIWARI'],
              attendeeCount: 1,
            ),
          ],
        ),
        const TimeSlot(time: '11:00 AM'),
        const TimeSlot(time: '12:00 PM'),
        const TimeSlot(time: '13:00 PM'),
        const TimeSlot(time: '14:00 PM'),
        const TimeSlot(time: '15:00 PM'),
        const TimeSlot(time: '16:00 PM'),
        const TimeSlot(time: '17:00 PM'),
      ];

      emit(DashboardLoaded(
        selectedDayIndex: 0,
        days: days,
        timeSlots: timeSlots,
        selectedBottomIndex: 0,
      ));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard: ${e.toString()}'));
    }
  }

  void selectDay(int index) {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(currentState.copyWith(selectedDayIndex: index));
    }
  }

  void selectBottomTab(int index) {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      emit(currentState.copyWith(selectedBottomIndex: index));
    }
  }

  void toggleTimeSlot(int index) {
    final currentState = state;
    if (currentState is DashboardLoaded) {
      final updatedSlots = List<TimeSlot>.from(currentState.timeSlots);
      updatedSlots[index] = updatedSlots[index].copyWith(
        isExpanded: !updatedSlots[index].isExpanded,
      );
      emit(currentState.copyWith(timeSlots: updatedSlots));
    }
  }

  void refreshDashboard() {
    loadDashboard();
  }
}