import 'package:conferance_application/config/appConfigUtils/local_storage_key.dart';
import 'package:conferance_application/config/appConfigUtils/localstorage.dart';
import 'package:conferance_application/config/constant/assetspath.dart';
import 'package:conferance_application/config/constant/colorsutils.dart';
import 'package:conferance_application/data/models/dashboard/dashboard_response_model.dart';
import 'package:conferance_application/features/login_screen/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

const Color _darkBlue = Color(0xFF2B2E8C);
const Color _gold = Color(0xFFFFC107);

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
                _buildHeader(state.agicMeetings.first.meetingSlots.first.meetings.first.name ?? ''),
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

  Widget _buildHeader(String title) {
    return Container(
      padding: EdgeInsets.only(top: 50.h, left: 16.w, right: 16.w, bottom: 16.h),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: _darkBlue),
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
                      color: isSelected ? _darkBlue : Colors.transparent,
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
                    color: isSelected ? _darkBlue : Colors.grey[600],
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
                              border: Border.all(color: orangeListItem, width: 2),
                            ),
                            child: Center(
                              child: Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: const BoxDecoration(
                                  color: orangeListItem,
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
                              color: orangeListItem,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (timeSlot.isExpanded && timeSlot.meetings.isNotEmpty)
                    ...timeSlot.meetings.asMap().entries.map(
                      (e) => _buildMeetingItem(context, index, e.key, e.value),
                    ),
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
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: Row(
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: orangeListItem, width: 2),
                            ),
                            child: Center(
                              child: Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: const BoxDecoration(
                                  color: orangeListItem,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              corporate.corporateName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: orangeListItem,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                            size: 22.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (corporate.isExpanded)
                    ...corporate.timeSlots.asMap().entries.map(
                      (tsEntry) => _buildCorporateSlotItem(
                        context, index, tsEntry.key, tsEntry.value, corporate.corporateName),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCorporateSlotItem(BuildContext context, int slotIndex, int timeSlotIndex, CorporateTimeSlot slot, String corporateName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  slot.time,
                  style: TextStyle(fontSize: 16.sp, color: Colors.orange, fontWeight: FontWeight.w600),
                ),
              ),
              ...slot.entries.map((entry) {
                final total = entry.fundGroups.fold(0, (sum, f) => sum + f.clientNames.length);
                final attended = entry.fundGroups.fold(0, (sum, f) => sum + f.attendedFlags.where((a) => a).length);
                return Row(
                  children: [
                    Text('T', style: TextStyle(fontSize: 13.sp, color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4.w),
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
                      child: Center(child: Text('$total', style: TextStyle(fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.bold))),
                    ),
                    SizedBox(width: 8.w),
                    Text('A', style: TextStyle(fontSize: 13.sp, color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4.w),
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.5)),
                      child: Center(child: Text('$attended', style: TextStyle(fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.bold))),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        ...slot.entries.asMap().entries.map((eEntry) {
          final entryIndex = eEntry.key;
          final entry = eEntry.value;
          final extraCount = entry.attendeeCount;
          return Container(
            padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[100]!, width: 1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + label
                SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.28,
                      child: Image.asset(
                        _getMeetingIcon(entry.natureOfMeeting),
                       fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company name + Room No label
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              corporateName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: lightBlueCompanyName,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Room No',
                            style: TextStyle(fontSize: 12.sp, color: purpleRoomNo, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      // First rep + N More + room number
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  entry.contactPerson,
                                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                                ),
                                if (extraCount > 0) ...[
                                  SizedBox(width: 6.w),
                                  GestureDetector(
                                    onTap: () => context.read<DashboardCubit>().toggleCorporateMeetingReps(
                                          slotIndex, timeSlotIndex, entryIndex),
                                    child: Text(
                                      entry.isRepsExpanded ? '...Hide' : '...$extraCount More',
                                      style: TextStyle(fontSize: 12.sp, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Text(
                            entry.roomNo,
                            style: TextStyle(fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // Expanded reps (skip first)
                      if (entry.isRepsExpanded && entry.allReps.length > 1)
                        ...entry.allReps.skip(1).map((rep) => Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(rep.name, style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                            )),
                      SizedBox(height: 6.h),
                      // Fund groups
                      ...entry.fundGroups.map((fund) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fund.fundName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: blueFundName,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              ...fund.clientNames.asMap().entries.map((e) => Padding(
                                    padding: EdgeInsets.only(bottom: 2.h),
                                    child: Text(
                                      e.value,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: (e.key < fund.attendedFlags.length && fund.attendedFlags[e.key])
                                            ? Colors.green[800]
                                            : Colors.black87,
                                        fontWeight: (e.key < fund.attendedFlags.length && fund.attendedFlags[e.key])
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 4.h),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _getMeetingIcon(String natureOfMeeting) {
    switch (natureOfMeeting) {
      case '1-1':  return AssetsPath.one_in_one;
      case '2-1': return AssetsPath.two_in_one;
      case '3-1': return AssetsPath.three_in_one;
      case '4-1': return AssetsPath.four_in_one;
      case 'Small Group': return AssetsPath.group_icon;
      default: return AssetsPath.mtrack_icon; // Workshop + else
    }
  }

  Widget _buildMeetingItem(BuildContext context, int slotIndex, int meetingIndex, Meeting meeting) {
    final extraCount = meeting.attendeeCount;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: avatar icon
          SizedBox(
            width: 40.w,
            height: 40.h,
            child: ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.28,
                child: Image.asset(
                  _getMeetingIcon(meeting.natureOfMeeting),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Right content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company name + Room No label
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        meeting.companyName.toUpperCase(),
                        style: TextStyle(fontSize: 16.sp, color: lightBlueCompanyName, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text('Room No', style: TextStyle(fontSize: 12.sp, color: purpleRoomNo, fontWeight: FontWeight.w600)),
                  ],
                ),
                // First rep name + ...N More (tappable) + Room number
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(meeting.contactPerson, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                          if (extraCount > 0) ...[
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () => context.read<DashboardCubit>().toggleMeetingReps(slotIndex, meetingIndex),
                              child: Text(
                                meeting.isRepsExpanded ? '...Hide' : '...$extraCount More',
                                style: TextStyle(fontSize: 14.sp, color: Colors.black),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(meeting.roomNo, style: TextStyle(fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
                // Expanded reps (all except first)
                if (meeting.isRepsExpanded && meeting.allReps.length > 1)
                  ...meeting.allReps.skip(1).map((rep) => Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(rep.name, style: TextStyle(fontSize: 12.sp, color: Colors.black87)),
                      )),
                SizedBox(height: 6.h),
                // Fund groups
                ...meeting.fundGroups.map((fund) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fund.fundName,
                          style: TextStyle(fontSize: 14.sp, color: blueFundName, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 2.h),
                        ...fund.clientNames.map((name) => Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: Text(name, style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                            )),
                        SizedBox(height: 4.h),
                      ],
                    )),
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
                  color: state.selectedBottomIndex == 0 ? _darkBlue : Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time,
                        color: state.selectedBottomIndex == 0 ? Colors.white : Colors.grey[600], size: 20.sp),
                    SizedBox(height: 4.h),
                    Text('Time Wise',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: state.selectedBottomIndex == 0 ? Colors.white : Colors.grey[600])),
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
                  color: state.selectedBottomIndex == 1 ? _darkBlue : Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.business,
                        color: state.selectedBottomIndex == 1 ? Colors.white : Colors.grey[600], size: 20.sp),
                    SizedBox(height: 4.h),
                    Text('Corporate Wise',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: state.selectedBottomIndex == 1 ? Colors.white : Colors.grey[600])),
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
