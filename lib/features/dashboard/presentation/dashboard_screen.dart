import 'package:conferance_application/config/appConfigUtils/local_storage_key.dart';
import 'package:conferance_application/config/appConfigUtils/localstorage.dart';
import 'package:conferance_application/data/models/dashboard/corporate_response_model.dart';
import 'package:conferance_application/data/models/dashboard/dashboard_response_model.dart';
import 'package:conferance_application/features/login_screen/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardResponseModel responseModel;
  final String clientCode;

  const DashboardScreen({super.key, required this.responseModel, required this.clientCode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit()..loadFromModel(responseModel, clientCode: clientCode),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
          
          if (state is DashboardLoaded) {
            return Column(
              children: [
                _buildHeader(),
                _buildDayTabs(context, state),
                Expanded(
                  child: state.selectedBottomIndex == 0
                      ? _buildTimeSlots(state)
                      : _buildCorporateList(state),
                ),
                SafeArea(
                  top: false,
                  child: _buildBottomNavigation(context, state),
                ),
              ],
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: 50.h, left: 16.w, right: 16.w, bottom: 16.h),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'CONFERENCE RESEARCH APP',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Builder(
            builder: (context) => GestureDetector(
              onTap: () async {
                await LocalStorage.removeString(LocalStorageKeyName.clientCode);
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreenScreen()),
                    (_) => false,
                  );
                }
              },
              child: Icon(Icons.power_settings_new, color: Colors.red, size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTabs(BuildContext context, DashboardLoaded state) {
    return Container(
      color: Colors.grey[300],
      child: Row(
        children: List.generate(state.days.length, (index) {
          final isSelected = state.selectedDayIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => context.read<DashboardCubit>().selectDay(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  state.days[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue : Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimeSlots(DashboardLoaded state) {
    return Builder(
      builder: (context) => RefreshIndicator(
        onRefresh: () => context.read<DashboardCubit>().refreshData(),
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: state.timeSlots.length,
          itemBuilder: (context, index) {
            final timeSlot = state.timeSlots[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => context.read<DashboardCubit>().toggleTimeSlot(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: Row(
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.orange, width: 2),
                            ),
                            child: Center(
                              child: Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            timeSlot.time,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (timeSlot.isExpanded && timeSlot.meetings.isNotEmpty)
                    ...timeSlot.meetings.map((meeting) => _buildMeetingItem(meeting)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCorporateList(DashboardLoaded state) {
    if (state.corporateSlots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Builder(
      builder: (context) => RefreshIndicator(
        onRefresh: () => context.read<DashboardCubit>().refreshData(),
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: state.corporateSlots.length,
          itemBuilder: (context, index) {
            final corporate = state.corporateSlots[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => context.read<DashboardCubit>().toggleCorporateSlot(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      child: Row(
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: Center(
                              child: Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              corporate.corporateName,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                            ),
                          ),
                          Icon(
                            corporate.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (corporate.isExpanded)
                    ...corporate.slots.map((slot) => _buildCorporateSlotItem(slot)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCorporateSlotItem(CorporateMeetingSlot slot) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slot.meetingSlotTime,
            style: TextStyle(fontSize: 13.sp, color: Colors.orange, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6.h),
          ...slot.meetings.map((m) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.fundName, style: TextStyle(fontSize: 13.sp, color: Colors.blue, fontWeight: FontWeight.w500)),
                          Text(m.clientName, style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                        ],
                      ),
                    ),
                    Text('Room ${m.roomNo}', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                  ],
                ),
                if (m.reps.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Divider(height: 1, color: Colors.grey[300]),
                  SizedBox(height: 4.h),
                  Text('Representatives', style: TextStyle(fontSize: 11.sp, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                  SizedBox(height: 3.h),
                  ...m.reps.map((rep) => Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: Row(
                      children: [
                        Icon(Icons.person_outline, size: 13.sp, color: Colors.grey[500]),
                        SizedBox(width: 4.w),
                        Text(rep.name, style: TextStyle(fontSize: 12.sp, color: Colors.black87, fontWeight: FontWeight.w500)),
                        SizedBox(width: 4.w),
                        Text('(${rep.designation.trim()})', style: TextStyle(fontSize: 11.sp, color: Colors.grey[600])),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMeetingItem(Meeting meeting) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Icon(Icons.person, color: Colors.white, size: 24.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        meeting.companyName,
                        style: TextStyle(fontSize: 14.sp, color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text('Room No', style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(meeting.contactPerson, style: TextStyle(fontSize: 13.sp, color: Colors.black87)),
                    Text(meeting.roomNo, style: TextStyle(fontSize: 13.sp, color: Colors.black, fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 6.h),
                ...meeting.attendees.map((attendee) => Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(attendee, style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                )),
                if (meeting.reps.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Divider(height: 1, color: Colors.grey[300]),
                  SizedBox(height: 6.h),
                  Text('Representatives', style: TextStyle(fontSize: 11.sp, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                  SizedBox(height: 4.h),
                  ...meeting.reps.map((rep) => Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: Row(
                      children: [
                        Icon(Icons.person_outline, size: 13.sp, color: Colors.grey[500]),
                        SizedBox(width: 4.w),
                        Text(rep.name, style: TextStyle(fontSize: 12.sp, color: Colors.black87, fontWeight: FontWeight.w500)),
                        SizedBox(width: 4.w),
                        Text('(${rep.designation.trim()})', style: TextStyle(fontSize: 11.sp, color: Colors.grey[600])),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, DashboardLoaded state) {
    return Container(
      color: Colors.grey[300],
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.read<DashboardCubit>().selectBottomTab(0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: state.selectedBottomIndex == 0 ? Colors.blue : Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: state.selectedBottomIndex == 0 ? Colors.white : Colors.grey[600],
                      size: 20.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Time Wise',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: state.selectedBottomIndex == 0 ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => context.read<DashboardCubit>().selectBottomTab(1),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: state.selectedBottomIndex == 1 ? Colors.blue : Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.business,
                      color: state.selectedBottomIndex == 1 ? Colors.white : Colors.grey[600],
                      size: 20.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Corporate Wise',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: state.selectedBottomIndex == 1 ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}